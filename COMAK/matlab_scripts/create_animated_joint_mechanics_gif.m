function create_animated_joint_mechanics_gif(project_id, numeric_id, forces_file, BW, gif_save_path)
    % CREATE_ANIMATED_JOINT_MECHANICS_GIF Generates an animated GIF of joint mechanics data.
    %
    % This function reads joint mechanics data from an OpenSim .mot file and generates
    % an animated GIF that visualizes the mean contact pressure, maximum contact pressure,
    % and contact area over the gait cycle.
    %
    % Parameters:
    % project_id (string): The project identifier (e.g., 'HOLOA' or 'STRATO').
    % numeric_id (string): The numeric identifier for the patient.
    % forces_file (string): The path to the OpenSim .mot file containing the joint mechanics data.
    % BW (double): The body weight of the patient in kilograms.
    % gif_save_path (string): The directory path where the GIF should be saved.
    %
    % Author: Aurel Berger
    % Date: July 2024
    
    % Load data
    [forces_data, ~, ~] = read_opensim_mot(forces_file);

    % Normalize time
    forces_time = forces_data(:, 1);
    forces_time_norm = (forces_time - forces_time(1)) / (forces_time(end) - forces_time(1)) * 100;

    % Body weight
    BW = BW * 9.81; % kg * m/s^2

    % Line width for plots
    thin_line_width = 2;
    thick_line_width = 3;

    % Font size for titles, labels, and axes numbers
    title_font_size = 18;
    label_font_size = 16;
    axes_font_size = 14;
    legend_font_size = 14;

    % Animation parameters
    duration = 4; % Total duration of the GIF in seconds
    fps = 20; % Frames per second
    num_frames = duration * fps;
    dt = duration / num_frames;

    % Prepare figure for animation
    fig = figure('Name', 'Animated Joint Mechanics', 'Position', [100, 100, 1200, 800], 'Color', 'w', 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);

    % Create subplots for Pressure and Area
    subplot(3, 1, 1);
    plot(forces_time_norm, forces_data(:, 584) / 1000000, 'k', 'LineWidth', thin_line_width);
    hold on;
    plot(forces_time_norm, forces_data(:, 635) / 1000000, 'r', 'LineWidth', thick_line_width);
    plot(forces_time_norm, forces_data(:, 636) / 1000000, 'b', 'LineWidth', thick_line_width);
    vline1 = xline(0, 'r', 'LineWidth', 2);
    hold off;
    ylabel('Pressure (MPa)', 'FontSize', label_font_size);
    title('Mean Contact Pressure', 'FontSize', title_font_size);
    set(gca, 'Color', 'w', 'Box', 'off', 'FontSize', axes_font_size, 'GridAlpha', 0.3);
    grid on;

    subplot(3, 1, 2);
    plot(forces_time_norm, forces_data(:, 585) / 1000000, 'k', 'LineWidth', thin_line_width);
    hold on;
    plot(forces_time_norm, forces_data(:, 641) / 1000000, 'r', 'LineWidth', thick_line_width);
    plot(forces_time_norm, forces_data(:, 642) / 1000000, 'b', 'LineWidth', thick_line_width);
    vline2 = xline(0, 'r', 'LineWidth', 2);
    hold off;
    ylabel('Pressure (MPa)', 'FontSize', label_font_size);
    title('Max. Contact Pressure', 'FontSize', title_font_size);
    set(gca, 'Color', 'w', 'Box', 'off', 'FontSize', axes_font_size, 'GridAlpha', 0.3);
    grid on;

    subplot(3, 1, 3);
    plot(forces_time_norm, forces_data(:, 578) * 1000000, 'k', 'LineWidth', thin_line_width);
    hold on;
    plot(forces_time_norm, forces_data(:, 599) * 1000000, 'r', 'LineWidth', thick_line_width);
    plot(forces_time_norm, forces_data(:, 600) * 1000000, 'b', 'LineWidth', thick_line_width);
    vline3 = xline(0, 'r', 'LineWidth', 2);
    hold off;
    ylabel('Area (mm^2)', 'FontSize', label_font_size);
    title('Contact Area', 'FontSize', title_font_size);
    set(gca, 'Color', 'w', 'Box', 'off', 'FontSize', axes_font_size, 'GridAlpha', 0.3);
    grid on;
    xlabel('Gait Cycle [%]', 'FontSize', label_font_size);

    % Add a single legend outside the subplots
    legend_handle = legend({'Total', 'Medial', 'Lateral'}, 'FontSize', legend_font_size, 'Position', [0.9, 0.5, 0.05, 0.1]);

    % Initialize the GIF
    filename = fullfile(gif_save_path, [project_id '_' numeric_id '_animated_joint_mechanics.gif']);
    for t = 1:num_frames
        % Update vertical line position
        time = t * dt / duration * 100;
        set(vline1, 'Value', time);
        set(vline2, 'Value', time);
        set(vline3, 'Value', time);

        % Capture the plot as an image
        drawnow;
        frame = getframe(fig);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);

        % Write to the GIF file
        delayTimeMilliseconds = round(dt * 1000);  % Convert to milliseconds and round
        if t == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delayTimeMilliseconds / 1000);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delayTimeMilliseconds / 1000);
        end

        % Pause to create animation effect
        pause(dt);
    end

    % Close the figure
    close(fig);
end
