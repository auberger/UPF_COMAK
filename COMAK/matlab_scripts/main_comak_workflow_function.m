function main_comak_workflow_function(directory_path)
    % MAIN_COMAK_WORKFLOW_FUNCTION Executes the COMAK workflow for motion analysis.
    %
    % This function processes directories containing patient data, extracting
    % body weight and running the COMAK analysis workflow, which includes 
    % inverse kinematics, joint mechanics, and visualizations.
    %
    % Parameters:
    %   directory_path (string): The path to the main directory containing patient subdirectories.
    %
    % Author: Aurel Berger
    % Date: July 2024

    import org.opensim.modeling.*
    Logger.setLevelString('Debug');
    
    % Get the full path of the currently running MATLAB file
    currentFile = mfilename('fullpath');
    
    % Get the directory of the currently running MATLAB file
    currentDirectory = fileparts(currentFile);
    
    % Change the current directory to the directory of the running MATLAB file
    cd(currentDirectory);
    
    % Get all subdirectories
    subdirs = dir(directory_path);
    subdirs = subdirs([subdirs.isdir]);
    subdirs = subdirs(~ismember({subdirs.name}, {'.', '..'}));
    
    % Define the processed_data directory
    processed_data_directory = fullfile(directory_path, '../processed_data');
    
    % Create processed_data directory if it doesn't exist
    if ~isfolder(processed_data_directory)
        mkdir(processed_data_directory);
    end
    
    % Initialize total run time and process times
    total_time = tic;
    time_ik = 0;
    time_comak = 0;
    time_mech = 0;
    time_visualization = 0;
    
    % Loop through each subdirectory
    for i = 1:length(subdirs)
        subdir = subdirs(i).name;
        if startsWith(subdir, 'HOLOA')
            project = 'h';
        elseif startsWith(subdir, 'STRATO')
            project = 's';
        else
            continue; % Skip directories that do not match the pattern
        end
    
        numeric_id = subdir(end-2:end);
        results_basename = ['walking_', numeric_id];
    
        if project == 'h'
            project_id = 'HOLOA';
            % Extract body weight from info file
            patient_directory = fullfile(directory_path, subdir);
            BW = extract_bodyweight_from_mdx(patient_directory);
        else
            project_id = 'STRATO';
            % Extract body weight from info file
            patient_directory = fullfile(directory_path, subdir);
            BW = extract_bodyweight_from_emt(patient_directory);
        end
    
        if exist(patient_directory, 'dir') == 7
            % Define the directory where you want to search for the files
            directory_model = fullfile(patient_directory, 'model');
            directory_standing = fullfile(patient_directory, 'standing');
            directory_walking = fullfile(patient_directory, 'walking');
    
            % Get first and second heel strike to set times for the analysis
            file_hs = dir(fullfile(directory_walking, '*Event*'));
            hs_data = readtable(fullfile(file_hs.folder, file_hs.name), 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 7); 
            time_start = hs_data.eRHS(1);
            time_stop = hs_data.eRHS(2);
            disp('______________________________________________________________________');
            disp('INPUTS FOR COMAK:');
            disp(['First HS: ' num2str(time_start)]); 
            disp(['Second HS: ' num2str(time_stop)]); 
            fprintf('Body weight: %.2f kg\n', BW);
    
            % Select the scaled model
            model_file_1 = dir(fullfile(directory_model, '*.osim'));
            model_file = fullfile(model_file_1.folder, model_file_1.name);
            disp(['OpenSim scaled model file: ' model_file_1.name]);
    
            % Select motion file
            motion_file_1 = dir(fullfile(directory_walking, '*.trc'));
            motion_file = fullfile(motion_file_1.folder, motion_file_1.name);
            disp(['Motion file: ' motion_file_1.name]);
    
            % Create and set external loads file
            grf_file_1 = dir(fullfile(directory_walking, '*.mot'));
            grf_file = fullfile(grf_file_1.folder, grf_file_1.name);
            template_file = fullfile(currentDirectory, '../data/template_ext_loads.xml');
            disp(['Ground reaction file: ' grf_file_1.name]);
    
            createExternalLoadsXML(grf_file_1.name, template_file, directory_walking);
            ext_load_file_1 = dir(fullfile(directory_walking, '*loads.xml'));
            ext_load_file = fullfile(ext_load_file_1.folder, ext_load_file_1.name);
            disp(['External loads file: ' ext_load_file_1.name]);
            disp('______________________________________________________________________');
    
            % Set results directory
            result_dirs = {
                'comak_inverse_kinematics', 
                'comak', 
                'joint_mechanics', 
                'graphics'
            };
            for j = 1:length(result_dirs)
                dir_path = fullfile(currentDirectory, ['../results/' project_id '_' numeric_id '/' result_dirs{j}]);
                if ~isfolder(dir_path)
                    mkdir(dir_path);
                end
                % Assign the directory paths directly in the local workspace
                eval([result_dirs{j} '_result_dir = dir_path;']);
            end
    
            % Create inputs directory if it doesn't exist
            inputs_dir = fullfile(currentDirectory, ['../inputs/' project_id '_' numeric_id]);
            if ~isfolder(inputs_dir)
                mkdir(inputs_dir);
            end
    
            % Clear unnecessary variables from workspace
            clear dir_path file_hs grf_file grf_file_1 hs_data model_file_1 template_file
    
            %% Run COMAK Workflow

            % Run inverse kinematics
            ik_time_start = tic;
            run_ik(model_file, motion_file, comak_inverse_kinematics_result_dir, numeric_id, project_id, results_basename, time_start, time_stop);
            time_ik = time_ik + toc(ik_time_start);
            fprintf('Run time for IK %s: %.2f seconds\n', subdir, time_ik);

            % Run standard comak without muscle weights and contact energy = 100
            comak_time_start = tic;
            run_comak(model_file, ext_load_file, comak_result_dir, numeric_id, project_id, results_basename, time_start, time_stop);
            time_comak = time_comak + toc(comak_time_start);
            fprintf('Run time for COMAK %s: %.2f seconds\n', subdir, time_comak);

            mech_time_start = tic;
            run_joint_mechanics(model_file, comak_result_dir, joint_mechanics_result_dir, numeric_id, project_id, results_basename, time_start, time_stop);
            time_mech = time_mech + toc(mech_time_start);
            fprintf('Run time for Joint Mechanics %s: %.2f seconds\n', subdir, time_mech);

    
            %% Set global plot parameters
            set(0, 'DefaultLineLineWidth', 2); % Default line width
            set(0, 'DefaultAxesFontSize', 14); % Default font size for axes
            set(0, 'DefaultAxesLabelFontSizeMultiplier', 1.2); % Multiplier for axis label font size
            set(0, 'DefaultAxesTitleFontSizeMultiplier', 1.4); % Multiplier for axis title font size
            set(0, 'DefaultLegendFontSize', 12); % Default legend font size
            set(0, 'DefaultFigureColor', 'w'); % Default figure background color

            %% Set parameters for functions
            sf_emg = 1000;
            forces_file = fullfile(currentDirectory, ['../results/' project_id '_' numeric_id '/joint_mechanics/walking_' numeric_id '_ForceReporter_forces.sto']);
            gif_save_path = ['../results/' project_id '_' numeric_id '/graphics/paraview'];

            %% Call plotting function for specific patients

            time_visualization_start = tic;

            % Paraview Visualization of vtp files
            runParaviewVisualization(numeric_id, project_id);

            % Plot joint mechanics
            create_animated_joint_mechanics_gif(project_id, numeric_id, forces_file, BW, gif_save_path);
            plot_joint_mechanics_extended(project_id, numeric_id, forces_file, BW);

            % Plot all kinematics (tibiofemoral and patellofemoral)
            plot_kinematics(numeric_id, project_id);

            % Compare IK results with MoCap
            plot_primary_coordinates_vs_mocap(numeric_id, project_id, directory_walking);

            % Plot muscle activations and reserve actuators
            plot_activations(project_id, numeric_id);

            % Compare results with EMG data
            plot_activation_vs_emg(project_id, numeric_id, BW, time_start, time_stop, sf_emg);

            % Create output text file
            save_output_to_text_file(project_id, numeric_id, forces_file);
    
            %% Run time pie chart  
            total_run_time = toc(total_time);
            createPieChartWithRunTimes(total_run_time, time_ik, time_comak, time_mech, time_visualization, project_id, numeric_id);
    
    
            %% Move processed folder to processed_data directory
            movefile(patient_directory, fullfile(processed_data_directory, subdir));
            
        else
            disp(['ERROR: Patient directory not found: ' patient_directory]);
        end

    end


    %% Call plotting function for population level report

    % Plot joint mechanics
    plot_all_patients_pressure_and_area();
    plot_all_patients_joint_mechanics();

    % Plot all kinematics (tibiofemoral and patellofemoral)
    plot_all_patients_kinematics();

    % Compare IK results with MoCap
    plot_all_patients_primary_coordinates_vs_mocap();

    % Plot muscle activations and reserve actuators
    plot_all_patients_activations();

    % Compare results with EMG data
    plot_all_patients_activation_vs_emg(sf_emg);

    time_visualization = time_visualization + toc(time_visualization_start);
    fprintf('Run time for Visualizations for %s (and mean visualizations): %.2f seconds\n', subdir, time_visualization);


    %% Create HTML report
    create_report();

end

