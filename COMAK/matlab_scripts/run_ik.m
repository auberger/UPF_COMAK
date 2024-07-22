function [] = run_ik(model_file, motion_file, ik_result_dir, numeric_id, project_id, results_basename, time_start, time_stop)
    %% Perform Inverse Kinematics
    % This function performs inverse kinematics using the COMAKInverseKinematicsTool.
    % It sets up the model, directories, and various parameters for the inverse 
    % kinematics analysis, including secondary constraints and marker tasks.
    %
    % Parameters:
    %   model_file (string): Path to the model .osim file.
    %   motion_file (string): Path to the motion .trc file.
    %   ik_result_dir (string): Directory to store the results.
    %   numeric_id: string, numerical identifier for results directories
    %   results_basename (string): Basename for the result files.
    %   time_start (double): Start time for the analysis.
    %   time_stop (double): Stop time for the analysis.

    import org.opensim.modeling.*
    Logger.setLevelString('Debug');

    comak_ik = COMAKInverseKinematicsTool();
    comak_ik.set_model_file(model_file);
    comak_ik.set_results_directory(ik_result_dir);
    comak_ik.set_results_prefix(results_basename);
    comak_ik.set_perform_secondary_constraint_sim(true);
    comak_ik.set_secondary_coordinates(0,'/jointset/knee_r/knee_add_r');
    comak_ik.set_secondary_coordinates(1,'/jointset/knee_r/knee_rot_r');
    comak_ik.set_secondary_coordinates(2,'/jointset/knee_r/knee_tx_r');
    comak_ik.set_secondary_coordinates(3,'/jointset/knee_r/knee_ty_r');
    comak_ik.set_secondary_coordinates(4,'/jointset/knee_r/knee_tz_r');
    comak_ik.set_secondary_coordinates(5,'/jointset/pf_r/pf_flex_r');
    comak_ik.set_secondary_coordinates(6,'/jointset/pf_r/pf_rot_r');
    comak_ik.set_secondary_coordinates(7,'/jointset/pf_r/pf_tilt_r');
    comak_ik.set_secondary_coordinates(8,'/jointset/pf_r/pf_tx_r');
    comak_ik.set_secondary_coordinates(9,'/jointset/pf_r/pf_ty_r');
    comak_ik.set_secondary_coordinates(10,'/jointset/pf_r/pf_tz_r');
    comak_ik.set_secondary_coupled_coordinate('/jointset/knee_r/knee_flex_r');
    comak_ik.set_secondary_constraint_sim_settle_threshold(1e-4);
    comak_ik.set_secondary_constraint_sim_sweep_time(3.0);
    comak_ik.set_secondary_coupled_coordinate_start_value(0);
    comak_ik.set_secondary_coupled_coordinate_stop_value(100);
    comak_ik.set_secondary_constraint_sim_integrator_accuracy(1e-2);
    comak_ik.set_secondary_constraint_sim_internal_step_limit(10000);
    comak_ik.set_secondary_constraint_function_file(...
        [ik_result_dir '/secondary_coordinate_constraint_functions.xml']);
    comak_ik.set_constraint_function_num_interpolation_points(20);
    comak_ik.set_print_secondary_constraint_sim_results(true);
    comak_ik.set_constrained_model_file([ik_result_dir '/ik_constrained_model.osim']);
    comak_ik.set_perform_inverse_kinematics(true);
    comak_ik.set_marker_file(motion_file);
    
    comak_ik.set_output_motion_file([results_basename '_ik.mot']);
    comak_ik.set_time_range(0, time_start);
    comak_ik.set_time_range(1, time_stop);
    comak_ik.set_report_errors(true);
    comak_ik.set_report_marker_locations(false);
    comak_ik.set_ik_constraint_weight(100);
    comak_ik.set_ik_accuracy(1e-5);
    comak_ik.set_use_visualizer(false);
    comak_ik.set_verbose(10);
    
    
    ik_task_set = IKTaskSet();
    
    ik_task=IKMarkerTask();
    
    
    ik_task.setName('r.should');
    ik_task.setWeight(1);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.should');
    ik_task.setWeight(1);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('c7');
    ik_task.setWeight(1);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.asis');
    ik_task.setWeight(15);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.asis');
    ik_task.setWeight(15);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('sacrum');
    ik_task.setWeight(15);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.bar1');
    ik_task.setWeight(5);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.knee1');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.bar2');
    ik_task.setWeight(5);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.mall');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.heel');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('r.met');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.bar1');
    ik_task.setWeight(5);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.knee1');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.bar2');
    ik_task.setWeight(5);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.mall');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.heel');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    ik_task.setName('l.met');
    ik_task.setWeight(20);
    ik_task_set.cloneAndAppend(ik_task);
    
    comak_ik.set_IKTaskSet(ik_task_set);
    
    comak_ik.print(['../inputs/' project_id '_' numeric_id '/comak_inverse_kinematics_settings.xml']);
    disp('Running COMAKInverseKinematicsTool...')
    comak_ik.run();

end