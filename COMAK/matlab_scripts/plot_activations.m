function plot_activations(project_id, numeric_id)
    % PLOT_ACTIVATIONS Generates plots for muscle activations and reserve actuators.
    %
    % This function loads muscle activation data and reserve actuator information 
    % from simulation results and generates area plots for each specified muscle and 
    % reserve actuator over the gait cycle. The results are saved as PNG images in 
    % designated directories.
    %
    % Inputs:
    %   project_id - Identifier for the project.
    %   numeric_id - Numeric identifier for the patient.
    %
    % Outputs:
    %   Plots are saved as PNG files in specified output directories for muscle 
    %   activations and reserve actuators.
    %
    % Author: Aurel Berger
    % Date: July 2024

    
    % Directories for saving plots
    muscle_outputDir = ['../results/' project_id '_' numeric_id '/graphics/muscle_activations'];
    reserve_outputDir = ['../results/' project_id '_' numeric_id '/graphics/reserve_actuators'];

    % Create directories if they do not exist
    if ~exist(muscle_outputDir, 'dir')
        mkdir(muscle_outputDir);
    end
    if ~exist(reserve_outputDir, 'dir')
        mkdir(reserve_outputDir);
    end

    % Load data
    directory = ['../results/' project_id '_' numeric_id '/comak/walking_' numeric_id '_activation.sto'];

    try
        [act_data, act_labels, ~] = read_opensim_mot(directory);
    catch
        disp(['Could not load data from directory: ' directory]);
        return;
    end

    % Normalize time data
    act_time = act_data(:,1);
    act_time_norm = (act_time - act_time(1)) / (act_time(end)-act_time(1)) * 100;

    % Set muscles and reserve actuators to analyze
    muscles = {'addbrev_r', 'addlong_r', 'addmagProx_r', 'addmagMid_r', 'addmagDist_r', 'addmagIsch_r', ...
        'bflh_r', 'bfsh_r', 'edl_r', 'ehl_r', 'fdl_r', 'fhl_r', 'gaslat_r', 'gasmed_r', 'gem_r', ...
        'glmax1_r', 'glmax2_r', 'glmax3_r', 'glmed1_r', 'glmed2_r', 'glmed3_r', 'glmin1_r', 'glmin2_r', ...
        'glmin3_r', 'grac_r', 'iliacus_r', 'pect_r', 'perbrev_r', 'perlong_r', 'pertert_r', 'piri_r', ...
        'psoas_r', 'quadfem_r', 'recfem_r', 'sart_r', 'semimem_r', 'semiten_r', 'soleus_r', 'tfl_r', ...
        'tibant_r', 'tibpost_r', 'vasint_r', 'vaslat_r', 'vasmed_r'};
    reserves = {'hip_flex_r_reserve', 'hip_add_r_reserve', 'hip_rot_r_reserve', 'pf_flex_r_reserve', ...
        'pf_rot_r_reserve', 'pf_tilt_r_reserve', 'pf_tx_r_reserve', 'pf_ty_r_reserve', 'pf_tz_r_reserve', ...
        'knee_flex_r_reserve', 'knee_add_r_reserve', 'knee_rot_r_reserve', 'knee_tx_r_reserve', ...
        'knee_ty_r_reserve', 'knee_tz_r_reserve', 'ankle_flex_r_reserve'};

    % Combine all labels for analysis
    all_labels = [muscles, reserves];

    % Line width for plots
    line_width = 2;

    % Font sizes
    title_font_size = 12;
    label_font_size = 10;
    axes_font_size = 10;

    % Display names mapping
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
        'Tibialis Posterior', 'Vastus Intermedius', 'Vastus Lateralis', 'Vastus Medialis', ...
        'Hip Flexor Reserve Actuator', 'Hip Adductor Reserve Actuator', 'Hip Rotator Reserve Actuator', ...
        'Patellofemoral Flexor Reserve Actuator', 'Patellofemoral Rotator Reserve Actuator', ...
        'Patellofemoral Tilt Reserve Actuator', 'Patellofemoral Translation X Reserve Actuator', ...
        'Patellofemoral Translation Y Reserve Actuator', 'Patellofemoral Translation Z Reserve Actuator', ...
        'Knee Flexor Reserve Actuator', 'Knee Adductor Reserve Actuator', 'Knee Rotator Reserve Actuator', ...
        'Knee Translation X Reserve Actuator', 'Knee Translation Y Reserve Actuator', ...
        'Knee Translation Z Reserve Actuator', 'Ankle Flexor Reserve Actuator'});

    % Generate and save plots for each muscle and reserve actuator
    for i = 1:length(all_labels)
        label = all_labels{i};
        ind = find(contains(act_labels, label));
        
        if ~isempty(ind)
            data = act_data(:, ind);

            % Plot the data
            fig = figure('Visible', 'off'); % Create invisible figure
            area(act_time_norm, data, 'FaceColor', [0 0 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
            title(display_names(label), 'FontSize', title_font_size);
            xlabel('Gait Cycle (%)', 'FontSize', label_font_size);

            % Set y-axis label and limits based on whether it's a muscle or reserve actuator
            if ismember(label, muscles)
                ylabel('Activation', 'FontSize', label_font_size);
                ylim([0, 1]);
            else
                if contains(label, {'tx', 'ty', 'tz'})
                    ylabel('Force (N)', 'FontSize', label_font_size);
                else
                    ylabel('Torque (Nm)', 'FontSize', label_font_size);
                end
            end
            
            grid on;
            set(gca, 'GridAlpha', 0.3, 'FontSize', axes_font_size, 'Box', 'off'); % Adjust grid transparency and remove box

            % Determine output directory
            if ismember(label, muscles)
                outputDir = muscle_outputDir;
            else
                outputDir = reserve_outputDir;
            end

            % Save the plot as PNG
            saveas(fig, fullfile(outputDir, [label '.png']));
            close(fig);
        end
    end
end
