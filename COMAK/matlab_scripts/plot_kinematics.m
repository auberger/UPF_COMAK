function plot_kinematics(numeric_id, project_id)
    % PLOT_KINEMATICS Generates plots of tibiofemoral and patellofemoral joint kinematics for a specified patient.
    %
    % This function loads simulation results from OpenSim motion files for the specified patient 
    % in the specified project directory. It normalizes the time data, plots various joint 
    % kinematic variables, and saves the generated figures as PNG files in the project's 
    % graphics directory.
    %
    % Inputs:
    %   numeric_id - A string representing the identifier of the patient.
    %   project_id - A string representing the identifier of the project.
    %
    % Outputs: 
    %   None (saves figures as PNG files)
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Plot parameters
    line_width = 2;

    % Load data for the patient
    try
        [values_data, values_labels, ~] = read_opensim_mot(['../results/' project_id '_' numeric_id '/comak/walking_' numeric_id '_values.sto']);
    catch
        disp('ERROR: Simulation results not found!');
        return; % Exit the function if no data is found
    end

    % Normalize time
    time = values_data(:, 1);
    Time_normed = (time - time(1)) / (time(end) - time(1)) * 100;

    % Define coordinate sets for tibiofemoral comparison
    tf_coords_rot = {...
        {'knee_flex_r','knee\_flex\_r','Flexion','Angle [deg]'},...
        {'knee_add_r','knee\_add\_r','Adduction','Angle [deg]'},...
        {'knee_rot_r','knee\_rot\_r','Internal Rotation','Angle [deg]'}};

    tf_coords_trans = {...
        {'knee_tx_r','knee\_tx\_r','Anterior Translation','Translation [mm]'},...
        {'knee_ty_r','knee\_ty\_r','Superior Translation','Translation [mm]'},...
        {'knee_tz_r','knee\_tz\_r','Lateral Translation','Translation [mm]'}};

    % Define coordinate sets for patellofemoral comparison
    pf_coords_rot = {...
        {'pf_flex_r','pf\_flex\_r','Flexion','Angle[deg]'},...
        {'pf_rot_r','pf\_rot\_r','Rotation','Angle[deg]'},...
        {'pf_tilt_r','pf\_tilt\_r','Tilt','Angle[deg]'}};

    pf_coords_trans = {...
        {'pf_tx_r','pf\_tx\_r','Anterior Translation','Translation [mm]'},...
        {'pf_ty_r','pf\_ty\_r','Superior Translation','Translation [mm]'},...
        {'pf_tz_r','pf\_tz\_r','Lateral Translation','Translation [mm]'}};

    % Create output directory if it doesn't exist
    output_dir = ['../results/' project_id '_' numeric_id '/graphics/kinematics'];
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Plot and save tibiofemoral rotations
    plot_and_save_kinematics(tf_coords_rot, values_data, values_labels, Time_normed, line_width, ...
        [output_dir '\tibiofemoral_rotations.png'], 'Tibiofemoral Rotations');

    % Plot and save tibiofemoral translations
    plot_and_save_kinematics(tf_coords_trans, values_data, values_labels, Time_normed, line_width, ...
        [output_dir '\tibiofemoral_translations.png'], 'Tibiofemoral Translations');

    % Plot and save patellofemoral rotations
    plot_and_save_kinematics(pf_coords_rot, values_data, values_labels, Time_normed, line_width, ...
        [output_dir '\patellofemoral_rotations.png'], 'Patellofemoral Rotations');

    % Plot and save patellofemoral translations
    plot_and_save_kinematics(pf_coords_trans, values_data, values_labels, Time_normed, line_width, ...
        [output_dir '\patellofemoral_translations.png'], 'Patellofemoral Translations');
end

function plot_and_save_kinematics(coords, values_data, values_labels, Time_normed, line_width, save_path, fig_name)
    kin_fig = figure('Name', fig_name, 'Position', [100, 100, 1000, 600], 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
    for i = 1:length(coords)
        subplot(3, 1, i);
        hold on;

        % Plot data
        ind = find(contains(values_labels, coords{i}{1}));
        data = values_data(:, ind);
        if contains(coords{i}{4}, 'Translation')
            data = data * 1000;
        end
        plot(Time_normed, data, 'LineWidth', line_width)
        title([coords{i}{3} ' (' coords{i}{2} ')'])
        ylabel(coords{i}{4})
        grid on;
        set(gca, 'GridAlpha', 0.3);
    end
    xlabel('Gait Cycle [%]')

    % Save figure
    saveas(kin_fig, save_path)
end
