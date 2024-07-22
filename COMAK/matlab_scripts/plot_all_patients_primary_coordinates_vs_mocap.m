function plot_all_patients_primary_coordinates_vs_mocap()
    % PLOT_ALL_PATIENTS_PRIMARY_COORDINATES_VS_MOCAP Compares primary coordinates from motion capture and simulation for all patients.
    %
    % This function processes all patient result files in the specified directory, normalizes the 
    % data to one gait cycle, calculates the mean and standard deviation, and compares knee flexion-extension angles with motion capture data.
    % It visualizes the mean and standard deviation with a 95% confidence interval band.
    %
    % Inputs:
    %   None
    %
    % Outputs: 
    %   None (saves figure as a PNG file).
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Define directories
    results_directory = '../results';
    data_directory = '../processed_data';
    output_directory = '../mean_results/validation';
    
    % Create output directory if it doesn't exist
    if ~exist(output_directory, 'dir')
        mkdir(output_directory);
    end

    % Set parameters
    Time_steps = 100;
    Time_normed = 0:Time_steps;
    ftype = fittype('linearinterp');

    % Initialize data storage
    all_values_data = [];
    all_mocap_data = [];
    all_rmse = [];
    all_max_err = [];
    
    % Suppress warnings temporarily
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
    
    % Get all subdirectories in the results directory, excluding specified ones
    subdirs = dir(results_directory);
    subdirs = subdirs([subdirs.isdir]);
    exclude_dirs = {'.', '..', 'images_for_visualizations', 'paraview_template_files'};
    subdirs = subdirs(~ismember({subdirs.name}, exclude_dirs));
    
    for i = 1:length(subdirs)
        subdir = subdirs(i).name;
        project_patient_dir = fullfile(results_directory, subdir, 'comak');
        patient_id = subdir(end-2:end); % last 3 characters of the directory name
    
        % Try to load simulation data
        try
            [values_data, values_labels, ~] = read_opensim_mot(fullfile(project_patient_dir, ['walking_' patient_id '_values.sto']));
        catch
            disp(['ERROR: Simulation results not found for ' subdir '!']);
            continue;
        end
    
        % Normalize and resample simulation data
        time_data = values_data(:, 1);
        time_norm = linspace(0, max(Time_normed), length(time_data));
        resampled_values_data = zeros(length(Time_normed), size(values_data, 2));
        resampled_values_data(:, 1) = Time_normed;
        for j = 2:size(values_data, 2) % Start from 2 to skip the time column
            fit_1 = fit(time_norm', values_data(:, j), ftype);
            resampled_values_data(:, j) = feval(fit_1, Time_normed');
        end
    
        % Append resampled simulation data to all_values_data
        all_values_data = cat(3, all_values_data, resampled_values_data);
    
        % Load motion capture data
        mocap_files = dir(fullfile(data_directory, subdir, 'walking', '*Angle*'));
        if isempty(mocap_files)
            disp(['ERROR: Motion capture file not found for ' subdir '!']);
            continue;
        end
    
        % Construct the full path of the first matching file
        mocap_file_path = fullfile(mocap_files(1).folder, mocap_files(1).name);
        try
            mocap_data = readtable(mocap_file_path, 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 7);
        catch
            disp(['ERROR: Unable to read motion capture file for ' subdir '!']);
            continue;
        end
    
        % Extract and normalize motion capture data
        acmRKFE = mocap_data.acmRKFE_M;
        acm_time = linspace(0, max(Time_normed), length(acmRKFE));
        fit_mocap = fit(acm_time', acmRKFE, ftype);
        resampled_mocap_data = feval(fit_mocap, Time_normed');
        all_mocap_data = [all_mocap_data; resampled_mocap_data'];

        %% IK marker errors

        disp(['../results/' subdir '/comak_inverse_kinematics/walking_' patient_id '_ik_marker_errors.sto']);

        % Load marker error data for the patient
        try
            [error_data, ~, ~] = read_opensim_mot(['../results/' subdir '/comak_inverse_kinematics/walking_' patient_id '_ik_marker_errors.sto']);
        catch  
            disp('ERROR: Simulation IK marker error file not found!');
            return; % Exit the function if no data is found
        end

        % Append data    
        all_rmse = [all_rmse; error_data(:, 3)];
        all_max_err = [all_max_err; error_data(:, 4)];

    end

    % Calculate mean and std across patients for simulation data
    mean_values = mean(all_values_data, 3);
    std_values = std(all_values_data, [], 3);
    ci_sim = 1.96 * (std_values / sqrt(size(all_values_data, 3)));
    
    % Calculate mean and std across patients for mocap data
    mean_mocap = mean(all_mocap_data, 1)';
    std_mocap = std(all_mocap_data, [], 1);
    ci_mocap = 1.96 * (std_mocap / sqrt(size(all_mocap_data, 1)));
    
    % Ensure indices match
    n_patients_sim = size(all_values_data, 3);
    n_patients_mocap = size(all_mocap_data, 1);
    
    if n_patients_sim ~= n_patients_mocap
        error('Mismatch in number of patients between simulation and mocap data.');
    end
    
    %% Calculate IK error metrics

    % Compute the mean and standard deviation
    mean_err = mean(all_rmse);
    std_err = std(all_rmse);
    mean_max = mean(all_max_err);
    std_max = std(all_max_err);
    
    % Sample size
    n = size(error_data, 1);
    
    % Degrees of freedom
    df = n - 1;
    
    % t-value for 95% confidence interval
    alpha = 0.05;
    t_value = tinv(1 - alpha/2, df);
    
    % Compute the margin of error
    margin_of_error_err = t_value * (std_err / sqrt(n));
    margin_of_error_max = t_value * (std_max / sqrt(n));

    %% Plotting
    ind = find(contains(values_labels, 'knee_flex_r'));
    
    % Formatting parameters
    thin_line_width = 2;
    thick_line_width = 3;
    title_font_size = 18;
    label_font_size = 16;
    axes_font_size = 14;
    legend_font_size = 14;
    
    % Plot the data
    fig_mocap = figure('Name', 'Comparison of Knee Flexion-Extension Angles', 'Color', 'w', 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    subplot(2,1,1);
    
    % Plot mean and confidence interval for simulation data
    shadedErrorBar(Time_normed, mean_values(:, ind), ci_sim(:, ind), {'-b', 'LineWidth', thick_line_width}, [0 0 1]);
    hold on;
    
    % Plot mean and confidence interval for mocap data
    shadedErrorBar(Time_normed, mean_mocap, ci_mocap, {'-r', 'LineWidth', thick_line_width}, [1 0 0]);
    
    % Calculate MAE and Max Error
    mae_value = mean(abs(mean_mocap - mean_values(:, ind)));
    max_error = max(abs(mean_mocap - mean_values(:, ind)));
    
    % Display MAE and Max Error on the plot
    text(0.1, 0.9, sprintf('MAE: %.2f deg', mae_value), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.8, sprintf('Max Error: %.2f deg', max_error), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.65, sprintf('Marker errors of simulation IK results:'), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.55, sprintf('Mean and 95%% CI for RMS marker error for all patients and frames: %.2f ± %.2f cm\n', mean_err*100, margin_of_error_err*100), 'Units', 'normalized', 'FontSize', legend_font_size*0.8);
    text(0.1, 0.5, sprintf('Mean and 95%% CI for maximum marker for all patients and frames: %.2f ± %.2f cm\n', mean_max*100, margin_of_error_max*100), 'Units', 'normalized', 'FontSize', legend_font_size*0.8);

    % Display number of patients
    n_patients = size(all_values_data, 3);

    hold off;
    title('Comparison of Knee Flexion-Extension Angles', 'FontSize', title_font_size);
    xlabel('Gait cycle [%]', 'FontSize', label_font_size);
    ylabel('Angle [deg]', 'FontSize', label_font_size);
    legend('Mean Simulation Results', '', 'Mean Motion Capture Results', '', 'FontSize', legend_font_size);
    grid on;
    set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size);
    
    % Correlation subplot
    subplot(2,1,2);
    scatter(mean_mocap, mean_values(:, ind), 'filled');
    hold on;
    
    % Calculate and plot perfect agreement line (45 degree line)
    x = linspace(min(mean_mocap), max(mean_mocap), 100);
    plot(x, x, 'k--', 'LineWidth', thin_line_width);
    
    % Calculate and plot the linear regression line
    p = polyfit(mean_mocap, mean_values(:, ind), 1);
    yfit = polyval(p, mean_mocap);
    plot(mean_mocap, yfit, 'r-', 'LineWidth', thick_line_width);
    
    % Calculate R^2 value
    r = corr(mean_mocap, mean_values(:, ind));
    R2 = r^2;
    
    % Display R^2 value on the plot
    text(0.1, 0.9, sprintf('R^2: %.2f', R2), 'Units', 'normalized', 'FontSize', legend_font_size);
    
    hold off;
    title('Correlation of Motion Capture vs Simulation Angles', 'FontSize', title_font_size);
    xlabel('Motion Capture Angles [deg]', 'FontSize', label_font_size);
    ylabel('Simulation Angles [degrees]', 'FontSize', label_font_size);
    legend('Data Points', 'Perfect Agreement', 'Linear Fit', 'Location', 'best', 'FontSize', legend_font_size);
    grid on;
    set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size);
    
    % Save the figure in the output directory
    output_filename = fullfile(output_directory, 'mean_primary_coordinates_vs_mocap_1.png');
    saveas(fig_mocap, output_filename);
    close(fig_mocap);
    
    % Bland-Altman Plot
    fig_bland = figure('Name', 'Bland-Altman Plot', 'Color', 'w', 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 0.5]);
    differences = [];
    averages = [];
    
    for i = 1:n_patients
        patient_sim_data = all_values_data(:, ind, i);
        patient_mocap_data = all_mocap_data(i, :)';
        patient_diff = patient_sim_data - patient_mocap_data;
        patient_avg = (patient_sim_data + patient_mocap_data) / 2;
        differences = [differences; patient_diff];
        averages = [averages; patient_avg];
    end
    
    mean_diff = mean(differences);
    std_diff = std(differences);
    
    scatter(averages, differences, 'filled');
    hold on;
    
    % Plot mean difference line
    plot(averages, repmat(mean_diff, size(averages)), 'r-', 'LineWidth', thick_line_width);
    
    % Plot limits of agreement lines
    loa_upper = mean_diff + 1.96 * std_diff;
    loa_lower = mean_diff - 1.96 * std_diff;
    plot(averages, repmat(loa_upper, size(averages)), 'k--', 'LineWidth', thin_line_width);
    plot(averages, repmat(loa_lower, size(averages)), 'k--', 'LineWidth', thin_line_width);
    
    % Display mean difference and LoA directly on the lines
    x_pos = max(averages) + 0.02 * (max(averages) - min(averages)); % position slightly to the right
    text(x_pos, mean_diff, sprintf('Mean Diff: %.2f', mean_diff), 'FontSize', legend_font_size, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    text(x_pos, loa_upper, sprintf('LoA Upper: %.2f', loa_upper), 'FontSize', legend_font_size, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    text(x_pos, loa_lower, sprintf('LoA Lower: %.2f', loa_lower), 'FontSize', legend_font_size, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    
    hold off;
    title('Bland-Altman Plot of Agreement between Methods', 'FontSize', title_font_size);
    xlabel('Mean of Motion Capture and Simulation Angles [deg]', 'FontSize', label_font_size);
    ylabel({'Difference between Simulation and', 'Motion Capture Angles [deg]'}, 'FontSize', label_font_size);
    
    grid on;
    set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size);
    
    % Save the figure in the output directory
    output_filename = fullfile(output_directory, 'mean_primary_coordinates_vs_mocap_2.png');
    saveas(gcf, output_filename);
    close(fig_bland);
end