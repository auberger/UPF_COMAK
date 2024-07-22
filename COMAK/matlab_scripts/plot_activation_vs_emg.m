function plot_activation_vs_emg(project_id, numeric_id, BW, time_start, time_stop, sf)
    % PLOT_ACTIVATION_VS_EMG Plots simulated muscle activation results vs. EMG data.
    %
    % This function compares muscle activation from simulations to corresponding
    % EMG data during a specified gait cycle, plotting the results for analysis.
    %
    % Inputs:
    %   project_id - Identifier for the project.
    %   numeric_id - Numeric identifier for the patient.
    %   BW - Body weight in kilograms.
    %   time_start - Start time for plotting (in seconds).
    %   time_stop - Stop time for plotting (in seconds).
    %   sf - Sampling frequency of the EMG data.
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Set plot parameters
    line_width = 2;

    % Create output directory if it doesn't exist
    output_dir = ['..\results\' project_id '_' numeric_id '\graphics\validation'];
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    %% Plot Muscle Activation

    % Load data
    directorys = ['../results/' project_id '_' numeric_id '/comak/walking_' numeric_id '_activation.sto'];

    % Try loading data from each directory
    try
        [act_data, act_labels, ~] = read_opensim_mot(directorys);
    catch
        disp(['Could not load data from directory: ' directorys]);
        return;
    end

    % Normalize time data 
    act_time = act_data(:,1);
    act_time_norm = (act_time - act_time(1)) / (act_time(end)-act_time(1)) * 100;

    % Plot Muscle Activation compared to EMG data

    % Select the EMG file
    emg_file_1 = dir(fullfile(['../data/' project_id '_' numeric_id '/walking'], '*EMG*'));
    emg_file = [emg_file_1.folder '/' emg_file_1.name];
    disp(['EMG file: ' emg_file_1.name]);

    % Suppress warnings temporarily
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

    try
        % Load the EMG file
        emt_data = readtable(emg_file, 'FileType', 'text', 'Delimiter', '\t', 'HeaderLines', 10);
        disp('EMG file loaded successfully.');
    catch
        disp('ERROR: No EMG file could be found.');
        return;
    end

    % Extract the relevant columns
    ind_start = find(emt_data.Time == time_start, 1);  % Find indices of start and stop time
    ind_stop = find(emt_data.Time == time_stop, 1);  

    tibant_r = emt_data.RightTibialisAnterior(ind_start:ind_stop); 
    vaslat_r = emt_data.RightVastusLateralis(ind_start:ind_stop); 
    gaslat_r = emt_data.RightGastrocnemiusLateralis(ind_start:ind_stop); 
    bflh_r = emt_data.RightBicepsFemorisCaputLongus(ind_start:ind_stop); 
    emt_time = emt_data.Frame(ind_start:ind_stop);
    emt_time = (emt_time - emt_time(1)) / (emt_time(end)-emt_time(1)) * 100;

    % Preprocess raw EMG data
    tibant_r = preprocess_emg(tibant_r, sf);
    vaslat_r = preprocess_emg(vaslat_r, sf);
    gaslat_r = preprocess_emg(gaslat_r, sf);
    bflh_r = preprocess_emg(bflh_r, sf);

    % Set muscles to analyze
    msls = {'tibant_r','vaslat_r','gaslat_r','bflh_r'};
    msl_names = {'Tibialis Anterior','Vastus lateralis','Gastrocnemius lateralis','Biceps femoris caput longus'};
    emg_signals = {tibant_r, vaslat_r, gaslat_r, bflh_r};

    act_fig = figure('name','Muscle Activation compared to EMG','Position',[100 100 1600 800], 'Visible', 'off');
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    for i = 1:length(msls)

        % Set plotting parameters
        subplot(2,2,i);hold on;
        yyaxis left;
        ylabel('Muscle Activation');
        ind = find(contains(act_labels, msls{i}));
        plot(act_time_norm, act_data(:,ind), 'b-', 'LineWidth', line_width, 'LineStyle', '-');

        % Set the y-axis limit for simulated data
        ylim([0 1]);

        % Plot EMG results
        yyaxis right;
        emt_time = linspace(0, 100, length(emg_signals{i})); % normalize x-axis
        plot(emt_time, emg_signals{i}, 'r-', 'LineWidth', line_width / 2); % Plot EMG data

        % Adjust y-axis limits for EMG data to match simulated data
        max_emg_axis = (1 / max(act_data(:,ind))) * max(emg_signals{i});
        ylim([0 max_emg_axis]);
        ylabel('EMG Signal (mV)');

        % Match the color of the axis with the corresponding line
        ax = gca;
        ax.YAxis(1).Color = 'b';
        ax.YAxis(2).Color = 'r';

        title(msl_names{i});
        legend('Simulated activation', 'Experimental EMG');
        xticks(0:10:100);
        xlabel('Gait Cycle [%]');
        grid on;
        set(gca, 'FontSize', 12);

        % Cross-Correlation Analysis
        % Resample both signals to 101 time points
        resampled_time = linspace(0, 100, 101);
        resampled_sim_signal = interp1(act_time_norm, act_data(:,ind), resampled_time);
        resampled_emg_signal = interp1(emt_time, emg_signals{i}, resampled_time);

        % Compute cross-correlation
        [cross_corr, lags] = xcorr(resampled_sim_signal, resampled_emg_signal, 'coeff');

        % Find the lag with the maximum correlation
        [max_corr, max_index] = max(cross_corr);
        lag_at_max_corr = lags(max_index);

        % Calculate correlation at lag = 0
        zero_lag_corr = cross_corr(lags == 0);

        % Display the lag, maximum correlation, and correlation at lag = 0
        text(10, 0.8 * max_emg_axis, ['Lag: ', num2str(lag_at_max_corr)], 'Color', 'k', 'FontSize', 12);
        text(10, 0.7 * max_emg_axis, ['Max Corr: ', num2str(max_corr, '%.2f')], 'Color', 'k', 'FontSize', 12);
        text(10, 0.6 * max_emg_axis, ['Corr @ Lag 0: ', num2str(zero_lag_corr, '%.2f')], 'Color', 'k', 'FontSize', 12);

    end

    saveas(act_fig, ['../results/' project_id '_' numeric_id '/graphics/validation/muscle_activations_vs_EMG.png']);
    close(act_fig);
end
