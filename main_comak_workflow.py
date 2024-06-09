import os
import pandas as pd
from extract_bodyweight_from_emt import extract_bodyweight_from_emt
from extract_bodyweight_from_mdx import extract_bodyweight_from_mdx
from run_ik import run_ik
from run_comak import run_comak
from run_joint_mechanics import run_joint_mechanics
from create_external_loads_xml import create_external_loads_xml
from plot_primary_coordinates_vs_mocap import plot_primary_coordinates_vs_mocap
from plot_cost_function_comparison import plot_cost_function_comparison
from plot_kinematics import plot_kinematics
from plot_joint_mechanics import plot_joint_mechanics
from save_output_to_text_file import save_output_to_text_file
from read_opensim_mot import read_opensim_mot
from emg_onoff import EMG_onoff
from preprocess_emg import preprocess_emg
# Import other functions as needed

def main():
    # Setup Environment and Folders
    print("Setting up environment and folders...")
    
    # Get the full path of the currently running script
    current_file = os.path.abspath(__file__)
    
    # Get the directory of the currently running script
    current_directory = os.path.dirname(current_file)
    
    # Change the current directory to the directory of the running script
    os.chdir(current_directory)
    
    # Specify inputs
    while True:
        project = input('Is the patient from the HOLOA (h) or STRATO (s) cohort? (e.g., h): ')
        if project in ['h', 's']:
            numeric_id = input('Enter the numeric ID for the results basename (e.g., 003): ')
            results_basename = f'walking_{numeric_id}'
            if project == 'h':
                project_id = 'HOLOA'
                # Extract body weight from info file
                directory = f'../data/{project_id}_{numeric_id}'
                BW = extract_bodyweight_from_mdx(directory)
            else:
                project_id = 'STRATO'
                # Extract body weight from info file
                directory = f'../data/{project_id}_{numeric_id}'
                BW = extract_bodyweight_from_emt(directory)
            if os.path.isdir(f'../data/{project_id}_{numeric_id}'):
                break
            else:
                print('ERROR: Patient not found!')
        else:
            print('ERROR: Please write "h" for HOLOA or "s" for STRATO')
    
    # Define directories
    directory_model = os.path.join(directory, 'model')
    directory_standing = os.path.join(directory, 'standing')
    directory_walking = os.path.join(directory, 'walking')
    
    # Get first and second heel strike to set times for the analysis
    file_hs = next((f for f in os.listdir(directory_walking) if 'Event' in f), None)
    hs_data = pd.read_csv(os.path.join(directory_walking, file_hs), delimiter='\t', skiprows=7)
    time_start = hs_data['eRHS'][0]
    time_stop = hs_data['eRHS'][1]
    
    print('______________________________________________________________________')
    print('INPUTS FOR COMAK:')
    print(f'First HS: {time_start}')
    print(f'Second HS: {time_stop}')
    print(f'Body weight: {BW:.2f} kg')
    
    # Select the scaled model
    model_file_1 = next((f for f in os.listdir(directory_model) if f.endswith('.osim')), None)
    model_file = os.path.join(directory_model, model_file_1)
    print(f'OpenSim scaled model file: {model_file_1}')
    
    # Select motion file
    motion_file_1 = next((f for f in os.listdir(directory_walking) if f.endswith('.trc')), None)
    motion_file = os.path.join(directory_walking, motion_file_1)
    print(f'Motion file: {motion_file_1}')
    
    # Create and set external loads file
    grf_file_1 = next((f for f in os.listdir(directory_walking) if f.endswith('.mot')), None)
    grf_file = os.path.join(directory_walking, grf_file_1)
    template_file = '../data/template_ext_loads.xml'
    print(f'Ground reaction file: {grf_file_1}')
    
    create_external_loads_xml(grf_file_1, template_file, directory_walking)
    ext_load_file_1 = next((f for f in os.listdir(directory_walking) if f.endswith('ext_loads.xml')), None)
    ext_load_file = os.path.join(directory_walking, ext_load_file_1)
    print(f'External loads file: {ext_load_file_1}')
    print('______________________________________________________________________')
    
    # Set results directory
    result_dirs = [
        'comak_inverse_kinematics',
        'comak',
        'comak_muscle_weight',
        'comak_contact_energy',
        'comak_contact_energy_2',
        'joint_mechanics',
        'joint_mechanics_muscle_weight',
        'joint_mechanics_contact_energy',
        'joint_mechanics_contact_energy_2',
        'graphics'
    ]
    
    for dir_name in result_dirs:
        dir_path = f'../results/{project_id}_{numeric_id}/{dir_name}'
        os.makedirs(dir_path, exist_ok=True)
        globals()[f'{dir_name}_result_dir'] = dir_path
    
    # Create inputs directory if it doesn't exist
    inputs_dir = f'../inputs/{project_id}_{numeric_id}'
    os.makedirs(inputs_dir, exist_ok=True)
    
    # Scale the model
    # Scale model code should go here...
    
    # Run COMAK Workflow
    run_ik(model_file, motion_file, comak_inverse_kinematics_result_dir, numeric_id, project_id, results_basename, time_start, time_stop)
    run_comak(model_file, ext_load_file, comak_result_dir, numeric_id, project_id, results_basename, time_start, time_stop, 0, False, None, 100, comak_contact_energy_result_dir)
    run_joint_mechanics(model_file, comak_result_dir, joint_mechanics_result_dir, numeric_id, project_id, results_basename, time_start, time_stop, False, False, None, None, 100, comak_contact_energy_result_dir, joint_mechanics_contact_energy_result_dir)
    run_comak(model_file, ext_load_file, comak_result_dir, numeric_id, project_id, results_basename, time_start, time_stop, 100, True, comak_muscle_weight_result_dir, 500, comak_contact_energy_2_result_dir)
    run_joint_mechanics(model_file, comak_result_dir, joint_mechanics_result_dir, numeric_id, project_id, results_basename, time_start, time_stop, False, True, comak_muscle_weight_result_dir, joint_mechanics_muscle_weight_result_dir, 500, comak_contact_energy_2_result_dir, joint_mechanics_contact_energy_2_result_dir)
    
    # Compare IK results with MoCap
    plot_primary_coordinates_vs_mocap(numeric_id, project_id, directory_walking)
    
    # Compare cost functions and use EMG data
    sf_emg = 1000
    plot_cost_function_comparison(project_id, numeric_id, BW, time_start, time_stop, sf_emg)
    
    # Analyse results with muscle weights and contact energy = 100 further (muscle_weight)
    plot_kinematics(numeric_id, project_id)
    
    # Plot joint mechanics
    forces_file = f'../results/{project_id}_{numeric_id}/joint_mechanics_muscle_weight/walking_{numeric_id}_ForceReporter_forces.sto'
    plot_joint_mechanics(project_id, numeric_id, forces_file, BW)
    
    # Create output text file
    save_output_to_text_file(project_id, numeric_id, forces_file)

if __name__ == "__main__":
    main()
