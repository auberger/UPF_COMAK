function plot_joint_mechanics_extended(project_id, numeric_id, forces_file, BW)
    % PLOT_JOINT_MECHANICS_EXTENDED Visualizes joint mechanics data over a gait cycle.
    %
    % This function plots various joint mechanics metrics, including contact forces, 
    % joint reaction moments, and the center of pressure (CoP) based on the provided 
    % forces file. Results are normalized to body weight and saved as PNG images in 
    % specified output directories.
    %
    % Inputs:
    %   project_id - Identifier for the project.
    %   numeric_id - Numeric identifier for the patient.
    %   forces_file - Path to the file containing joint forces data.
    %   BW - Body weight in kilograms, used for normalization.
    %
    % Outputs:
    %   Generates and saves plots for contact forces, reaction moments, and CoP as 
    %   PNG files in the results directory.
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

    % Font sizes
    title_font_size = 18;
    label_font_size = 16;
    axes_font_size = 14;
    legend_font_size = 14;

    % Information for titles
    info = {'Anterior-Posterior', 'Superior-Inferior', 'Medial-Lateral'};

    % Create processed_data directory if it doesn't exist
    if ~isfolder(['../results/' project_id '_' numeric_id '/graphics/extended_joint_mechanics'])
        mkdir(['../results/' project_id '_' numeric_id '/graphics/extended_joint_mechanics']);
    end

    %% Plot Contact Forces
    for i = 1:3
        contact_forces_fig = figure('Name', ['Contact Forces - ' info{i}], 'Color', 'w', 'Visible', 'off');
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        hold on;

        % Plot total contact forces
        plot(forces_time_norm, forces_data(:, 588 + i) / BW, 'k', 'LineWidth', thin_line_width);

        % Plot forces for medial compartment
        plot(forces_time_norm, forces_data(:, 672 + i) / BW, 'r', 'LineWidth', thick_line_width);

        % Plot forces for lateral compartment
        plot(forces_time_norm, forces_data(:, 675 + i) / BW, 'b', 'LineWidth', thick_line_width);

        hold off;
        ylabel('Joint Contact Force [BW]');
        title(['Contact Forces - ' info{i} ' (' char('X' + i - 1) ')'], 'FontSize', title_font_size);
        legend('Total', 'Medial', 'Lateral', 'FontSize', legend_font_size);
        xlabel('Gait Cycle [%]');
        grid on;
        set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size); % Adjust grid transparency

        % Save Contact Forces plot
        saveas(contact_forces_fig, ['../results/' project_id '_' numeric_id '/graphics/extended_joint_mechanics/Contact_Forces_' info{i} '_plot.png']);
        close(contact_forces_fig);
    end

    %% Plot Joint Reaction Moments
    for i = 1:3
        reaction_moments_fig = figure('Name', ['Reaction Moments - ' info{i}], 'Color', 'w', 'Visible', 'off');
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        hold on;

        % Plot total reaction moments
        plot(forces_time_norm, forces_data(:, 591 + i), 'k', 'LineWidth', thin_line_width);

        % Plot moments for medial compartment
        plot(forces_time_norm, forces_data(:, 690 + i), 'r', 'LineWidth', thick_line_width);

        % Plot moments for lateral compartment
        plot(forces_time_norm, forces_data(:, 693 + i), 'b', 'LineWidth', thick_line_width);

        hold off;
        ylabel('Joint Reaction Moments [Nm]');
        title(['Reaction Moments - ' info{i} ' (' char('X' + i - 1) ')'], 'FontSize', title_font_size);
        legend('Total', 'Medial', 'Lateral', 'FontSize', legend_font_size);
        xlabel('Gait Cycle [%]');
        grid on;
        set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size); % Adjust grid transparency

        % Save Reaction Moments plot
        saveas(reaction_moments_fig, ['../results/' project_id '_' numeric_id '/graphics/extended_joint_mechanics/Reaction_Moments_' info{i} '_plot.png']);
        close(reaction_moments_fig);
    end

    %% Plot Center of Pressure
    for i = 1:3
        center_of_pressure_fig = figure('Name', ['Center of Pressure - ' info{i}], 'Color', 'w', 'Visible', 'off');
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        hold on;

        % Plot total center of pressure in each dimension
        plot(forces_time_norm, forces_data(:, 585 + i) * 1000, 'k', 'LineWidth', thin_line_width);

        % Plot center of pressure in each dimension for medial compartment
        plot(forces_time_norm, forces_data(:, 654 + i) * 1000, 'r', 'LineWidth', thick_line_width);

        % Plot center of pressure in each dimension for lateral compartment
        plot(forces_time_norm, forces_data(:, 657 + i) * 1000, 'b', 'LineWidth', thick_line_width);

        hold off;
        ylabel('CoP [mm]');
        title(['Center of Pressure - ' info{i} ' (' char('X' + i - 1) ')'], 'FontSize', title_font_size);
        legend('Total', 'Medial', 'Lateral', 'FontSize', legend_font_size);
        xlabel('Gait Cycle [%]');
        grid on;
        set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size); % Adjust grid transparency

        % Save Center of Pressure plot
        saveas(center_of_pressure_fig, ['../results/' project_id '_' numeric_id '/graphics/extended_joint_mechanics/Center_of_Pressure_' info{i} '_plot.png']);
        close(center_of_pressure_fig);
    end
end
