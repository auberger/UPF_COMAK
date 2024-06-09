import org.opensim.modeling as osim

def run_joint_mechanics(model_file, comak_result_dir, jnt_mech_result_dir, numeric_id, project_id, results_basename, time_start=-1, time_stop=-1, print_vtp=False, custom_muscle_weights=False, comak_muscle_weight_result_dir=None, jnt_mech_muscle_weight_result_dir=None, compare_contact_energy_weight=False, comak_contact_energy_2_result_dir=None, jnt_mech_contact_energy_2_result_dir=None):
    """
    Perform Joint Mechanics Analysis

    Parameters:
        model_file: string, path to the model file
        comak_result_dir: string, directory containing COMAK results
        jnt_mech_result_dir: string, directory to save Joint Mechanics results
        numeric_id: string, numerical identifier for directories
        project_id: string, project identifier
        results_basename: string, base name for the results files
        time_start: double, start time of the analysis
        time_stop: double, stop time of the analysis
        print_vtp: boolean, flag to print VTP files
        custom_muscle_weights: boolean, flag to use custom muscle weights
        comak_muscle_weight_result_dir: string, directory containing COMAK results with custom muscle weights
        jnt_mech_muscle_weight_result_dir: string, directory to save Joint Mechanics results with custom muscle weights
        compare_contact_energy_weight: double or boolean, contact energy weight for comparison (false if not comparing)
        comak_contact_energy_2_result_dir: string, directory containing COMAK results with the second contact energy weight
        jnt_mech_contact_energy_2_result_dir: string, directory to save Joint Mechanics results for comparison
    """
    osim.Logger.setLevelString('Debug')

    jnt_mech = osim.JointMechanicsTool()
    jnt_mech.set_model_file(model_file)
    jnt_mech.set_use_muscle_physiology(False)
    jnt_mech.set_start_time(time_start)
    jnt_mech.set_stop_time(time_stop)
    jnt_mech.set_resample_step_size(-1)
    jnt_mech.set_normalize_to_cycle(True)
    jnt_mech.set_lowpass_filter_frequency(-1)
    jnt_mech.set_print_processed_kinematics(False)
    jnt_mech.set_contacts(0, 'all')
    jnt_mech.set_contact_outputs(0, 'all')
    jnt_mech.set_contact_mesh_properties(0, 'none')
    jnt_mech.set_ligaments(0, 'all')
    jnt_mech.set_ligament_outputs(0, 'all')
    jnt_mech.set_muscles(0, 'all')
    jnt_mech.set_muscle_outputs(0, 'all')
    jnt_mech.set_attached_geometry_bodies(0, 'all')
    jnt_mech.set_output_orientation_frame('ground')
    jnt_mech.set_output_position_frame('ground')
    jnt_mech.set_write_vtp_files(print_vtp)
    jnt_mech.set_vtp_file_format('binary')
    jnt_mech.set_write_h5_file(True)
    jnt_mech.set_h5_kinematics_data(True)
    jnt_mech.set_h5_states_data(True)
    jnt_mech.set_write_transforms_file(False)
    jnt_mech.set_output_transforms_file_type('sto')
    jnt_mech.set_use_visualizer(False)
    jnt_mech.set_verbose(0)
    
    # Add ForceReporter analysis to the Joint Mechanics Tool
    analysis_set = osim.AnalysisSet()
    frc_reporter = osim.ForceReporter()
    frc_reporter.setName('ForceReporter')
    analysis_set.cloneAndAppend(frc_reporter)
    jnt_mech.set_AnalysisSet(analysis_set)

    if custom_muscle_weights:
        # Set input states file and results directory for custom muscle weights
        jnt_mech.set_input_states_file(f'{comak_muscle_weight_result_dir}/{results_basename}_muscle_weight_states.sto')
        jnt_mech.set_results_directory(jnt_mech_muscle_weight_result_dir)
    else:
        # Set input states file and results directory for default muscle weights
        jnt_mech.set_input_states_file(f'{comak_result_dir}/{results_basename}_states.sto')
        jnt_mech.set_results_directory(jnt_mech_result_dir)
    
    # Print settings and run Joint Mechanics Tool
    jnt_mech.print(f'../inputs/{project_id}_{numeric_id}/joint_mechanics_settings.xml')
    print('Running JointMechanicsTool...')
    jnt_mech.run()

    if compare_contact_energy_weight:
        # Set input states file and results directory for comparison
        jnt_mech.set_input_states_file(f'{comak_contact_energy_2_result_dir}/{results_basename}_contact_energy_{compare_contact_energy_weight}_states.sto')
        jnt_mech.set_results_directory(jnt_mech_contact_energy_2_result_dir)

        # Print settings and run Joint Mechanics Tool for comparison
        jnt_mech.print(f'../inputs/{numeric_id}/joint_mechanics_contact_energy_{compare_contact_energy_weight}_settings.xml')
        print(f'Running JointMechanicsTool with contact energy weight = {compare_contact_energy_weight}...')
        jnt_mech.run()
