function plot_all_patients_pressure_and_area()
    % PLOT_ALL_PATIENTS_JOINT_MECHANICS_COMBINED Generates and saves a combined plot of mean joint mechanics with confidence intervals for all patients.
    %
    % This function processes joint mechanics data from all patient result files in the specified directory,
    % normalizes the data to one gait cycle, calculates the mean and confidence intervals, and visualizes
    % the data in a single figure with three subplots for each metric.
    %
    % Inputs:
    %   None
    %
    % Outputs:
    %   None (saves figure as PNG file).
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
    labels = {'mean_contact_pressure', 'max_contact_pressure', 'contact_area'};
    all_joint_mech_data = struct();
    for i = 1:length(labels)
        all_joint_mech_data.(labels{i}) = [];
        all_joint_mech_data.([labels{i} '_medial']) = [];
        all_joint_mech_data.([labels{i} '_lateral']) = [];
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
        all_joint_mech_data.mean_contact_pressure = ...
            [all_joint_mech_data.mean_contact_pressure; resampled_forces_data(:, 584)'];
        all_joint_mech_data.mean_contact_pressure_medial = ...
            [all_joint_mech_data.mean_contact_pressure_medial; resampled_forces_data(:, 635)'];
        all_joint_mech_data.mean_contact_pressure_lateral = ...
            [all_joint_mech_data.mean_contact_pressure_lateral; resampled_forces_data(:, 636)'];

        all_joint_mech_data.max_contact_pressure = ...
            [all_joint_mech_data.max_contact_pressure; resampled_forces_data(:, 585)'];
        all_joint_mech_data.max_contact_pressure_medial = ...
            [all_joint_mech_data.max_contact_pressure_medial; resampled_forces_data(:, 641)'];
        all_joint_mech_data.max_contact_pressure_lateral = ...
            [all_joint_mech_data.max_contact_pressure_lateral; resampled_forces_data(:, 642)'];

        all_joint_mech_data.contact_area = ...
            [all_joint_mech_data.contact_area; resampled_forces_data(:, 578)' * 1000000];
        all_joint_mech_data.contact_area_medial = ...
            [all_joint_mech_data.contact_area_medial; resampled_forces_data(:, 599)' * 1000000];
        all_joint_mech_data.contact_area_lateral = ...
            [all_joint_mech_data.contact_area_lateral; resampled_forces_data(:, 600)' * 1000000];
    end

    % Turn warnings back on
    warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Calculate mean and std across patients for each joint mechanics variable
    mean_joint_mech = structfun(@(x) mean(x, 1)', all_joint_mech_data, 'UniformOutput', false);
    std_joint_mech = structfun(@(x) std(x, [], 1)', all_joint_mech_data, 'UniformOutput', false);
    ci_joint_mech = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_joint_mech, 'UniformOutput', false);

    % Define display names mapping
    display_names = containers.Map(...
        {'mean_contact_pressure', 'max_contact_pressure', 'contact_area'}, ...
        {'Mean Contact Pressure', 'Max Contact Pressure', 'Contact Area'});

    % Plot and save combined joint mechanics data
    plot_and_save_combined_joint_mechanics(labels, 'Pressure (MPa)', 'Area (mm^2)', Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names);
end

function plot_and_save_combined_joint_mechanics(labels, pressure_y_label, area_y_label, Time_normed, mean_joint_mech, ci_joint_mech, output_directory, display_names)
    % PLOT_AND_SAVE_COMBINED_JOINT_MECHANICS Plots and saves combined joint mechanics variables with confidence intervals in subplots.
    %
    % Inputs:
    %   labels - Cell array of labels for the plots
    %   pressure_y_label - Y-axis label for the pressure plots
    %   area_y_label - Y-axis label for the area plots
    %   Time_normed - Normalized time array
    %   mean_joint_mech - Struct containing mean joint mechanics data
    %   ci_joint_mech - Struct containing confidence interval data
    %   output_directory - Directory to save the output files
    %   display_names - Map of display names for the labels
    %
    % Outputs:
    %   None (saves figure as PNG file)

    % Create a new figure
    combined_fig = figure('Name', 'Joint Mechanics Combined', 'Position', [100, 100, 1200, 800], 'Color', 'w', 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);

    for i = 1:length(labels)
        label = labels{i};
        subplot(3, 1, i);
        hold on;

        if contains(label, 'pressure')
            ylabel_text = pressure_y_label;
        else
            ylabel_text = area_y_label;
        end

        % Define line properties including color
        linePropsTotal = {'-k', 'LineWidth', 3, 'Color', 'k'};
        linePropsMedial = {'-r', 'LineWidth', 3, 'Color', 'r'};
        linePropsLateral = {'-b', 'LineWidth', 3, 'Color', 'b'};
        
        % Plot mean data with shaded error bars
        shadedErrorBar(Time_normed, mean_joint_mech.(labels{i}), ci_joint_mech.(labels{i}), linePropsTotal, 'k', 0.2); % Total
        shadedErrorBar(Time_normed, mean_joint_mech.([labels{i} '_medial']), ci_joint_mech.([labels{i} '_medial']), linePropsMedial, 'r', 0.2); % Medial
        shadedErrorBar(Time_normed, mean_joint_mech.([labels{i} '_lateral']), ci_joint_mech.([labels{i} '_lateral']), linePropsLateral, 'b', 0.2); % Lateral

        title(display_names(label));
        ylabel(ylabel_text);
        xlabel('Gait Cycle [%]');
        legend('Total', '', 'Medial', '', 'Lateral');
        grid on;
        set(gca, 'GridAlpha', 0.3);
    end

    % Save the combined figure
    saveas(combined_fig, fullfile(output_directory, 'combined_joint_mechanics_plot.png'));
    close(combined_fig);
end
