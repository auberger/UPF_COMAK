import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d
from read_opensim_mot import read_opensim_mot  # Assuming this is a custom function you'll need to implement

def plot_primary_coordinates_vs_mocap(numeric_id, project_id, directory_walking):
    """
    Compare primary coordinates from motion capture and simulation

    Parameters:
        numeric_id (string): The numeric identifier for the project
        project_id (string): The project identifier
        directory_walking (string): Directory path for walking data
    """
    # Normalize the data to 1 gait cycle (downsample from 120 to 100 samples)
    Time_steps = 100
    Time_normed = np.linspace(0, 1, Time_steps)

    # Load data for the patient
    data_loaded = False

    paths_to_try = [
        f'../results/{project_id}_{numeric_id}/comak/walking_{numeric_id}_values.sto',
        f'../results/{project_id}_{numeric_id}/comak_contact_energy/walking_{numeric_id}_contact_energy_values.sto',
        f'../results/{project_id}_{numeric_id}/comak_muscle_weight/walking_{numeric_id}_muscle_weight_values.sto'
    ]

    for path in paths_to_try:
        try:
            values_data, values_labels, _ = read_opensim_mot(path)
            data_loaded = True
            break
        except FileNotFoundError:
            continue

    if not data_loaded:
        print('ERROR: Simulation results not found!')
        return

    # Normalize time
    time_data = values_data[:, 0]
    time_norm = np.linspace(0, max(Time_normed), len(time_data))

    # Resample data
    resampled_values_data = np.zeros((len(Time_normed), values_data.shape[1]))
    resampled_values_data[:, 0] = Time_normed

    for i in range(1, values_data.shape[1]):  # Start from 1 to skip the time column
        f_interp = interp1d(time_norm, values_data[:, i], kind='linear')
        resampled_values_data[:, i] = f_interp(Time_normed)

    # Overwrite
    values_data = resampled_values_data

    # Plot Knee Primary Kinematics Compared to Motion Capture Software

    # Prompt user for the path to the EMT file
    emt_file_1 = next((f for f in os.listdir(directory_walking) if 'Angle' in f), None)
    emt_file = os.path.join(directory_walking, emt_file_1)
    print(f'Motion capture IK file of estimated joint angles: {emt_file_1}')

    # Suppress warnings temporarily
    pd.options.mode.chained_assignment = None

    # Load the EMT file
    emt_data = pd.read_csv(emt_file, delimiter='\t', skiprows=7)  # Assuming the header is 7 rows

    # Extract the relevant column for knee flexion extension angles
    acmRKFE = emt_data['acmRKFE_M']
    acm_time = emt_data['Sample']

    # Calculate MAE and Max Error
    ind = values_labels.index('knee_flex_r')
    mae_value = np.mean(np.abs(acmRKFE - values_data[:, ind]))
    max_error = np.max(np.abs(acmRKFE - values_data[:, ind]))

    # Plot the data
    plt.figure()

    # Plot mocap data
    plt.plot(acm_time, acmRKFE, linewidth=1.5, label='Motion Capture Software')
    
    # Display MAE and Max Error on the plot
    plt.text(0.1, 0.9, f'MAE: {mae_value:.2f} deg', transform=plt.gca().transAxes)
    plt.text(0.1, 0.85, f'Max Error: {max_error:.2f} deg', transform=plt.gca().transAxes)

    # Plot simulation results
    plt.plot(Time_normed, values_data[:, ind], linewidth=1.5, label='Simulation Results')

    plt.title('Comparison of Knee Flexion-Extension Angles')
    plt.xlabel('Gait cycle [%]')
    plt.ylabel('Angle [degrees]')
    plt.legend()
    plt.grid(True)

    # Save figure
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/primary_tibiofemoral_kinematics_with_mocap.png')
    plt.close()
    print('Plot "primary_tibiofemoral_kinematics_with_mocap.png" got saved to the "graphics" directory!')
