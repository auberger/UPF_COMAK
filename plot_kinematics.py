import os
import numpy as np
import matplotlib.pyplot as plt
from read_opensim_mot import read_opensim_mot  # Assuming this is a custom function you'll need to implement

def plot_kinematics(numeric_id, project_id):
    """
    Plot tibiofemoral kinematics for a given patient.

    Parameters:
        numeric_id (string): The numeric identifier for the project
        project_id (string): The project identifier
    """
    # Plot parameters
    line_width = 2
    
    # Load data for the patient
    try:
        values_data, values_labels, _ = read_opensim_mot(f'../results/{project_id}_{numeric_id}/comak_muscle_weight/walking_{numeric_id}_muscle_weight_values.sto')
    except FileNotFoundError:
        print('ERROR: Simulation results not found!')
        return  # Exit the function if no data is found

    # Normalize time
    time = values_data[:, 0]
    Time_normed = (time - time[0]) / (time[-1] - time[0]) * 100

    # Define coordinate sets for comparison
    coords = [
        {'label': 'knee_flex_r', 'title': 'Flexion', 'ylabel': 'Angle [°]'},
        {'label': 'knee_add_r', 'title': 'Adduction', 'ylabel': 'Angle [°]'},
        {'label': 'knee_rot_r', 'title': 'Internal Rotation', 'ylabel': 'Angle [°]'},
        {'label': 'knee_tx_r', 'title': 'Anterior Translation', 'ylabel': 'Translation [mm]', 'scale': 1000},
        {'label': 'knee_ty_r', 'title': 'Superior Translation', 'ylabel': 'Translation [mm]', 'scale': 1000},
        {'label': 'knee_tz_r', 'title': 'Lateral Translation', 'ylabel': 'Translation [mm]', 'scale': 1000}
    ]

    # Plot kinematics
    kin_fig, axes = plt.subplots(2, 3, figsize=(18, 10))
    kin_fig.suptitle('Tibiofemoral Kinematics')
    axes = axes.flatten()

    for i, coord in enumerate(coords):
        axes[i].set_title(coord['title'])
        axes[i].set_xlabel('Gait Cycle [%]')
        axes[i].set_ylabel(coord['ylabel'])
        axes[i].grid(True)

        ind = [j for j, label in enumerate(values_labels) if coord['label'] in label]
        data = values_data[:, ind].flatten()
        if 'scale' in coord:
            data *= coord['scale']
        axes[i].plot(Time_normed, data, linewidth=line_width)

    # Save figure
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/tibiofemoral_kinematics.png')
    plt.close(kin_fig)
    print(f'Plot "tibiofemoral_kinematics.png" saved to "../results/{project_id}_{numeric_id}/graphics/"')
