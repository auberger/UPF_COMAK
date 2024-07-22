function plot_all_patients_activation_vs_emg(sf)
    % PLOT_ALL_PATIENTS_ACTIVATION_VS_EMG Compares muscle activation from simulation vs. EMG data for all patients.
    %
    % This function processes all patient result files in the specified directory, normalizes the 
    % data to one gait cycle, calculates the mean and standard deviation, and compares muscle activation with EMG data.
    % It visualizes the mean and standard deviation with a 95% confidence interval band.
    %
    % Inputs:
    %   sf - Sampling frequency of the EMG data.
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
    Time_normed = linspace(0, 100, Time_steps);
    ftype = fittype('linearinterp');

    % Initialize data storage for each muscle
    all_act_data = struct('tibant_r', [], 'vaslat_r', [], 'gaslat_r', [], 'bflh_r', []);
    all_emg_data = struct('tibant_r', [], 'vaslat_r', [], 'gaslat_r', [], 'bflh_r', []);
    
    % Suppress warnings temporarily
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

    % Get all subdirectories in the results directory, excluding specified ones
    subdirs = dir(results_directory);
    subdirs = subdirs([subdirs.isdir]);
    exclude_dirs = {'.', '..', 'images_for_visualizations', 'paraview_template_files'};
    subdirs = subdirs(~ismember({subdirs.name}, exclude_dirs));

    % Lists to track included and excluded patients
    included_patients = {};
    excluded_patients = {};

    % Iterate through each patient directory
    for i = 1:length(subdirs)
        subdir = subdirs(i).name;
        project_patient_dir = fullfile(results_directory, subdir, 'comak');
        patient_id = subdir(end-2:end); % last 3 characters of the directory name

        % Extract time_start and time_stop for each patient from their event data files
        try
            event_file = dir(fullfile(data_directory, subdir, 'walking', '*Event*'));
            event_data = readtable(fullfile(event_file.folder, event_file.name), 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 7);
            time_start = event_data.eRHS(1);
            time_stop = event_data.eRHS(2);
        catch
            disp(['ERROR: Event data file not found or unreadable for ' subdir '!']);
            excluded_patients{end+1} = subdir;
            continue;
        end

        % Try to load simulation activation data
        try
            [act_data, act_labels, ~] = read_opensim_mot(fullfile(project_patient_dir, ['walking_' patient_id '_activation.sto']));
        catch
            disp(['ERROR: Simulation results not found for ' subdir '!']);
            excluded_patients{end+1} = subdir;
            continue;
        end

        % Load motion capture EMG data
        emg_files = dir(fullfile(data_directory, subdir, 'walking', '*EMG*'));
        if isempty(emg_files)
            disp(['ERROR: Motion capture file not found for ' subdir '!']);
            excluded_patients{end+1} = subdir;
            continue;
        end
        
        % Construct the full path of the first matching file
        emg_file_path = fullfile(emg_files(1).folder, emg_files(1).name);
        try
            emg_data = readtable(emg_file_path, 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 10);
        catch
            disp(['ERROR: Unable to read motion capture file for ' subdir '!']);
            excluded_patients{end+1} = subdir;
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
        muscle_names = {'tibant_r', 'vaslat_r', 'gaslat_r', 'bflh_r'};
        for j = 1:length(muscle_names)
            ind = find(contains(act_labels, muscle_names{j}));
            all_act_data.(muscle_names{j}) = [all_act_data.(muscle_names{j}); resampled_act_data(:, ind)'];
        end

        % Extract and normalize EMG data for each muscle
        ind_start = find(emg_data.Time == time_start, 1);
        ind_stop = find(emg_data.Time == time_stop, 1);
        emg_signals = {'RightTibialisAnterior', 'RightVastusLateralis', 'RightGastrocnemiusLateralis', 'RightBicepsFemorisCaputLongus'};
        for j = 1:length(emg_signals)
            emg_signal = emg_data.(emg_signals{j})(ind_start:ind_stop);
            emg_signal = preprocess_emg(emg_signal, sf);
            emg_time = linspace(0, 100, length(emg_signal));
            fit_emg = fit(emg_time', emg_signal, ftype);
            resampled_emg_data = feval(fit_emg, Time_normed');
            all_emg_data.(muscle_names{j}) = [all_emg_data.(muscle_names{j}); resampled_emg_data'];
        end

        included_patients{end+1} = subdir;
    end

    % Print included and excluded patients
    disp('Included patients:');
    disp(included_patients);
    disp('Excluded patients:');
    disp(excluded_patients);

    % Calculate mean and std across patients for each muscle
    mean_act = structfun(@(x) mean(x, 1)', all_act_data, 'UniformOutput', false);
    std_act = structfun(@(x) std(x, [], 1)', all_act_data, 'UniformOutput', false);
    ci_act = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_act, 'UniformOutput', false);

    mean_emg = structfun(@(x) mean(x, 1)', all_emg_data, 'UniformOutput', false);
    std_emg = structfun(@(x) std(x, [], 1)', all_emg_data, 'UniformOutput', false);
    ci_emg = structfun(@(x) 1.96 * (x / sqrt(size(x, 1)))', std_emg, 'UniformOutput', false);

    % Plotting
    muscle_names = {'tibant_r', 'vaslat_r', 'gaslat_r', 'bflh_r'};
    muscle_labels = {'Tibialis Anterior', 'Vastus Lateralis', 'Gastrocnemius Lateralis', 'Biceps Femoris Caput Longus'};
    
    fig_emg = figure('Name', 'Muscle Activation vs EMG', 'Color', 'w', 'Position', [100 100 1600 800], 'Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);

    for i = 1:length(muscle_names)
        subplot(2, 2, i); hold on;
    
        % Plot simulated activation data on the left y-axis
        yyaxis left;
        shadedErrorBar(Time_normed, mean_act.(muscle_names{i}), ci_act.(muscle_names{i}), {'-b', 'LineWidth', 2}, [0 0 1]);
        ylabel('Activation Signal');
        ylim([0 1]);
    
        % Plot EMG data on the right y-axis
        yyaxis right;
        shadedErrorBar(Time_normed, mean_emg.(muscle_names{i}), ci_emg.(muscle_names{i}), {'-r', 'LineWidth', 2}, [1 0 0]);
        ylabel('EMG Signal (mV)');
        max_emg_axis = (1 / max(mean_act.(muscle_names{i}))) * max(mean_emg.(muscle_names{i}));
        ylim([0 max_emg_axis]);
    
        % Display number of patients
        n_patients = size(all_act_data.(muscle_names{i}), 1);
        text(0.1, 0.9, sprintf('n = %d', n_patients), 'Units', 'normalized', 'FontSize', 12, 'Color', 'k');
    
        % Title and labels
        title(muscle_labels{i});
        xlabel('Gait Cycle [%]');
        grid on;
    
        % Calculate cross-correlation
        [cross_corr, lags] = xcorr(mean_act.(muscle_names{i}), mean_emg.(muscle_names{i}), 'coeff');
        [max_corr, max_corr_idx] = max(cross_corr);
        max_corr_lag = lags(max_corr_idx);

        % Calculate correlation at zero lag
        zero_lag_idx = find(lags == 0);
        corr_at_zero_lag = cross_corr(zero_lag_idx);
    
        % Display cross-correlation results
        text(0.1, 0.8, sprintf('Max Corr Lag: %d', max_corr_lag), 'Units', 'normalized', 'FontSize', 12, 'Color', 'k');
        text(0.1, 0.7, sprintf('Max Corr: %.2f', max_corr), 'Units', 'normalized', 'FontSize', 12, 'Color', 'k');
        text(0.1, 0.6, sprintf('Corr @ Lag 0: %.2f', corr_at_zero_lag), 'Units', 'normalized', 'FontSize', 12, 'Color', 'k');
    
        % Adjust axis colors
        ax = gca;
        ax.YAxis(1).Color = 'b';
        ax.YAxis(2).Color = 'r';
    end
    
    % Add legend
    legend('Simulated Activation Mean', '95% CI (Activation)', 'EMG Mean', '95% CI (EMG)', 'Location',  'northeast');

    % Save figure
    saveas(fig_emg, fullfile(output_directory, 'Population_Level_Activation_vs_EMG.png'));
    close(fig_emg);

    % Turn warnings back on
    warning('on', 'MATLAB:table:ModifiedAndSavedVarnames');
end
