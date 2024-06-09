import numpy as np
import scipy
from scipy.signal import butter, filtfilt
from scipy.ndimage import uniform_filter1d

def preprocess_emg(emg_data, sf, time4offset=0.1, filtorder=3, filtercut=20, filter_kind='high', time4smoothing=0.05):
    """
    Preprocess EMG data by removing offset, filtering, rectifying, and smoothing.

    Parameters:
        emg_data (np.ndarray): EMG data (vector).
        sf (float): Sampling frequency.
        time4offset (float, optional): Time used to determine offset. Default is 0.1s.
        filtorder (int, optional): Filter order. Default is 3.
        filtercut (float, optional): Cut off frequency in Hz. Default is 20Hz.
        filter_kind (str, optional): Which frequencies should pass ('high' or 'low'). Default is 'high'.
        time4smoothing (float, optional): Window width in seconds for smoothing. Default is 0.05s.

    Returns:
        emg_data_smooth (np.ndarray): Preprocessed EMG data (vector).
    """
    # Remove offset (using the first 0.1 s to determine the offset)
    frames4offset = round(time4offset * sf)
    data_offset = emg_data - np.mean(emg_data[:frames4offset])

    # High-pass filter EMG data -> remove movement artifacts (human movement is < 20Hz)
    EMG_Wn = filtercut * 2 / sf  # Normalized filter parameter (Wn = 1 if cut off frequency = highest captured freq. (= 0.5*fs))
    EMG_B, EMG_A = butter(filtorder, EMG_Wn, btype=filter_kind)  # Create filter coefficients for Butterworth filter
    data_filt = filtfilt(EMG_B, EMG_A, data_offset)  # Apply filter to EMG data (recursive/for-+backward to remove delay)

    # Rectify EMG data
    data_abs = np.abs(data_filt)

    # Smoothing of EMG data
    frames4smoothing = round(time4smoothing * sf)  # Window width in frames bzw. number of samples
    emg_data_smooth = uniform_filter1d(data_abs, size=frames4smoothing)  # Apply moving average filter

    return emg_data_smooth
