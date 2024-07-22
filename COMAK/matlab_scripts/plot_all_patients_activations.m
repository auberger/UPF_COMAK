function plot_all_patients_activations()
    % PLOT_ALL_PATIENTS_ACTIVATIONS Generates plots for muscle activations and reserve actuators for all patients.
    %
    % This function processes all patient result files in the specified directory, normalizes the 
    % data to one gait cycle, calculates the mean and standard deviation, and visualizes muscle activations and 
    % reserve actuators with mean lines and confidence intervals (CI) bands.
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
    output_directory = '../mean_results';
    muscle_activation_folder = fullfile(output_directory, 'muscle_activations');
    reserve_actuator_folder = fullfile(output_directory, 'reserve_actuators');

    % Create output directories if they don't exist
    if ~exist(output_directory, 'dir')
        mkdir(output_directory);
    end
    if ~exist(muscle_activation_folder, 'dir')
        mkdir(muscle_activation_folder);
    end
    if ~exist(reserve_actuator_folder, 'dir')
        mkdir(reserve_actuator_folder);
    end

    % Set parameters
    Time_steps = 100;
    Time_normed = linspace(0, 100, Time_steps);
    ftype = fittype('linearinterp');

    % Initialize data storage for each muscle and reserve actuator
    muscle_names = {'addbrev_r', 'addlong_r', 'addmagProx_r', 'addmagMid_r', 'addmagDist_r', 'addmagIsch_r', ...
                    'bflh_r', 'bfsh_r', 'edl_r', 'ehl_r', 'fdl_r', 'fhl_r', 'gaslat_r', 'gasmed_r', 'gem_r', ...
                    'glmax1_r', 'glmax2_r', 'glmax3_r', 'glmed1_r', 'glmed2_r', 'glmed3_r', 'glmin1_r', 'glmin2_r', ...
                    'glmin3_r', 'grac_r', 'iliacus_r', 'pect_r', 'perbrev_r', 'perlong_r', 'pertert_r', 'piri_r', ...
                    'psoas_r', 'quadfem_r', 'recfem_r', 'sart_r', 'semimem_r', 'semiten_r', 'soleus_r', 'tfl_r', ...
                    'tibant_r', 'tibpost_r', 'vasint_r', 'vaslat_r', 'vasmed_r'};
    reserve_names = {'hip_flex_r_reserve', 'hip_add_r_reserve', 'hip_rot_r_reserve', 'pf_flex_r_reserve', ...
                     'pf_rot_r_reserve', 'pf_tilt_r_reserve', 'pf_tx_r_reserve', 'pf_ty_r_reserve', 'pf_tz_r_reserve', ...
                     'knee_flex_r_reserve', 'knee_add_r_reserve', 'knee_rot_r_reserve', 'knee_tx_r_reserve', ...
                     'knee_ty_r_reserve', 'knee_tz_r_reserve', 'ankle_flex_r_reserve'};
    all_labels = [muscle_names, reserve_names];

    % Initialize structures to store activation data
    all_act_data = struct();
    for i = 1:length(all_labels)
        all_act_data.(all_labels{i}) = [];
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

        % Try to load simulation activation data
        try
            [act_data, act_labels, ~] = read_opensim_mot(fullfile(project_patient_dir, ['walking_' patient_id '_activation.sto']));
        catch
            disp(['ERROR: Simulation results not found for ' subdir '!']);
            continue;
        end

        % Normalize and resample simulation data
        act_time = act_data(:, 1);
        act_time_norm = (act_time - act_time(1)) / (act_time(end) - act_time(1)) * 100;
        resampled_act_data = zeros(length(Time_normed), size(act_data, 2));
        for j = 2:size(act_data, 2) % Start from 2 to skip the time column
            fit_act = fit(act_time_norm, act_data(:, j), ftype);
            resampled_act_data(:, j) = feval(fit_act, Time_normed');
        end

        % Append resampled activation data to the corresponding muscle field
        for j = 1:length(all_labels)
            ind = find(contains(act_labels, all_labels{j}));
            if ~isempty(ind)
                all_act_data.(all_labels{j}) = [all_act_data.(all_labels{j}); resampled_act_data(:, ind)'];
            end
        end
    end

    % Turn warnings back on
    warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Calculate mean and std across patients for each muscle and reserve actuator
    mean_act = structfun(@(x) mean(x, 1)', all_act_data, 'UniformOutput', false);
    std_act = structfun(@(x) std(x, [], 1)', all_act_data, 'UniformOutput', false);
    ci_act = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_act, 'UniformOutput', false);

    % Define display names mapping
    display_names = containers.Map(...
        {'addbrev_r', 'addlong_r', 'addmagProx_r', 'addmagMid_r', 'addmagDist_r', 'addmagIsch_r', ...
        'bflh_r', 'bfsh_r', 'edl_r', 'ehl_r', 'fdl_r', 'fhl_r', 'gaslat_r', 'gasmed_r', 'gem_r', ...
        'glmax1_r', 'glmax2_r', 'glmax3_r', 'glmed1_r', 'glmed2_r', 'glmed3_r', 'glmin1_r', 'glmin2_r', ...
        'glmin3_r', 'grac_r', 'iliacus_r', 'pect_r', 'perbrev_r', 'perlong_r', 'pertert_r', 'piri_r', ...
        'psoas_r', 'quadfem_r', 'recfem_r', 'sart_r', 'semimem_r', 'semiten_r', 'soleus_r', 'tfl_r', ...
        'tibant_r', 'tibpost_r', 'vasint_r', 'vaslat_r', 'vasmed_r', 'hip_flex_r_reserve', 'hip_add_r_reserve', ...
        'hip_rot_r_reserve', 'pf_flex_r_reserve', 'pf_rot_r_reserve', 'pf_tilt_r_reserve', 'pf_tx_r_reserve', ...
        'pf_ty_r_reserve', 'pf_tz_r_reserve', 'knee_flex_r_reserve', 'knee_add_r_reserve', 'knee_rot_r_reserve', ...
        'knee_tx_r_reserve', 'knee_ty_r_reserve', 'knee_tz_r_reserve', 'ankle_flex_r_reserve'}, ...
        {'Adductor Brevis', 'Adductor Longus', 'Adductor Magnus Proximal', 'Adductor Magnus Middle', ...
        'Adductor Magnus Distal', 'Adductor Magnus Ischial', 'Biceps Femoris Long Head', 'Biceps Femoris Short Head', ...
        'Extensor Digitorum Longus', 'Extensor Hallucis Longus', 'Flexor Digitorum Longus', 'Flexor Hallucis Longus', ...
        'Gastrocnemius Lateral', 'Gastrocnemius Medial', 'Gemellus', 'Gluteus Maximus 1', 'Gluteus Maximus 2', ...
        'Gluteus Maximus 3', 'Gluteus Medius 1', 'Gluteus Medius 2', 'Gluteus Medius 3', 'Gluteus Minimus 1', ...
        'Gluteus Minimus 2', 'Gluteus Minimus 3', 'Gracilis', 'Iliacus', 'Pectineus', 'Peroneus Brevis', ...
        'Peroneus Longus', 'Peroneus Tertius', 'Piriformis', 'Psoas', 'Quadratus Femoris', 'Rectus Femoris', ...
        'Sartorius', 'Semimembranosus', 'Semitendinosus', 'Soleus', 'Tensor Fasciae Latae', 'Tibialis Anterior', ...
        'Tibialis Posterior', 'Vastus Intermedius', 'Vastus Lateralis', 'Vastus Medialis', 'Hip Flexor Reserve', ...
        'Hip Adductor Reserve', 'Hip Rotator Reserve', 'Pelvic Flexor Reserve', 'Pelvic Rotator Reserve', ...
        'Pelvic Tilt Reserve', 'Pelvic Tx Reserve', 'Pelvic Ty Reserve', 'Pelvic Tz Reserve', 'Knee Flexor Reserve', ...
        'Knee Adductor Reserve', 'Knee Rotator Reserve', 'Knee Tx Reserve', 'Knee Ty Reserve', 'Knee Tz Reserve', ...
        'Ankle Flexor Reserve'});

    % Plotting muscle activations and reserve actuators with confidence intervals
    for i = 1:length(all_labels)
        label = all_labels{i};
        if isempty(all_act_data.(label))
            continue;
        end
    
        % Determine folder based on label type
        if ismember(label, muscle_names)
            save_folder = muscle_activation_folder;
            y_label = 'Activation';
            y_limit = [0, 1];
        elseif ismember(label, reserve_names)
            save_folder = reserve_actuator_folder;
            if contains(label, {'tx', 'ty', 'tz'})
                y_label = 'Force (N)';
            else
                y_label = 'Torque (Nm)';
            end
            y_limit = 'auto'; % Auto limits for reserve actuators
        else
            continue;
        end
    
        % Plot settings
        figure('Visible', 'off'); % Create figure without displaying
        hold on;
        shadedErrorBar(Time_normed, mean_act.(label), ci_act.(label), {'-b'}, 'b', 0.2);
    
        % Add plot details
        xlabel('% Gait Cycle');
        ylabel(y_label);
        title(display_names(label), 'Interpreter', 'none');
        ylim(y_limit);
        grid on;
        set(gca, 'GridAlpha', 0.3, 'FontSize', 10, 'Box', 'off'); % Adjust grid transparency and remove box
        hold off;
    
        % Save the figure as a PNG file
        saveas(gcf, fullfile(save_folder, [label '.png']));
        close(gcf); % Close the figure
    end


    disp('Plots generated and saved successfully.');
end
