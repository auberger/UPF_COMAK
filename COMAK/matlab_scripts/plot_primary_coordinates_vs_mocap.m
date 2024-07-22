function plot_primary_coordinates_vs_mocap(numeric_id, project_id, directory_walking)
    % PLOT_PRIMARY_COORDINATES_VS_MOCAP Compares primary coordinates from motion capture and simulation.
    %
    % This function loads simulation results for a specified patient and project, normalizes the 
    % data to one gait cycle, and compares knee flexion-extension angles with motion capture data.
    % It calculates the Mean Absolute Error (MAE) and maximum error, and visualizes the results in 
    % a series of plots, saving them as a PNG file in the project's graphics directory.
    %
    % Inputs:
    %   numeric_id (string): The numeric identifier for the patient.
    %   project_id (string): The identifier for the project.
    %   directory_walking (string): Path to the directory containing walking data.
    %
    % Outputs: 
    %   None (saves figure as a PNG file).
    %
    % Author: Aurel Berger
    % Date: July 2024

    
    Time_steps = 100;
    Time_normed = 0:Time_steps;
    ftype = fittype('linearinterp');

    % Create output directory if it doesn't exist
    output_dir = ['../results/' project_id '_' numeric_id '/graphics/validation'];
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Load data for the patient
    try
        [values_data, values_labels, ~] = read_opensim_mot(['../results/' project_id '_' numeric_id '/comak/walking_' numeric_id '_values.sto']);
    catch  
        disp('ERROR: Simulation results not found!');
        return; % Exit the function if no data is found
    end

    %% IK marker errors

    % Load marker error data for the patient
    try
        [error_data, ~, ~] = read_opensim_mot(['../results/' project_id '_' numeric_id '/comak_inverse_kinematics/walking_' numeric_id '_ik_marker_errors.sto']);
    catch  
        disp('ERROR: Simulation IK marker error file not found!');
        return; % Exit the function if no data is found
    end
        
    % Compute the mean and standard deviation
    mean_err = mean(error_data(:, 3));
    std_err = std(error_data(:, 3));
    mean_max = mean(error_data(:, 4));
    std_max = std(error_data(:, 4));
    
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
    
    %%

    % Normalize time
    time_data = values_data(:, 1);
    time_norm = linspace(0, max(Time_normed), length(time_data)); % for time normalization
    
    % Resample data
    resampled_values_data = zeros(length(Time_normed), size(values_data, 2));
    resampled_values_data(:, 1) = Time_normed;
    
    for i = 2:size(values_data, 2) % Start from 2 to skip the time column
        % Interpolate the data to have 100 samples per gait cycle
        fit_1 = fit(time_norm', values_data(:, i), ftype);
        resampled_values_data(:, i) = feval(fit_1, Time_normed');
    end
    
    % Overwrite
    values_data = resampled_values_data;
    
    % Plot Knee Primary Kinematics Compared to Motion Capture Software

    % Find EMT file
    emt_file_1 = dir(fullfile(directory_walking, '*Angle*'));
    emt_file = [emt_file_1.folder '/' emt_file_1.name];
    disp(['Motion capture IK file of estimated joint angles: ' emt_file_1.name]);

    % Suppress warnings temporarily
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Load the EMT file
    emt_data = readtable(emt_file, 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 7); % Assuming the header is 7 rows
    
    % Extract the relevant column for knee flexion extension angles
    acmRKFE = emt_data.acmRKFE_M;
    acm_time = emt_data.Sample; % Access the Sample column directly
    
    % Calculate MAE and Max Error
    ind = find(contains(values_labels, 'knee_flex_r'));

    mae_value = mean(abs(acmRKFE - values_data(:, ind)));
    max_error = max(abs(acmRKFE - values_data(:, ind)));
    
    % Formatting parameters
    thin_line_width = 2;
    thick_line_width = 3;
    title_font_size = 18;
    label_font_size = 16;
    axes_font_size = 14;
    legend_font_size = 14;
    
    % Plot the data
    figure('Name', 'Comparison of Knee Flexion-Extension Angles', 'Color', 'w', 'Visible', 'off');
    set(gcf,'units','normalized','outerposition',[0 0 1 1])

    % Plot mocap data
    subplot(2,1,1);
    plot(acm_time, acmRKFE, 'LineWidth', thin_line_width, 'DisplayName', 'Motion Capture Software');
    hold on;
    
    % Display MAE and Max Error on the plot and marker errors from IK
    text(0.1, 0.9, sprintf('MAE: %.2f deg', mae_value), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.8, sprintf('Max Error: %.2f deg', max_error), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.65, sprintf('Marker errors of simulation IK results:'), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.5, sprintf('Mean and 95%% CI for RMS marker error for all frames: %.2f ± %.2f cm\n', mean_err*100, margin_of_error_err*100), 'Units', 'normalized', 'FontSize', legend_font_size);
    text(0.1, 0.4, sprintf('Mean and 95%% CI for maximum marker for all frames: %.2f ± %.2f cm\n', mean_max*100, margin_of_error_max*100), 'Units', 'normalized', 'FontSize', legend_font_size);

    % Plot simulation results
    plot(Time_normed, values_data(:, ind), 'LineWidth', thick_line_width, 'DisplayName', 'Simulation Results');

    hold off;
    title('Comparison of Knee Flexion-Extension Angles', 'FontSize', title_font_size);
    xlabel('Gait cycle [%]', 'FontSize', label_font_size);
    ylabel('Angle [deg]', 'FontSize', label_font_size);
    legend('show', 'FontSize', legend_font_size);
    grid on;
    set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size);

    % Correlation subplot
    subplot(2,1,2);
    scatter(acmRKFE, values_data(:, ind), 'filled');
    hold on;

    % Calculate and plot perfect agreement line (45 degree line)
    x = linspace(min(acmRKFE), max(acmRKFE), 100);
    plot(x, x, 'k--', 'LineWidth', thin_line_width);

    % Calculate and plot the linear regression line
    p = polyfit(acmRKFE, values_data(:, ind), 1);
    yfit = polyval(p, acmRKFE);
    plot(acmRKFE, yfit, 'r-', 'LineWidth', thick_line_width);

    % Calculate R^2 value
    r = corr(acmRKFE, values_data(:, ind));
    R2 = r^2;

    % Display R^2 value on the plot
    text(0.1, 0.9, sprintf('R^2: %.2f', R2), 'Units', 'normalized', 'FontSize', legend_font_size);
    
    hold off;
    title({'', 'Correlation of Motion Capture vs Simulation Angles'}, 'FontSize', title_font_size);
    xlabel('Motion Capture Angles [deg]', 'FontSize', label_font_size);
    ylabel('Simulation Angles [deg]', 'FontSize', label_font_size);
    legend('Data Points', 'Perfect Agreement', 'Linear Fit', 'Location', 'best', 'FontSize', legend_font_size);
    grid on;
    set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size);

    % Save figure
    saveas(gcf, ['../results/' project_id '_' numeric_id '/graphics/validation/primary_tibiofemoral_kinematics_with_mocap_1.png']);

    % Bland-Altman subplot
    figure('Name', 'Bland-Altman Plot', 'Color', 'w', 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 0.5])

    differences = values_data(:, ind) - acmRKFE;
    averages = (values_data(:, ind) + acmRKFE) / 2;
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

    % Save figure
    saveas(gcf, ['../results/' project_id '_' numeric_id '/graphics/validation/primary_tibiofemoral_kinematics_with_mocap_2.png']);
    disp('Plot "primary_tibiofemoral_kinematics_with_mocap.png" got saved to the "graphics" directory!');
end
