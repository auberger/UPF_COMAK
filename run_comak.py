import org.opensim.modeling as osim

def run_comak(model_file, ext_load_file, comak_result_dir, numeric_id, project_id, results_basename, time_start=-1, time_stop=-1, contact_energy_weight=100, custom_muscle_weights=False, comak_muscle_weight_result_dir=None, compare_contact_energy_weight=False, comak_contact_energy_result_dir=None):
    """
    Perform COMAK simulation

    Parameters:
        model_file: string, path to the model file
        ext_load_file: string, path to the external loads file
        comak_result_dir: string, directory to save the COMAK results
        numeric_id: string, numerical identifier for results directories
        project_id: string, project identifier
        results_basename: string, base name for the results files
        time_start: double, start time of the simulation
        time_stop: double, stop time of the simulation
        contact_energy_weight: double, weight for the contact energy in the simulation
        custom_muscle_weights: boolean, flag to use custom muscle weights
        comak_muscle_weight_result_dir: string, directory to save results with custom muscle weights
        compare_contact_energy_weight: double or boolean, contact energy weight for comparison (false if not comparing)
        comak_contact_energy_result_dir: string, directory to save comparison results
    """
    osim.Logger.setLevelString('Debug')

    comak = osim.COMAKTool()
    comak.set_model_file(model_file)
    comak.set_coordinates_file(f'../results/{project_id}_{numeric_id}/comak_inverse_kinematics/{results_basename}_ik.mot')
    comak.set_external_loads_file(ext_load_file)
    comak.set_results_directory(comak_result_dir)
    comak.set_results_prefix(results_basename)
    comak.set_replace_force_set(False)
    comak.set_force_set_file('../data/lenhart2015_reserve_actuators.xml')
    comak.set_start_time(time_start)
    comak.set_stop_time(time_stop)
    comak.set_time_step(0.01)
    comak.set_lowpass_filter_frequency(6)
    comak.set_print_processed_input_kinematics(False)
    comak.set_prescribed_coordinates(0, '/jointset/gnd_pelvis/pelvis_tx')
    comak.set_prescribed_coordinates(1, '/jointset/gnd_pelvis/pelvis_ty')
    comak.set_prescribed_coordinates(2, '/jointset/gnd_pelvis/pelvis_tz')
    comak.set_prescribed_coordinates(3, '/jointset/gnd_pelvis/pelvis_tilt')
    comak.set_prescribed_coordinates(4, '/jointset/gnd_pelvis/pelvis_list')
    comak.set_prescribed_coordinates(5, '/jointset/gnd_pelvis/pelvis_rot')
    comak.set_prescribed_coordinates(6, '/jointset/subtalar_r/subt_angle_r')
    comak.set_prescribed_coordinates(7, '/jointset/mtp_r/mtp_angle_r')
    comak.set_prescribed_coordinates(8, '/jointset/hip_l/hip_flex_l')
    comak.set_prescribed_coordinates(9, '/jointset/hip_l/hip_add_l')
    comak.set_prescribed_coordinates(10, '/jointset/hip_l/hip_rot_l')
    comak.set_prescribed_coordinates(11, '/jointset/pf_l/pf_l_r3')
    comak.set_prescribed_coordinates(12, '/jointset/pf_l/pf_l_tx')
    comak.set_prescribed_coordinates(13, '/jointset/pf_l/pf_l_ty')
    comak.set_prescribed_coordinates(14, '/jointset/knee_l/knee_flex_l')
    comak.set_prescribed_coordinates(15, '/jointset/ankle_l/ankle_flex_l')
    comak.set_prescribed_coordinates(16, '/jointset/subtalar_l/subt_angle_l')
    comak.set_prescribed_coordinates(17, '/jointset/mtp_l/mtp_angle_l')
    comak.set_prescribed_coordinates(18, '/jointset/pelvis_torso/lumbar_ext')
    comak.set_prescribed_coordinates(19, '/jointset/pelvis_torso/lumbar_latbend')
    comak.set_prescribed_coordinates(20, '/jointset/pelvis_torso/lumbar_rot')
    comak.set_prescribed_coordinates(21, '/jointset/torso_neckhead/neck_ext')
    comak.set_prescribed_coordinates(22, '/jointset/torso_neckhead/neck_latbend')
    comak.set_prescribed_coordinates(23, '/jointset/torso_neckhead/neck_rot')
    comak.set_prescribed_coordinates(24, '/jointset/acromial_r/arm_add_r')
    comak.set_prescribed_coordinates(25, '/jointset/acromial_r/arm_flex_r')
    comak.set_prescribed_coordinates(26, '/jointset/acromial_r/arm_rot_r')
    comak.set_prescribed_coordinates(27, '/jointset/elbow_r/elbow_flex_r')
    comak.set_prescribed_coordinates(28, '/jointset/radioulnar_r/pro_sup_r')
    comak.set_prescribed_coordinates(29, '/jointset/radius_hand_r/wrist_flex_r')
    comak.set_prescribed_coordinates(30, '/jointset/acromial_l/arm_add_l')
    comak.set_prescribed_coordinates(31, '/jointset/acromial_l/arm_flex_l')
    comak.set_prescribed_coordinates(32, '/jointset/acromial_l/arm_rot_l')
    comak.set_prescribed_coordinates(33, '/jointset/elbow_l/elbow_flex_l')
    comak.set_prescribed_coordinates(34, '/jointset/radioulnar_l/pro_sup_l')
    comak.set_prescribed_coordinates(35, '/jointset/radius_hand_l/wrist_flex_l')
    
    comak.set_primary_coordinates(0, '/jointset/hip_r/hip_flex_r')
    comak.set_primary_coordinates(1, '/jointset/hip_r/hip_add_r')
    comak.set_primary_coordinates(2, '/jointset/hip_r/hip_rot_r')
    comak.set_primary_coordinates(3, '/jointset/knee_r/knee_flex_r')
    comak.set_primary_coordinates(4, '/jointset/ankle_r/ankle_flex_r')
    
    secondary_coord_set = osim.COMAKSecondaryCoordinateSet()
    
    secondary_coords = [
        ('knee_add_r', 0.01, '/jointset/knee_r/knee_add_r'),
        ('knee_rot_r', 0.01, '/jointset/knee_r/knee_rot_r'),
        ('knee_tx_r', 0.05, '/jointset/knee_r/knee_tx_r'),
        ('knee_ty_r', 0.05, '/jointset/knee_r/knee_ty_r'),
        ('knee_tz_r', 0.05, '/jointset/knee_r/knee_tz_r'),
        ('pf_flex_r', 0.01, '/jointset/pf_r/pf_flex_r'),
        ('pf_rot_r', 0.01, '/jointset/pf_r/pf_rot_r'),
        ('pf_tilt_r', 0.01, '/jointset/pf_r/pf_tilt_r'),
        ('pf_tx_r', 0.005, '/jointset/pf_r/pf_tx_r'),
        ('pf_ty_r', 0.005, '/jointset/pf_r/pf_ty_r'),
        ('pf_tz_r', 0.005, '/jointset/pf_r/pf_tz_r')
    ]
    
    for name, max_change, coord in secondary_coords:
        secondary_coord = osim.COMAKSecondaryCoordinate()
        secondary_coord.setName(name)
        secondary_coord.set_max_change(max_change)
        secondary_coord.set_coordinate(coord)
        secondary_coord_set.cloneAndAppend(secondary_coord)
    
    comak.set_COMAKSecondaryCoordinateSet(secondary_coord_set)
    
    comak.set_settle_secondary_coordinates_at_start(True)
    comak.set_settle_threshold(1e-3)
    comak.set_settle_accuracy(1e-2)
    comak.set_settle_internal_step_limit(10000)
    comak.set_print_settle_sim_results(True)
    comak.set_settle_sim_results_directory(comak_result_dir)
    comak.set_settle_sim_results_prefix('walking_settle_sim')
    comak.set_max_iterations(25)
    comak.set_udot_tolerance(1)
    comak.set_udot_worse_case_tolerance(50)
    comak.set_unit_udot_epsilon(1e-6)
    comak.set_optimization_scale_delta_coord(1)
    comak.set_ipopt_diagnostics_level(3)
    comak.set_ipopt_max_iterations(500)
    comak.set_ipopt_convergence_tolerance(1e-4)
    comak.set_ipopt_constraint_tolerance(1e-4)
    comak.set_ipopt_limited_memory_history(200)
    comak.set_ipopt_nlp_scaling_max_gradient(10000)
    comak.set_ipopt_nlp_scaling_min_value(1e-8)
    comak.set_ipopt_obj_scaling_factor(1)
    comak.set_activation_exponent(2)
    comak.set_contact_energy_weight(contact_energy_weight)
    comak.set_non_muscle_actuator_weight(1000)
    comak.set_model_assembly_accuracy(1e-12)
    comak.set_use_visualizer(False)
    comak.set_verbose(2)

    if custom_muscle_weights:
        # Perform COMAK simulation with muscle weights
        comak_muscle_weight = comak.clone()
        comak_muscle_weight.set_results_directory(comak_muscle_weight_result_dir)
        comak_muscle_weight.set_results_prefix(f'{results_basename}_muscle_weight')
        comak_muscle_weight.set_contact_energy_weight(contact_energy_weight)

        cost_fun_param_set = osim.COMAKCostFunctionParameterSet()
        
        cost_fun_params = [
            ('gasmed_r', '/forceset/gasmed_r', 4),
            ('gaslat_r', '/forceset/gaslat_r', 7),
            ('soleus_r', '/forceset/soleus_r', 0.9),
            ('recfem_r', '/forceset/recfem_r', 3),
            ('glmed1_r', '/forceset/glmed1_r', 0.9),
            ('glmed2_r', '/forceset/glmed2_r', 0.9),
            ('glmed3_r', '/forceset/glmed3_r', 0.9),
            ('glmin1_r', '/forceset/glmin1_r', 0.9),
            ('glmin2_r', '/forceset/glmin2_r', 0.9),
            ('glmin3_r', '/forceset/glmin3_r', 0.9),
            ('bflh_r', '/forceset/bflh_r', 2),
            ('bfsh_r', '/forceset/bfsh_r', 2),
            ('semiten_r', '/forceset/semiten_r', 2),
            ('semimem_r', '/forceset/semimem_r', 2)
        ]

        for name, actuator, weight in cost_fun_params:
            cost_fun_param = osim.COMAKCostFunctionParameter()
            cost_fun_param.setName(name)
            cost_fun_param.set_actuator(actuator)
            cost_fun_param.set_weight(osim.Constant(weight))
            cost_fun_param_set.cloneAndAppend(cost_fun_param)
        
        comak_muscle_weight.set_COMAKCostFunctionParameterSet(cost_fun_param_set)
        comak_muscle_weight.print(f'../inputs/{project_id}_{numeric_id}/comak_muscle_weights_settings.xml')
        
        print(f'Running COMAK Tool with custom muscle weights and contact energy weight = {contact_energy_weight} ...')
        comak_muscle_weight.run()

        if compare_contact_energy_weight:
            # Perform COMAK simulation with other contact energy weight
            comak_contact_energy = comak_muscle_weight.clone()
            comak_contact_energy.set_results_directory(comak_contact_energy_result_dir)
            comak_contact_energy.set_results_prefix(f'{results_basename}_compare_contact_energy_{compare_contact_energy_weight}')
            
            comak_contact_energy.set_contact_energy_weight(compare_contact_energy_weight)
            
            comak_contact_energy.print(f'../inputs/{project_id}_{numeric_id}/comak_contact_energy_{compare_contact_energy_weight}_settings.xml')
            
            print(f'Running COMAK Tool again with contact energy weight = {compare_contact_energy_weight}...')
            comak_contact_energy.run()
    else:
        comak.print(f'../inputs/{project_id}_{numeric_id}/comak_settings.xml')
        print(f'Running COMAK Tool with default muscle weights and contact energy weight = {contact_energy_weight} ...')
        comak.run()

        if compare_contact_energy_weight:
            # Perform COMAK simulation with other contact energy weight
            comak_contact_energy = comak.clone()
            comak_contact_energy.set_results_directory(comak_contact_energy_result_dir)
            comak_contact_energy.set_results_prefix(f'{results_basename}_compare_contact_energy_{compare_contact_energy_weight}')
            
            comak_contact_energy.set_contact_energy_weight(compare_contact_energy_weight)
            
            comak_contact_energy.print(f'../inputs/{project_id}_{numeric_id}/comak_contact_energy_{compare_contact_energy_weight}_settings.xml')
            
            print(f'Running COMAK Tool again with contact energy weight = {contact_energy_weight} ...')
            comak_contact_energy.run()
