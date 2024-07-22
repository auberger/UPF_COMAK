function [emg_data_smooth] = preprocess_emg(emg_data, sf, time4offset, filtorder, filtercut, filter_kind, time4smoothing)
    % PREPROCESS_EMG performs standard preprocessing steps for EMG data:
    %    - Removing offset
    %    - Filtering
    %    - Rectifying
    %    - Smoothing
    %
    % Author: [Your Name]
    % Date: [Date of Creation]
    %
    % Inputs: 
    %    - emg_data:        EMG data (vector), raw EMG signals recorded from muscle sensors.
    %    - sf:              Sampling frequency (Hz), the rate at which EMG signals are sampled.
    %    - time4offset:     Time used to determine offset (default = 0.1s), duration for calculating baseline offset.
    %    - filtorder:       Filter order (default = 3), the order of the Butterworth filter applied.
    %    - filtercut:       Cut-off frequency (Hz) (default = 20Hz), frequency threshold for the filter.
    %    - filter_kind:     Filter type ('high' or 'low') (default = 'high'), specifies the filtering direction.
    %    - time4smoothing:  Window width for smoothing (seconds) (default = 0.05s), duration for moving average smoothing.
    %
    % Outputs:
    %    - emg_data_smooth: Preprocessed EMG data (vector), the resultant EMG signal after all preprocessing steps.


% Set default values for unspecified parameters
arguments
    emg_data
    sf
    time4offset  = 0.1
    filtorder = 3
    filtercut = 20
    filter_kind = 'high'
    time4smoothing= 0.05
end

% Remove offset (using the first 0.1 s to determine the offset)
frames4offset = round(time4offset*sf);
data_offset = emg_data - mean(emg_data(1:frames4offset));

% High-pass filter EMG data -> remove movement artifacts (human movement is < 20Hz)
EMG_Wn = filtercut*2/sf;                         % Normalized filter parameter (Wn = 1 if cut off frequency = highest captured freq. (= 0.5*fs))
[EMG_B,EMG_A] = butter(filtorder,EMG_Wn, filter_kind);    % Create filter coefficients for butterworth filter
data_filt = filtfilt(EMG_B,EMG_A,data_offset);            % Apply filter to EMG data (recursive/for-+backward to remove delay)

% Rectify EMG data
data_abs = abs(data_filt);

% Smoothening of EMG data
frames4smoothing = round(time4smoothing * sf);  % Window width in frames bzw. number of samples
emg_data_smooth = smooth(data_abs,frames4smoothing,'moving');

end





