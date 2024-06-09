import org.opensim.modeling as osim

def run_ik(model_file, motion_file, ik_result_dir, numeric_id, project_id, results_basename, time_start, time_stop):
    """
    Perform Inverse Kinematics using the COMAKInverseKinematicsTool.

    Parameters:
        model_file (string): Path to the model .osim file.
        motion_file (string): Path to the motion .trc file.
        ik_result_dir (string): Directory to store the results.
        numeric_id: string, numerical identifier for results directories
        results_basename (string): Basename for the result files.
        time_start (double): Start time for the analysis.
        time_stop (double): Stop time for the analysis.
    """
    osim.Logger.setLevelString('Debug')

    comak_ik = osim.COMAKInverseKinematicsTool()
    comak_ik.set_model_file(model_file)
    comak_ik.set_results_directory(ik_result_dir)
    comak_ik.set_results_prefix(results_basename)
    comak_ik.set_perform_secondary_constraint_sim(True)
    comak_ik.set_secondary_coordinates(0, '/jointset/knee_r/knee_add_r')
    comak_ik.set_secondary_coordinates(1, '/jointset/knee_r/knee_rot_r')
    comak_ik.set_secondary_coordinates(2, '/jointset/knee_r/knee_tx_r')
    comak_ik.set_secondary_coordinates(3, '/jointset/knee_r/knee_ty_r')
    comak_ik.set_secondary_coordinates(4, '/jointset/knee_r/knee_tz_r')
    comak_ik.set_secondary_coordinates(5, '/jointset/pf_r/pf_flex_r')
    comak_ik.set_secondary_coordinates(6, '/jointset/pf_r/pf_rot_r')
    comak_ik.set_secondary_coordinates(7, '/jointset/pf_r/pf_tilt_r')
    comak_ik.set_secondary_coordinates(8, '/jointset/pf_r/pf_tx_r')
    comak_ik.set_secondary_coordinates(9, '/jointset/pf_r/pf_ty_r')
    comak_ik.set_secondary_coordinates(10, '/jointset/pf_r/pf_tz_r')
    comak_ik.set_secondary_coupled_coordinate('/jointset/knee_r/knee_flex_r')
    comak_ik.set_secondary_constraint_sim_settle_threshold(1e-4)
    comak_ik.set_secondary_constraint_sim_sweep_time(3.0)
    comak_ik.set_secondary_coupled_coordinate_start_value(0)
    comak_ik.set_secondary_coupled_coordinate_stop_value(100)
    comak_ik.set_secondary_constraint_sim_integrator_accuracy(1e-2)
    comak_ik.set_secondary_constraint_sim_internal_step_limit(10000)
    comak_ik.set_secondary_constraint_function_file(f'{ik_result_dir}/secondary_coordinate_constraint_functions.xml')
    comak_ik.set_constraint_function_num_interpolation_points(20)
    comak_ik.set_print_secondary_constraint_sim_results(True)
    comak_ik.set_constrained_model_file(f'{ik_result_dir}/ik_constrained_model.osim')
    comak_ik.set_perform_inverse_kinematics(True)
    comak_ik.set_marker_file(motion_file)
    comak_ik.set_output_motion_file(f'{results_basename}_ik.mot')
    comak_ik.set_time_range(0, time_start)
    comak_ik.set_time_range(1, time_stop)
    comak_ik.set_report_errors(True)
    comak_ik.set_report_marker_locations(False)
    comak_ik.set_ik_constraint_weight(100)
    comak_ik.set_ik_accuracy(1e-5)
    comak_ik.set_use_visualizer(False)
    comak_ik.set_verbose(10)
    
    ik_task_set = osim.IKTaskSet()
    
    marker_names = [
        ('r.should', 1), ('l.should', 1), ('c7', 1), 
        ('r.asis', 15), ('l.asis', 15), ('sacrum', 15),
        ('r.bar1', 5), ('r.knee1', 20), ('r.bar2', 5),
        ('r.mall', 20), ('r.heel', 20), ('r.met', 20),
        ('l.bar1', 5), ('l.knee1', 20), ('l.bar2', 5),
        ('l.mall', 20), ('l.heel', 20), ('l.met', 20)
    ]
    
    for name, weight in marker_names:
        ik_task = osim.IKMarkerTask()
        ik_task.setName(name)
        ik_task.setWeight(weight)
        ik_task_set.cloneAndAppend(ik_task)
    
    comak_ik.set_IKTaskSet(ik_task_set)
    comak_ik.print(f'../inputs/{project_id}_{numeric_id}/comak_inverse_kinematics_settings.xml')
    print('Running COMAKInverseKinematicsTool...')
    comak_ik.run()
