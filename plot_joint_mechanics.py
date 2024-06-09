import os
import numpy as np
import matplotlib.pyplot as plt
from read_opensim_mot import read_opensim_mot  # Assuming this is a custom function you'll need to implement

def plot_joint_mechanics(project_id, numeric_id, forces_file, BW):
    """
    Plot joint mechanics for a given patient.

    Parameters:
        project_id (string): The project identifier
        numeric_id (string): The numeric identifier for the project
        forces_file (string): Path to the forces file
        BW (float): Body weight of the subject
    """
    # Load data
    forces_data, forces_labels, _ = read_opensim_mot(forces_file)

    # Normalize time
    forces_time = forces_data[:, 0]
    forces_time_norm = (forces_time - forces_time[0]) / (forces_time[-1] - forces_time[0]) * 100

    # Body weight in Newtons
    BW = BW * 9.81

    # Line width for plots
    line_width = 2

    ## Plot Contact Forces
    contact_forces_fig, axes = plt.subplots(3, 1, figsize=(10, 15))
    contact_forces_fig.suptitle('Contact Forces on Tibial Plateau Cartilage')
    for i in range(3):
        axes[i].plot(forces_time_norm, forces_data[:, 588 + i] / BW, 'b-', linewidth=line_width, label='Total')
        axes[i].plot(forces_time_norm, forces_data[:, 672 + i] / BW, 'g-', linewidth=line_width, label='Medial')
        axes[i].plot(forces_time_norm, forces_data[:, 675 + i] / BW, 'r-', linewidth=line_width, label='Lateral')
        axes[i].set_ylabel('Joint Contact Force [BW]')
        axes[i].set_xlabel('Gait Cycle [%]')
        axes[i].set_title(f'Contact Forces - {chr(88 + i)}')
        axes[i].legend()
        axes[i].grid(True)
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/Contact_Forces_plot.png')
    plt.close(contact_forces_fig)

    ## Plot Joint Reaction Moments
    reaction_moments_fig, axes = plt.subplots(3, 1, figsize=(10, 15))
    reaction_moments_fig.suptitle('Reaction Moments on Tibial Plateau Cartilage')
    for i in range(3):
        axes[i].plot(forces_time_norm, forces_data[:, 591 + i], 'b-', linewidth=line_width, label='Total')
        axes[i].plot(forces_time_norm, forces_data[:, 690 + i], 'g-', linewidth=line_width, label='Medial')
        axes[i].plot(forces_time_norm, forces_data[:, 693 + i], 'r-', linewidth=line_width, label='Lateral')
        axes[i].set_ylabel('Joint Reaction Moments [Nm]')
        axes[i].set_xlabel('Gait Cycle [%]')
        axes[i].set_title(f'Reaction Moments - {chr(88 + i)}')
        axes[i].legend()
        axes[i].grid(True)
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/Reaction_Moments_plot.png')
    plt.close(reaction_moments_fig)

    ## Plot Contact Area and Pressure
    contact_area_pressure_fig, axes = plt.subplots(3, 1, figsize=(10, 15))
    contact_area_pressure_fig.suptitle('Contact Area and Pressure')
    
    axes[0].plot(forces_time_norm, forces_data[:, 578], 'b-', linewidth=line_width, label='Total')
    axes[0].plot(forces_time_norm, forces_data[:, 599], 'g-', linewidth=line_width, label='Medial')
    axes[0].plot(forces_time_norm, forces_data[:, 600], 'r-', linewidth=line_width, label='Lateral')
    axes[0].set_ylabel('Area (mm²)')
    axes[0].set_title('Contact Area')
    axes[0].legend()
    axes[0].grid(True)
    
    axes[1].plot(forces_time_norm, forces_data[:, 584], 'b-', linewidth=line_width, label='Total')
    axes[1].plot(forces_time_norm, forces_data[:, 635], 'g-', linewidth=line_width, label='Medial')
    axes[1].plot(forces_time_norm, forces_data[:, 636], 'r-', linewidth=line_width, label='Lateral')
    axes[1].set_ylabel('Pressure (MPa)')
    axes[1].set_title('Mean Contact Pressure')
    axes[1].legend()
    axes[1].grid(True)
    
    axes[2].plot(forces_time_norm, forces_data[:, 585], 'b-', linewidth=line_width, label='Total')
    axes[2].plot(forces_time_norm, forces_data[:, 641], 'g-', linewidth=line_width, label='Medial')
    axes[2].plot(forces_time_norm, forces_data[:, 642], 'r-', linewidth=line_width, label='Lateral')
    axes[2].set_ylabel('Pressure (MPa)')
    axes[2].set_title('Max. Contact Pressure')
    axes[2].legend()
    axes[2].grid(True)
    
    for ax in axes:
        ax.set_xlabel('Gait Cycle [%]')
    
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/Contact_Area_Pressure_plot.png')
    plt.close(contact_area_pressure_fig)

    ## Plot Center of Pressure
    center_of_pressure_fig, axes = plt.subplots(3, 1, figsize=(10, 15))
    center_of_pressure_fig.suptitle('Center of Pressure')
    info = ['Anterior-Posterior', 'Superior-Inferior', 'Medial-Lateral']
    
    for i in range(3):
        axes[i].plot(forces_time_norm, forces_data[:, 585 + i] * 1000, 'b-', linewidth=line_width, label='Total')
        axes[i].plot(forces_time_norm, forces_data[:, 654 + i] * 1000, 'g-', linewidth=line_width, label='Medial')
        axes[i].plot(forces_time_norm, forces_data[:, 657 + i] * 1000, 'r-', linewidth=line_width, label='Lateral')
        axes[i].set_ylabel('CoP [mm]')
        axes[i].set_xlabel('Gait Cycle [%]')
        axes[i].set_title(f'Center of Pressure - {info[i]} ({chr(88 + i)})')
        axes[i].legend()
        axes[i].grid(True)
    
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    plt.savefig(f'../results/{project_id}_{numeric_id}/graphics/Center_of_Pressure_plot.png')
    plt.close(center_of_pressure_fig)
    
    print(f'Plots saved to "../results/{project_id}_{numeric_id}/graphics/"')

