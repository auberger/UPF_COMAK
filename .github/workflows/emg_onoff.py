import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import label

def EMG_onoff(EMG, sf, plotornot=0):
    """
    Determine whether muscle was on or off based on its raw rectified EMG signal.

    Parameters:
        EMG (np.ndarray): Raw rectified EMG signal.
        sf (float): Sampling frequency.
        plotornot (int, optional): Flag to indicate whether to plot the result. Default is 0.

    Returns:
        OnOff (np.ndarray): Array indicating muscle on (1) or off (0).
    """
    # Amplitude threshold = a multiple of the std of the resting signal:
    thres_SD_factor = 1.2

    # Calculate the on-threshold based on the resting signal and its standard deviation:
    thres_EMG_OnOff = thres_SD_factor * np.std(EMG[:100])

    # Determine when the muscle is on (1) and off (0)
    OnOff = EMG > thres_EMG_OnOff  # logical

    # Minimum duration for the muscle to be on:
    msd_on = 0.05  # [s]
    msd_on_frames = round(msd_on * sf)

    # Minimum duration for the muscle to be off:
    msd_off = 0.025  # [s]
    msd_off_frames = round(msd_off * sf)

    # Turn ON all OFF-sections that are too short:
    # Identify OFF-sections with label: E.g. 000110010111 -> 111002203000
    tibant_activity_off_labeled, num_features = label(~OnOff)  # OnOff is flipped, so that OFF-sections are labeled.

    for i_label in range(1, num_features + 1):  # Test number of samples for each OFF-section
        if np.sum(tibant_activity_off_labeled == i_label) < msd_off_frames:
            OnOff[tibant_activity_off_labeled == i_label] = 1

    # Turn OFF all ON-sections that are too short:
    # Identify ON-sections with label: E.g. 000110010111 -> 000110020333
    tibant_activity_labeled, num_features = label(OnOff)

    for i_label in range(1, num_features + 1):  # Test number of samples for each ON-section:
        if np.sum(tibant_activity_labeled == i_label) < msd_on_frames:
            OnOff[tibant_activity_labeled == i_label] = 0

    if plotornot == 1:
        # Plot final result in new plot:
        emt_time = np.linspace(0, 100, len(EMG))  # normalize x-axis
        plt.figure(figsize=(12, 8))
        plt.plot(emt_time, EMG, 'b-')
        plt.plot(emt_time, OnOff * np.max(EMG), 'r-', linewidth=2)
        plt.legend(['Processed EMG', 'OnOff'])
        plt.title('Processed EMG and On/Off Sections')
        plt.xlabel('Gait Cycle [%]')
        plt.savefig('EMG_onoff_plot.png')
        plt.show()

    return OnOff
