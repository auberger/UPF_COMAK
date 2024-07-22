function plot_all_patients_kinematics()
    % PLOT_ALL_PATIENTS_KINEMATICS Generates and saves plots of mean kinematics with confidence intervals for tibiofemoral and patellofemoral joints across all patients.
    %
    % This function processes kinematic data from all patient result files in the specified directory,
    % normalizes the data to one gait cycle, calculates the mean and confidence intervals, and visualizes
    % the data in four output files, each containing three subplots.
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
    output_directory = '../mean_results/kinematics';

    % Create output directory if it doesn't exist
    if ~exist(output_directory, 'dir')
        mkdir(output_directory);
    end

    % Set parameters
    Time_steps = 100;
    Time_normed = linspace(0, 100, Time_steps);
    ftype = fittype('linearinterp');

    % Initialize data storage for each kinematic variable
    tf_coords_rot = {'knee_flex_r', 'knee_add_r', 'knee_rot_r'};
    tf_coords_trans = {'knee_tx_r', 'knee_ty_r', 'knee_tz_r'};
    pf_coords_rot = {'pf_flex_r', 'pf_rot_r', 'pf_tilt_r'};
    pf_coords_trans = {'pf_tx_r', 'pf_ty_r', 'pf_tz_r'};

    all_labels = [tf_coords_rot, tf_coords_trans, pf_coords_rot, pf_coords_trans];

    all_kin_data = struct();
    for i = 1:length(all_labels)
        all_kin_data.(all_labels{i}) = [];
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
        project_patient_dir = fullfile(results_directory, subdir, 'comak');
        patient_id = subdir(end-2:end); % last 3 characters of the directory name

        % Try to load simulation kinematic data
        try
            [values_data, values_labels, ~] = read_opensim_mot(fullfile(project_patient_dir, ['walking_' patient_id '_values.sto']));
        catch
            disp(['ERROR: Simulation results not found for ' subdir '!']);
            continue;
        end

        % Normalize and resample simulation data
        time = values_data(:, 1);
        time_normed = (time - time(1)) / (time(end) - time(1)) * 100;
        resampled_values_data = zeros(length(Time_normed), size(values_data, 2));
        for j = 2:size(values_data, 2) % Start from 2 to skip the time column
            fit_values = fit(time_normed, values_data(:, j), ftype);
            resampled_values_data(:, j) = feval(fit_values, Time_normed');
        end

        % Append resampled kinematic data to the corresponding variable field
        for j = 1:length(all_labels)
            ind = find(contains(values_labels, all_labels{j}));
            if ~isempty(ind)
                all_kin_data.(all_labels{j}) = [all_kin_data.(all_labels{j}); resampled_values_data(:, ind)'];
            end
        end
    end

    % Turn warnings back on
    warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Calculate mean and std across patients for each kinematic variable
    mean_kin = structfun(@(x) mean(x, 1)', all_kin_data, 'UniformOutput', false);
    std_kin = structfun(@(x) std(x, [], 1)', all_kin_data, 'UniformOutput', false);
    ci_kin = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_kin, 'UniformOutput', false);

    % Define display names mapping
    display_names = containers.Map(...
        {'knee_flex_r', 'knee_add_r', 'knee_rot_r', 'knee_tx_r', 'knee_ty_r', 'knee_tz_r', ...
        'pf_flex_r', 'pf_rot_r', 'pf_tilt_r', 'pf_tx_r', 'pf_ty_r', 'pf_tz_r'}, ...
        {'Knee Flexion', 'Knee Adduction', 'Knee Internal Rotation', 'Knee Anterior Translation', ...
        'Knee Superior Translation', 'Knee Lateral Translation', 'Patellofemoral Flexion', ...
        'Patellofemoral Rotation', 'Patellofemoral Tilt', 'Patellofemoral Anterior Translation', ...
        'Patellofemoral Superior Translation', 'Patellofemoral Lateral Translation'});

    % Plot and save tibiofemoral rotations
    tf_coords_rot_plot = {{'knee_flex_r','knee_flex_r','Knee Flexion','Angle [deg]'},...
                          {'knee_add_r','knee_add_r','Knee Adduction','Angle [deg]'},...
                          {'knee_rot_r','knee_rot_r','Knee Internal Rotation','Angle [deg]'}};
    plot_and_save_kinematics(tf_coords_rot_plot, Time_normed, mean_kin, ci_kin, output_directory, 'tibiofemoral_rotations.png', 'Tibiofemoral Rotations');

    % Plot and save tibiofemoral translations
    tf_coords_trans_plot = {{'knee_tx_r','knee_tx_r','Knee Anterior Translation','Translation [mm]'},...
                            {'knee_ty_r','knee_ty_r','Knee Superior Translation','Translation [mm]'},...
                            {'knee_tz_r','knee_tz_r','Knee Lateral Translation','Translation [mm]'}};
    plot_and_save_kinematics(tf_coords_trans_plot, Time_normed, mean_kin, ci_kin, output_directory, 'tibiofemoral_translations.png', 'Tibiofemoral Translations');

    % Plot and save patellofemoral rotations
    pf_coords_rot_plot = {{'pf_flex_r','pf_flex_r','Patellofemoral Flexion','Angle [deg]'},...
                          {'pf_rot_r','pf_rot_r','Patellofemoral Rotation','Angle [deg]'},...
                          {'pf_tilt_r','pf_tilt_r','Patellofemoral Tilt','Angle [deg]'}};
    plot_and_save_kinematics(pf_coords_rot_plot, Time_normed, mean_kin, ci_kin, output_directory, 'patellofemoral_rotations.png', 'Patellofemoral Rotations');

    % Plot and save patellofemoral translations
    pf_coords_trans_plot = {{'pf_tx_r','pf_tx_r','Patellofemoral Anterior Translation','Translation [mm]'},...
                            {'pf_ty_r','pf_ty_r','Patellofemoral Superior Translation','Translation [mm]'},...
                            {'pf_tz_r','pf_tz_r','Patellofemoral Lateral Translation','Translation [mm]'}};
    plot_and_save_kinematics(pf_coords_trans_plot, Time_normed, mean_kin, ci_kin, output_directory, 'patellofemoral_translations.png', 'Patellofemoral Translations');
end

function plot_and_save_kinematics(coords, Time_normed, mean_kin, ci_kin, output_directory, save_filename, fig_name)
    % PLOT_AND_SAVE_KINEMATICS Plots and saves kinematic variables with confidence intervals.
    %
    % Inputs:
    %   coords - Cell array of coordinate details for the plots
    %   Time_normed - Normalized time array
    %   mean_kin - Struct containing mean kinematic data
    %   ci_kin - Struct containing confidence interval data
    %   output_directory - Directory to save the output files
    %   save_filename - Filename to save the plot
    %   fig_name - Figure title
    %
    % Outputs:
    %   None (saves figure as PNG files)

    kin_fig = figure('Name', fig_name, 'Position', [100, 100, 1000, 600], 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
    for i = 1:length(coords)
        subplot(3, 1, i);
        hold on;

        % Plot data
        label = coords{i}{1};
        if contains(coords{i}{4}, 'Translation')
            mean_data = mean_kin.(label) * 1000;
            ci_data = ci_kin.(label) * 1000;
        else
            mean_data = mean_kin.(label);
            ci_data = ci_kin.(label);
        end
        shadedErrorBar(Time_normed, mean_data, ci_data, {'-b', 'LineWidth', 2}, 0.2);
        title([coords{i}{3} ' (' strrep(coords{i}{2}, '_', '\_') ')']);
        ylabel(coords{i}{4})
        grid on;
        set(gca, 'GridAlpha', 0.3);
    end
    xlabel('Gait Cycle [%]')

    % Save figure
    saveas(kin_fig, fullfile(output_directory, save_filename))
    close(kin_fig);
end
