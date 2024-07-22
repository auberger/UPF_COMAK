function plot_all_patients_joint_mechanics()
    % PLOT_ALL_PATIENTS_JOINT_MECHANICS Generates and saves plots of mean joint mechanics with confidence intervals for all patients.
    %
    % This function processes joint mechanics data from all patient result files in the specified directory,
    % normalizes the data to one gait cycle, calculates the mean and confidence intervals, and visualizes
    % the data in individual plots for each metric.
    %
    % Inputs:
    %   None
    %
    % Outputs:
    %   None (saves figure as PNG files).
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Define directories
    results_directory = '../results';
    output_directory = '../mean_results/joint_mechanics';

    % Create output directory if it doesn't exist
    if ~exist(output_directory, 'dir')
        mkdir(output_directory);
    end

    % Set parameters
    Time_steps = 100;
    Time_normed = linspace(0, 100, Time_steps);
    ftype = fittype('linearinterp');

    % Initialize data storage for each joint mechanics variable
    contact_forces_labels = {'contact_force_ap', 'contact_force_si', 'contact_force_ml'};
    reaction_moments_labels = {'reaction_moment_ap', 'reaction_moment_si', 'reaction_moment_ml'};
    cop_labels = {'cop_ap', 'cop_si', 'cop_ml'};

    all_labels = [contact_forces_labels, reaction_moments_labels, cop_labels];

    all_joint_mech_data = struct();
    for i = 1:length(all_labels)
        all_joint_mech_data.(all_labels{i}) = [];
        all_joint_mech_data.([all_labels{i} '_medial']) = [];
        all_joint_mech_data.([all_labels{i} '_lateral']) = [];
    end

    % Suppress warnings temporarily
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Get all subdirectories in the results directory, excluding specified ones
    subdirs = dir(results_directory);
    subdirs = subdirs([subdirs.isdir]);
    exclude_dirs = {'.', '..', 'images_for_visualizations', 'paraview_template_files', 'reports'};
    subdirs = subdirs(~ismember({subdirs.name}, exclude_dirs));

    % Iterate through each patient directory
    for i = 1:length(subdirs)
        subdir = subdirs(i).name;
        project_patient_dir = fullfile(results_directory, subdir, 'joint_mechanics');
        patient_id = subdir(end-2:end); % last 3 characters of the directory name

        % Try to load simulation joint mechanics data
        try
            [forces_data, ~, ~] = read_opensim_mot(fullfile(project_patient_dir, ['walking_' patient_id '_ForceReporter_forces.sto']));
        catch
            disp(['ERROR: Simulation results not found for ' subdir '!']);
            continue;
        end

        % Normalize and resample simulation data
        time = forces_data(:, 1);
        time_normed = (time - time(1)) / (time(end) - time(1)) * 100;
        resampled_forces_data = zeros(length(Time_normed), size(forces_data, 2));
        for j = 2:size(forces_data, 2) % Start from 2 to skip the time column
            fit_values = fit(time_normed, forces_data(:, j), ftype);
            resampled_forces_data(:, j) = feval(fit_values, Time_normed');
        end

        % Append resampled joint mechanics data to the corresponding variable field
        for k = 1:3
            all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end)]) = ...
                [all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end)]); resampled_forces_data(:, 588 + k)'];
            all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end) '_medial']) = ...
                [all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end) '_medial']); resampled_forces_data(:, 672 + k)'];
            all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end) '_lateral']) = ...
                [all_joint_mech_data.(['contact_force' contact_forces_labels{k}(14:end) '_lateral']); resampled_forces_data(:, 675 + k)'];

            all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end)]) = ...
                [all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end)]); resampled_forces_data(:, 591 + k)'];
            all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end) '_medial']) = ...
                [all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end) '_medial']); resampled_forces_data(:, 690 + k)'];
            all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end) '_lateral']) = ...
                [all_joint_mech_data.(['reaction_moment' reaction_moments_labels{k}(16:end) '_lateral']); resampled_forces_data(:, 693 + k)'];

            all_joint_mech_data.(['cop_' cop_labels{k}(5:end)]) = ...
                [all_joint_mech_data.(['cop_' cop_labels{k}(5:end)]); resampled_forces_data(:, 585 + k)' * 1000];
            all_joint_mech_data.(['cop_' cop_labels{k}(5:end) '_medial']) = ...
                [all_joint_mech_data.(['cop_' cop_labels{k}(5:end) '_medial']); resampled_forces_data(:, 654 + k)' * 1000];
            all_joint_mech_data.(['cop_' cop_labels{k}(5:end) '_lateral']) = ...
                [all_joint_mech_data.(['cop_' cop_labels{k}(5:end) '_lateral']); resampled_forces_data(:, 657 + k)' * 1000];
        end
    end

    % Turn warnings back on
    warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Calculate mean and std across patients for each joint mechanics variable
    mean_joint_mech = structfun(@(x) mean(x, 1)', all_joint_mech_data, 'UniformOutput', false);
    std_joint_mech = structfun(@(x) std(x, [], 1)', all_joint_mech_data, 'UniformOutput', false);
    ci_joint_mech = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_joint_mech, 'UniformOutput', false);

    % Define display names mapping
    display_names = containers.Map(...
        {'contact_force_ap', 'contact_force_si', 'contact_force_ml', ...
         'reaction_moment_ap', 'reaction_moment_si', 'reaction_moment_ml', ...
         'cop_ap', 'cop_si', 'cop_ml'}, ...
        {'Contact Force Anterior-Posterior', 'Contact Force Superior-Inferior', 'Contact Force Medial-Lateral', ...
         'Reaction Moment Anterior-Posterior', 'Reaction Moment Superior-Inferior', 'Reaction Moment Medial-Lateral', ...
         'Center of Pressure Anterior-Posterior', 'Center of Pressure Superior-Inferior', 'Center of Pressure Medial-Lateral'});

    % Plot and save individual plots for each metric
    plot_and_save_individual_joint_mechanics(contact_forces_labels, 'Force [N]', Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names);
    plot_and_save_individual_joint_mechanics(reaction_moments_labels, 'Moment [Nm]', Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names);
    plot_and_save_individual_joint_mechanics(cop_labels, 'Position [mm]', Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names);
end

function plot_and_save_individual_joint_mechanics(labels, y_label, Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names)
    % PLOT_AND_SAVE_INDIVIDUAL_JOINT_MECHANICS Plots and saves individual joint mechanics variables with confidence intervals.
    %
    % Inputs:
    %   labels - Cell array of labels for the plots
    %   y_label - Y-axis label for the plots
    %   Time_normed - Normalized time array
    %   mean_joint_mech - Struct containing mean joint mechanics data
    %   ci_joint_mech - Struct containing confidence interval data
    %   output_directory - Directory to save the output files
    %   display_names - Map of display names for the labels
    %
    % Outputs:
    %   None (saves figure as PNG files)

    for i = 1:length(labels)
        label = labels{i};
        joint_mech_fig = figure('Name', display_names(label), 'Position', [100, 100, 1000, 600], 'Color', 'w', 'Visible', 'off');
        set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
        hold on;
        
        % Define line properties including color
        linePropsTotal = {'-k', 'LineWidth', 3, 'Color', 'k'};
        linePropsMedial = {'-r', 'LineWidth', 3, 'Color', 'r'};
        linePropsLateral = {'-b', 'LineWidth', 3, 'Color', 'b'};
        
        % Plot mean data with shaded error bars
        shadedErrorBar(Time_normed, mean_joint_mech.(labels{i}), ci_joint_mech.(labels{i}), linePropsTotal, 'k', 0.2); % Total
        
        shadedErrorBar(Time_normed, mean_joint_mech.([labels{i} '_medial']), ci_joint_mech.([labels{i} '_medial']), linePropsMedial, 'r', 0.2); % Medial
        
        shadedErrorBar(Time_normed, mean_joint_mech.([labels{i} '_lateral']), ci_joint_mech.([labels{i} '_lateral']), linePropsLateral, 'b', 0.2); % Lateral

        title(display_names(label));
        ylabel(y_label);
        xlabel('Gait Cycle [%]');
        legend('Total', '', 'Medial', '', 'Lateral')
        grid on;
        set(gca, 'GridAlpha', 0.3);

        % Save figure
        saveas(joint_mech_fig, fullfile(output_directory, [strrep(display_names(label), ' ', '_') '_plot.png']));
        close(joint_mech_fig);
    end
end
