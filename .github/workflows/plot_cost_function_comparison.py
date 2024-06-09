import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from read_opensim_mot import read_opensim_mot  # Assuming this is a custom function you'll need to implement
from preprocess_emg import preprocess_emg  # Assuming this is a custom function you'll need to implement
from emg_onoff import emg_onoff  # Assuming this is a custom function you'll need to implement

def plot_cost_function_comparison(project_id, numeric_id, BW, time_start, time_stop, sf):
    """
    Compare cost functions by plotting tibiofemoral contact forces and muscle activations

    Parameters:
        project_id (string): The project identifier
        numeric_id (string): The numeric identifier for the project
        BW (float): Body weight of the subject
        time_start (float): Start time of the analysis
        time_stop (float): Stop time of the analysis
        sf (int): Sampling frequency for EMG data
    """
    # Set plot parameters
    line_width = 2

    # Define directories to check
    directories = {
        'joint_mechanics': None,
        'joint_mechanics_contact_energy': None,
        'joint_mechanics_muscle_weight': None,
        'joint_mechanics_contact_energy_2': None
    }

    # Try loading data from each directory
    for directory in directories:
        try:
            path = f'../results/{project_id}_{numeric_id}/{directory}/walking_{numeric_id}_ForceReporter_forces.sto'
            data, labels, _ = read_opensim_mot(path)
            directories[directory] = (data, labels)
        except FileNotFoundError:
            print(f'Could not load data from directory: {directory}')

    # Normalize time data if available
    for key in directories:
        if directories[key] is not None:
            data = directories[key][0]
            time = data[:, 0]
            time_norm = (time - time[0]) / (time[-1] - time[0]) * 100
            directories[key] = (data, directories[key][1], time_norm)

    # Plot Tibiofemoral Contact Forces
    kcf_fig = plt.figure('Tibiofemoral Contact Forces', figsize=(10, 8))
    plt.title('Tibia Axial Contact Force')
    plt.xlabel('Gait Cycle [%]')
    plt.ylabel('Tibia Axial Contact Force [BW]')
    plt.grid(True)

    legend_entries = []
    for key, (data, labels, time_norm) in directories.items():
        if data is not None:
            ind = labels.index('tf_contact.tibia_cartilage.total.contact_force_y')
            plt.plot(time_norm, abs(data[:, ind] / BW * 9.81), linewidth=line_width)
            legend_entries.append(key.replace('_', ' '))

    plt.legend(legend_entries)
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/knee_contact_force_cost_function_comparison.png')

    # Plot Muscle Activation
    directories = {
        'comak': None,
        'comak_contact_energy': None,
        'comak_muscle_weight': None,
        'comak_contact_energy_2': None
    }

    # Try loading data from each directory
    for directory in directories:
        try:
            path = f'../results/{project_id}_{numeric_id}/{directory}/walking_{numeric_id}_activation.sto'
            data, labels, _ = read_opensim_mot(path)
            directories[directory] = (data, labels)
        except FileNotFoundError:
            print(f'Could not load data from directory: {directory}')

    # Normalize time data if available
    for key in directories:
        if directories[key] is not None:
            data = directories[key][0]
            time = data[:, 0]
            time_norm = (time - time[0]) / (time[-1] - time[0]) * 100
            directories[key] = (data, directories[key][1], time_norm)

    msls = ['soleus', 'gasmed_r', 'recfem_r', 'semimem_r', 'glmed1_r', 'glmin1_r']
    msl_names = ['soleus', 'gasmed', 'recfem', 'semimem', 'glmed1', 'glmin1']

    act_fig = plt.figure('Muscle Activations', figsize=(20, 8))
    plt.suptitle('Muscle Activations')

    for i, msl in enumerate(msls):
        plt.subplot(2, 3, i + 1)
        plt.title(msl_names[i])
        plt.xlabel('Gait Cycle [%]')
        plt.ylabel('Activation')
        plt.grid(True)
        legend_entries = []

        for key, (data, labels, time_norm) in directories.items():
            if data is not None:
                ind = labels.index(msl)
                plt.plot(time_norm, data[:, ind], linewidth=line_width)
                legend_entries.append(key.replace('_', ' '))

        plt.legend(legend_entries)

    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/muscle_activations_cost_function_comparison.png')

    # Plot Muscle Activation compared to EMG data
    emg_file_1 = next((f for f in os.listdir(f'../data/{project_id}_{numeric_id}/walking') if 'EMG' in f), None)
    emg_file = os.path.join(f'../data/{project_id}_{numeric_id}/walking', emg_file_1)
    print(f'EMG file: {emg_file_1}')

    try:
        emt_data = pd.read_csv(emg_file, delimiter='\t', skiprows=10)
        print('EMG file loaded successfully.')
    except FileNotFoundError:
        print('ERROR: No EMG file could be found.')
        return

    ind_start = emt_data['Time'].sub(time_start).abs().idxmin()
    ind_stop = emt_data['Time'].sub(time_stop).abs().idxmin()

    tibant_r = preprocess_emg(emt_data['RightTibialisAnterior'][ind_start:ind_stop], sf)
    vaslat_r = preprocess_emg(emt_data['RightVastusLateralis'][ind_start:ind_stop], sf)
    gaslat_r = preprocess_emg(emt_data['RightGastrocnemiusLateralis'][ind_start:ind_stop], sf)
    bflh_r = preprocess_emg(emt_data['RightBicepsFemorisCaputLongus'][ind_start:ind_stop], sf)
    emt_time = np.linspace(0, 100, len(tibant_r))

    msls = [tibant_r, vaslat_r, gaslat_r, bflh_r]
    msl_names = ['Tibialis Anterior', 'Vastus lateralis', 'Gastrocnemius lateralis', 'Biceps femoris caput longus']

    act_fig_2 = plt.figure('Muscle Activation compared to EMG', figsize=(20, 8))
    plt.suptitle('Muscle Activation compared to EMG')

    for i, msl in enumerate(msls):
        plt.subplot(2, 2, i + 1)
        plt.title(msl_names[i])
        plt.xlabel('Gait Cycle [%]')
        plt.ylabel('Activation')
        plt.grid(True)
        legend_entries = []

        for key, (data, labels, time_norm) in directories.items():
            if data is not None:
                ind = labels.index(msl_names[i].lower().replace(' ', '_'))
                plt.plot(time_norm, data[:, ind], linewidth=line_width, label=f'Simulation ({key.replace("_", " ")})')

                logicalonoff_data = emg_onoff(data[:, ind], 100, 0)
                logicalonoff_data[0] = 0
                logicalonoff_data[-1] = 0
                plt.fill_between(time_norm, logicalonoff_data * max(data[:, ind]), alpha=0.1)

        plt.plot(emt_time, msl, 'r-', linewidth=line_width / 2, label='EMG signal')
        logicalonoff_emg = emg_onoff(msl, sf, 0)
        logicalonoff_emg[0] = 0
        logicalonoff_emg[-1] = 0
        plt.fill_between(emt_time, logicalonoff_emg * max(msl), alpha=0.1)
        legend_entries.append('EMG signal')
        plt.legend(legend_entries)

    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/muscle_activations_vs_EMG.png')
