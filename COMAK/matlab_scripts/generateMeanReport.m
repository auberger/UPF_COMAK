function generateMeanReport(MeanReportPath, display_names, patientLinks)
    % Generate an individual report for a patient
    fid = fopen(MeanReportPath, 'w');
    if fid == -1
        error('Could not open file for writing.');
    end

    % Get directory information
    resultsDir = '../results';
    info = dir(fullfile(resultsDir));

    % Extract the creation date and time
    creationDate = info.datenum;  
    creationDate = datetime(creationDate, 'ConvertFrom', 'datenum');  
    formattedDateTime = datestr(creationDate, 'yyyy-mm-dd HH:MM:SS');  
    
    % Define directories
    results_directory = '../results';
    
    % Get all subdirectories in the results directory, excluding specified ones
    subdirs = dir(results_directory);
    subdirs = subdirs([subdirs.isdir]);
    exclude_dirs = {'.', '..', 'reports'};
    subdirs = subdirs(~ismember({subdirs.name}, exclude_dirs));
    n_patients = length(subdirs);

    % Write HTML content
    fprintf(fid, '<html>\n<head>\n<title>COMAK Mean Simulation Results</title>\n');
    fprintf(fid, '<style>\n');
    fprintf(fid, 'body { font-family: Arial, sans-serif; margin: 0; background-color: #e0e0e0; }\n');  % Darker light gray background for body
    fprintf(fid, 'nav { background-color: #333; position: fixed; top: 0; width: 100%%; }\n');
    fprintf(fid, 'nav a { color: white; text-decoration: none; display: inline-block; padding: 10px; }\n');
    fprintf(fid, 'nav a:hover { background-color: #ddd; color: black; }\n');
    fprintf(fid, 'nav a.main-page { background-color: #fff; color: #8B0000; }\n');  % Style for Main Page link
    fprintf(fid, 'nav select { margin-left: 10px; padding: 5px; }\n');
    fprintf(fid, 'section { padding: 20px 20px 20px 40px; margin: 30px 0; border-radius: 8px; background-color: white; }\n');  % White sections with left padding of 40px
    fprintf(fid, 'p, h1, h2, h3, h4, h5, h6 { margin-left: 0; }\n');  % Reset margin-left for text elements
    fprintf(fid, '.gif-container { display: flex; justify-content: space-around; }\n');  % Flexbox for horizontal alignment
    fprintf(fid, '</style>\n');
    fprintf(fid, '<script>\n');
    fprintf(fid, 'function goToPatientReport() {\n');
    fprintf(fid, '  var select = document.getElementById("patientSelect");\n');
    fprintf(fid, '  var selectedValue = select.options[select.selectedIndex].value;\n');
    fprintf(fid, '  if (selectedValue) {\n');
    fprintf(fid, '    window.location.href = selectedValue;\n');
    fprintf(fid, '  }\n');
    fprintf(fid, '}\n');
    fprintf(fid, 'function resetGIFs() {\n');
    fprintf(fid, '  var gifs = document.getElementsByClassName("sync-gif");\n');
    fprintf(fid, '  var timestamp = new Date().getTime();\n');
    fprintf(fid, '  for (var i = 0; i < gifs.length; i++) {\n');
    fprintf(fid, '    gifs[i].src = gifs[i].src.split("?")[0] + "?" + timestamp;\n');
    fprintf(fid, '  }\n');
    fprintf(fid, '}\n');
    fprintf(fid, 'function updatePlot(selectId, imgId, basePath) {\n');
    fprintf(fid, '  var select = document.getElementById(selectId);\n');
    fprintf(fid, '  var img = document.getElementById(imgId);\n');
    fprintf(fid, '  img.src = basePath + select.value + ".png";\n');
    fprintf(fid, '}\n');
    fprintf(fid, 'window.onload = function() {\n');
    fprintf(fid, '  resetGIFs();\n');
    fprintf(fid, '  setInterval(resetGIFs, 4000); // Reset every 4 seconds (duration of GIFs)\n');
    fprintf(fid, '};\n');
    fprintf(fid, '</script>\n');
    fprintf(fid, '</head>\n<body>\n');
    
    % Navigation Bar
    fprintf(fid, '<nav>\n');
    fprintf(fid, '  <a href="COMAK_Simulation_Results.html" class="main-page">Main Page</a>\n');  % Add class "main-page"
    fprintf(fid, '  <a href="#Contact_Pressure_and_Area_Plot">Joint Contact Pressure and Contact Area</a>\n');
    fprintf(fid, '  <a href="#Extended_Joint_Mechanics_Analysis">Extended Joint Mechanics Analysis</a>\n');
    fprintf(fid, '  <a href="#Kinematics">Kinematics</a>\n');
    fprintf(fid, '  <a href="#Muscle_Activations">Muscle Activations and Reserve Actuators</a>\n');
    fprintf(fid, '  <a href="#Validation_Muscle_Activations_EMG">Validation of Muscle Activations with EMG</a>\n');
    fprintf(fid, '  <select id="patientSelect" onchange="goToPatientReport()">\n');
    fprintf(fid, '    <option value="">Select Patient</option>\n');
    fprintf(fid, '%s\n', patientLinks);
    fprintf(fid, '  </select>\n');
    fprintf(fid, '</nav>\n');


    % Title Page for Patient Report
    fprintf(fid, '<div style="text-align:center; padding-top: 70px; padding-bottom: 20px; background-color: #8B0000; color: white; border-bottom: 2px solid #ccc;">\n');
    fprintf(fid, '<h1 style="margin: 0; font-size: 2.5em;">COMAK Mean Simulation Results (n = %s)</h1>\n', num2str(n_patients));
    fprintf(fid, '<p style="font-size: 1.2em;">Report generated on: %s</p>\n', formattedDateTime);
    fprintf(fid, '</div>\n');

    % Joint Contact Pressure Section
    fprintf(fid, '<section id="Contact_Pressure_and_Area_Plot">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Joint Contact Pressure</h2>\n');

    % Contact Area and Pressure Plot Section
    fprintf(fid, '<p>The following plots show the contact area and pressure over the gait cycle (mean and 95 percent confidence interval):</p>\n');  % Text with left margin
    
    % Plot without left margin
    fprintf(fid, '<div style="text-align:center; margin-top: 20px;">\n');
    fprintf(fid, '<img src="../mean_results/joint_mechanics/combined_joint_mechanics_plot.png" alt="Coordinate System" style="max-width:100%%; height:auto;">\n');
    fprintf(fid, '</div>\n');
    fprintf(fid, '</section>\n');

    %% Extended Joint Mechanics Analysis Section
    fprintf(fid, '<section id="Extended_Joint_Mechanics_Analysis">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Extended Joint Mechanics Analysis</h2>\n');
    fprintf(fid, '<p>Select the metric and dimension to view the corresponding plot:</p>\n');

    % Dropdown for metric selection
    fprintf(fid, '<div style="margin-left: 40px; margin-bottom: 20px;">\n');  % Adjusted margins
    fprintf(fid, '<label for="metricSelect">Metric: </label>\n');
    fprintf(fid, '<select id="metricSelect" onchange="updateJointMechanicsPlot();" style="margin-right: 20px;">\n');
    metrics = {'Center_of_Pressure', 'Contact_Force', 'Reaction_Moment'};
    for i = 1:length(metrics)
        fprintf(fid, '<option value="%s">%s</option>\n', metrics{i}, metrics{i});
    end
    fprintf(fid, '</select>\n');

    % Dropdown for dimension selection
    fprintf(fid, '<label for="dimensionSelect">Dimension: </label>\n');
    fprintf(fid, '<select id="dimensionSelect" onchange="updateJointMechanicsPlot();">\n');
    dimensions = {'Anterior-Posterior', 'Medial-Lateral', 'Superior-Inferior'};
    for i = 1:length(dimensions)
        fprintf(fid, '<option value="%s">%s</option>\n', dimensions{i}, dimensions{i});
    end
    fprintf(fid, '</select>\n');

    % Flexbox container for image and plot
    fprintf(fid, '<div style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">\n');

    % Model and Coordinate System Image
    fprintf(fid, '<div style="margin-right: -800px;">\n');  % Moderate margin
    fprintf(fid, '<img src="../data/images_for_visualizations/Coordinate_system.png" alt="Coordinate System" style="width: 35%%;">\n');
    fprintf(fid, '</div>\n');

    % Plot container
    fprintf(fid, '<div style="text-align:center;">\n');
    fprintf(fid, '<img id="jointMechanicsPlot" src="../mean_results/joint_mechanics/Center_of_Pressure_Anterior-Posterior_plot.png" alt="Joint Mechanics Plot" style="width: 1240px; height:auto;">\n');
    fprintf(fid, '</div>\n');

    fprintf(fid, '</div>\n'); % Close the flexbox container
    fprintf(fid, '</section>\n');

    % Add the JavaScript function to handle the dropdown change and update the plot
    fprintf(fid, '<script>\n');
    fprintf(fid, 'function updateJointMechanicsPlot() {\n');
    fprintf(fid, '  var metric = document.getElementById("metricSelect").value;\n');
    fprintf(fid, '  var dimension = document.getElementById("dimensionSelect").value;\n');
    fprintf(fid, '  var img = document.getElementById("jointMechanicsPlot");\n');
    fprintf(fid, '  img.src = "../mean_results/joint_mechanics/" + metric + "_" + dimension + "_plot.png";\n');
    fprintf(fid, '}\n');
    fprintf(fid, '</script>\n');

    %% Kinematics Section
    fprintf(fid, '<section id="Kinematics">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Kinematics</h2>\n');
    fprintf(fid, '<p>Select the joint and degree of freedom to view the corresponding kinematics plot (mean and 95 percent confidence interval):</p>\n');
    
    % Dropdown for joint selection
    fprintf(fid, '<div style="margin-left: 40px; margin-bottom: 20px;">\n');  % Adjusted margins
    fprintf(fid, '<label for="jointSelect">Joint:</label>\n');
    fprintf(fid, '<select id="jointSelect" onchange="updateKinematicsPlot();" style="margin-right: 20px;">\n');
    joints = {'tibiofemoral', 'patellofemoral'};
    for i = 1:length(joints)
        fprintf(fid, '<option value="%s">%s</option>\n', joints{i}, joints{i});
    end
    fprintf(fid, '</select>\n');
    
    % Dropdown for degree of freedom selection
    fprintf(fid, '<label for="dofSelect">Degree of Freedom:</label>\n');
    fprintf(fid, '<select id="dofSelect" onchange="updateKinematicsPlot();">\n');
    dofs = {'rotations', 'translations'};
    for i = 1:length(dofs)
        fprintf(fid, '<option value="%s">%s</option>\n', dofs{i}, dofs{i});
    end
    fprintf(fid, '</select>\n');
    
    % Plot container
    fprintf(fid, '<div style="text-align:center; margin-top: 20px;">\n');
    fprintf(fid, '<img id="kinematicsPlot" src="../mean_results/kinematics/tibiofemoral_rotations.png" alt="Kinematics Plot" style="max-width:100%%; height:auto;">\n');
    fprintf(fid, '</div>\n');
    fprintf(fid, '</section>\n');

    % Add the JavaScript function to handle the dropdown change and update the kinematics plot
    fprintf(fid, '<script>\n');
    fprintf(fid, 'function updateKinematicsPlot() {\n');
    fprintf(fid, '  var joint = document.getElementById("jointSelect").value;\n');
    fprintf(fid, '  var dof = document.getElementById("dofSelect").value;\n');
    fprintf(fid, '  var img = document.getElementById("kinematicsPlot");\n');
    fprintf(fid, '  img.src = "../mean_results/kinematics/" + joint + "_" + dof + ".png";\n');
    fprintf(fid, '}\n');
    fprintf(fid, '</script>\n');

    %% Validation of Primary Tibiofemoral Kinematics Section
    fprintf(fid, '<section id="Validation_Tibiofemoral_Kinematics">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Validation of Primary Tibiofemoral Kinematics</h2>\n');
    fprintf(fid, '<p>This plot shows the primary tibiofemoral kinematics along with motion capture data for validation (mean and 95 percent confidence interval):</p>\n');
    fprintf(fid, '<div style="text-align:center; margin-top: 20px;">\n');
    fprintf(fid, '<img src="../mean_results/validation/mean_primary_coordinates_vs_mocap_1.png" alt="Validation Plot" style="max-width:100%%; height:auto;">\n');
    fprintf(fid, '<img src="../mean_results/validation/mean_primary_coordinates_vs_mocap_2.png" alt="Validation Plot" style="max-width:100%%; height:auto;">\n');
    fprintf(fid, '</div>\n');
    fprintf(fid, '</section>\n');

    %% Muscle Activations and Reserve Actuators Section
    
    % Start of flexbox container for side-by-side plots
    fprintf(fid, '<div class="plot-container" style="display: flex; justify-content: space-between;">\n');
    
    % Muscle Activations
    fprintf(fid, '<div style="flex: 1; margin-right: 20px;">\n');  % Added flex: 1 and margin-right for spacing
    fprintf(fid, '<section id="Muscle_Activations">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 15px;">Muscle Activations</h2>\n');
    
    fprintf(fid, '<div style="margin-left: 40px; margin-bottom: 20px;">\n');  % Adjusted margins
    fprintf(fid, '<label for="muscleSelect">Select a muscle to view its activation plot: </label>\n');
    fprintf(fid, '<select id="muscleSelect" onchange="updatePlot(''muscleSelect'', ''musclePlot'', ''../mean_results/muscle_activations/'');">\n');
    
    muscles = {'addbrev_r', 'addlong_r', 'addmagProx_r', 'addmagMid_r', 'addmagDist_r', 'addmagIsch_r', ...
        'bflh_r', 'bfsh_r', 'edl_r', 'ehl_r', 'fdl_r', 'fhl_r', 'gaslat_r', 'gasmed_r', 'gem_r', ...
        'glmax1_r', 'glmax2_r', 'glmax3_r', 'glmed1_r', 'glmed2_r', 'glmed3_r', 'glmin1_r', 'glmin2_r', ...
        'glmin3_r', 'grac_r', 'iliacus_r', 'pect_r', 'perbrev_r', 'perlong_r', 'pertert_r', 'piri_r', ...
        'psoas_r', 'quadfem_r', 'recfem_r', 'sart_r', 'semimem_r', 'semiten_r', 'soleus_r', 'tfl_r', ...
        'tibant_r', 'tibpost_r', 'vasint_r', 'vaslat_r', 'vasmed_r'};
    
    % Add muscle options to the dropdown menu
    for i = 1:length(muscles)
        fprintf(fid, '<option value="%s">%s</option>\n', muscles{i}, display_names(muscles{i}));
    end
    
    fprintf(fid, '</select>\n');
    fprintf(fid, '</div>\n');  % Close the dropdown div
    
    fprintf(fid, '<div style="text-align:center;">\n');
    fprintf(fid, '<img id="musclePlot" src="../mean_results/muscle_activations/%s.png" alt="Muscle Activation Plot" style="max-width:100%%; height:auto;">\n', muscles{1});
    fprintf(fid, '</div>\n');
    
    % Close Muscle Activations section
    fprintf(fid, '</section>\n'); 
    fprintf(fid, '</div>\n');  % Close the Muscle Activations div
    
    % Reserve Actuators
    fprintf(fid, '<div style="flex: 1; margin-left: 20px;">\n');  % Added flex: 1 and margin-left for spacing
    fprintf(fid, '<section id="Reserve_Actuators">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 15px;">Reserve Actuators</h2>\n');
    
    fprintf(fid, '<div style="margin-left: 40px; margin-bottom: 20px;">\n');  % Adjusted margins
    fprintf(fid, '<label for="reserveSelect">Select a reserve actuator to view its plot: </label>\n');
    fprintf(fid, '<select id="reserveSelect" onchange="updatePlot(''reserveSelect'', ''reservePlot'', ''../mean_results/reserve_actuators/'');">\n');
    
    actuators = {'hip_flex_r_reserve', 'hip_add_r_reserve', 'hip_rot_r_reserve', 'pf_flex_r_reserve', ...
        'pf_rot_r_reserve', 'pf_tilt_r_reserve', 'pf_tx_r_reserve', 'pf_ty_r_reserve', 'pf_tz_r_reserve', ...
        'knee_flex_r_reserve', 'knee_add_r_reserve', 'knee_rot_r_reserve', 'knee_tx_r_reserve', ...
        'knee_ty_r_reserve', 'knee_tz_r_reserve', 'ankle_flex_r_reserve'};
    
    % Add reserve actuator options to the dropdown menu
    for i = 1:length(actuators)
        fprintf(fid, '<option value="%s">%s</option>\n', actuators{i}, display_names(actuators{i}));
    end
    
    fprintf(fid, '</select>\n');
    fprintf(fid, '</div>\n');  % Close the dropdown div
    
    fprintf(fid, '<div style="text-align:center;">\n');
    fprintf(fid, '<img id="reservePlot" src="../mean_results/reserve_actuators/%s.png" alt="Reserve Actuator Plot" style="max-width:100%%; height:auto;">\n', actuators{1});
    fprintf(fid, '</div>\n');
    
    % Close Reserve Actuators section
    fprintf(fid, '</section>\n'); 
    fprintf(fid, '</div>\n');  % Close the Reserve Actuators div
    
    % Close the plot container
    fprintf(fid, '</div>\n');


    %% Validation of Muscle Activations with EMG Data Section
    fprintf(fid, '<section id="Validation_Muscle_Activations_EMG">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Validation of Muscle Activations with EMG Data</h2>\n');

    fprintf(fid, '<p>Qualitative comparison assessing similarity in trends between mean simulated activations and mean EMG signals using Cross-Correlation to measure timing and shape similarity.</p>\n');
    fprintf(fid, '<p><strong>Lag in cross-correlation:</strong> Represents the time shift where the highest correlation occurs between simulated activation and EMG signals. Positive lag indicates simulated activation leads EMG; negative lag indicates a lag in simulation relative to EMG.</p>\n');
    fprintf(fid, '<p>Interpret cross-correlation with guidance from biomechanical validation studies such as <a href="https://www.sciencedirect.com/science/article/pii/S0021929005004124?via=ihub" target="_blank">Wren et al., 2006</a>.</p>\n');
    
    fprintf(fid, '<div style="text-align:center; margin-top: 20px;">\n');
    fprintf(fid, '<img src="../mean_results/validation/Population_Level_Activation_vs_EMG.png" alt="Muscle Activations vs EMG Plot" style="max-width:100%%; height:auto;">\n');
    fprintf(fid, '</div>\n');
    
    fprintf(fid, '</section>\n');

    % Close the file
    fclose(fid);
end
