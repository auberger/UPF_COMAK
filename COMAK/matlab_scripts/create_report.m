function create_report()
    % CREATE_REPORT Generates an updated simulation report including all
    % analyzed patients and mean simulation results
    
    
    % Output directory for the report
    resultsDir = '../results';
    outputDir = '../reports';
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Define file path for the main report
    reportFilePath = fullfile(outputDir, 'COMAK_Simulation_Results.html');
    
    % Display names mapping for muscle and reserve actuator plots
    display_names = containers.Map(...
        {'addbrev_r', 'addlong_r', 'addmagProx_r', 'addmagMid_r', 'addmagDist_r', 'addmagIsch_r', ...
        'bflh_r', 'bfsh_r', 'edl_r', 'ehl_r', 'fdl_r', 'fhl_r', 'gaslat_r', 'gasmed_r', 'gem_r', ...
        'glmax1_r', 'glmax2_r', 'glmax3_r', 'glmed1_r', 'glmed2_r', 'glmed3_r', 'glmin1_r', 'glmin2_r', ...
        'glmin3_r', 'grac_r', 'iliacus_r', 'pect_r', 'perbrev_r', 'perlong_r', 'pertert_r', 'piri_r', ...
        'psoas_r', 'quadfem_r', 'recfem_r', 'sart_r', 'semimem_r', 'semiten_r', 'soleus_r', 'tfl_r', ...
        'tibant_r', 'tibpost_r', 'vasint_r', 'vaslat_r', 'vasmed_r', 'hip_flex_r_reserve', 'hip_add_r_reserve', ...
        'hip_rot_r_reserve', 'pf_flex_r_reserve', 'pf_rot_r_reserve', 'pf_tilt_r_reserve', 'pf_tx_r_reserve', ...
        'pf_ty_r_reserve', 'pf_tz_r_reserve', 'knee_flex_r_reserve', 'knee_add_r_reserve', 'knee_rot_r_reserve', ...
        'knee_tx_r_reserve', 'knee_ty_r_reserve', 'knee_tz_r_reserve', 'ankle_flex_r_reserve'}, ...
        {'Adductor Brevis', 'Adductor Longus', 'Adductor Magnus Proximal', 'Adductor Magnus Middle', ...
        'Adductor Magnus Distal', 'Adductor Magnus Ischial', 'Biceps Femoris Long Head', 'Biceps Femoris Short Head', ...
        'Extensor Digitorum Longus', 'Extensor Hallucis Longus', 'Flexor Digitorum Longus', 'Flexor Hallucis Longus', ...
        'Gastrocnemius Lateral', 'Gastrocnemius Medial', 'Gemellus', 'Gluteus Maximus 1', 'Gluteus Maximus 2', ...
        'Gluteus Maximus 3', 'Gluteus Medius 1', 'Gluteus Medius 2', 'Gluteus Medius 3', 'Gluteus Minimus 1', ...
        'Gluteus Minimus 2', 'Gluteus Minimus 3', 'Gracilis', 'Iliacus', 'Pectineus', 'Peroneus Brevis', ...
        'Peroneus Longus', 'Peroneus Tertius', 'Piriformis', 'Psoas', 'Quadratus Femoris', 'Rectus Femoris', ...
        'Sartorius', 'Semimembranosus', 'Semitendinosus', 'Soleus', 'Tensor Fasciae Latae', 'Tibialis Anterior', ...
        'Tibialis Posterior', 'Vastus Intermedius', 'Vastus Lateralis', 'Vastus Medialis', ...
        'Hip Flexor Reserve Actuator', 'Hip Adductor Reserve Actuator', 'Hip Rotator Reserve Actuator', ...
        'Patellofemoral Flexor Reserve Actuator', 'Patellofemoral Rotator Reserve Actuator', ...
        'Patellofemoral Tilt Reserve Actuator', 'Patellofemoral Translation X Reserve Actuator', ...
        'Patellofemoral Translation Y Reserve Actuator', 'Patellofemoral Translation Z Reserve Actuator', ...
        'Knee Flexor Reserve Actuator', 'Knee Adductor Reserve Actuator', 'Knee Rotator Reserve Actuator', ...
        'Knee Translation X Reserve Actuator', 'Knee Translation Y Reserve Actuator', ...
        'Knee Translation Z Reserve Actuator', 'Ankle Flexor Reserve Actuator'});
    
    % Find all patient directories
    patientDirs = dir(resultsDir);
    patientDirs = patientDirs([patientDirs.isdir]);
    patientDirs = patientDirs(~ismember({patientDirs.name}, {'.', '..', 'reports'}));
    
    % Check if there are patient directories
    if isempty(patientDirs)
        error('No patient directories found in the specified results directory.');
    end
    
    % Create individual patient report links
    patientLinks = '';
    for i = 1:length(patientDirs)
        patientID = patientDirs(i).name;
        patientReportPath = fullfile(outputDir, [patientID '_results.html']);
        patientLinks = [patientLinks, sprintf('<option value="%s">%s</option>\n', [patientID '_results.html'], patientID)];
        generatePatientReport(patientID, patientReportPath, display_names, patientLinks);
    end

    for i = 1:length(patientDirs)
        patientID = patientDirs(i).name;
        patientReportPath = fullfile(outputDir, [patientID '_results.html']);
        generatePatientReport(patientID, patientReportPath, display_names, patientLinks);
    end

    % Create mean report
    meanReportPath = fullfile(outputDir, 'mean_results.html');
    generateMeanReport(meanReportPath, display_names, patientLinks);
    
    % Open the HTML file for writing the main report
    fid = fopen(reportFilePath, 'w');
    if fid == -1
        error('Could not open file for writing.');
    else
        disp(['Writing main report to: ', reportFilePath]);
    end
    
    % Write HTML content
    fprintf(fid, '<html>\n<head>\n<title>What is COMAK?</title>\n');
    fprintf(fid, '<style>\n');
    fprintf(fid, 'body { font-family: Arial, sans-serif; margin: 0; background-color: #e0e0e0; }\n');
    fprintf(fid, 'nav { background-color: #333; position: fixed; top: 0; width: 100%%; }\n');
    fprintf(fid, 'nav a { color: white; text-decoration: none; display: inline-block; padding: 10px; }\n');
    fprintf(fid, 'nav a.mean-result-page { background-color: #fff; color: #8B0000; }\n');  % Style for Main Page link
    
    fprintf(fid, 'nav a:hover { background-color: #ddd; color: black; }\n');
    fprintf(fid, 'nav a.main-page { background-color: #fff; color: #8B0000; }\n');
    fprintf(fid, 'nav select { margin-left: 10px; padding: 5px; }\n');
    fprintf(fid, 'section { padding: 20px 20px 20px 40px; margin: 30px 0; border-radius: 8px; background-color: white; }\n');
    fprintf(fid, 'p, h1, h2, h3, h4, h5, h6 { margin-left: 0; }\n');
    fprintf(fid, '.image-container { text-align: center; margin-top: 20px; }\n');
    fprintf(fid, '</style>\n');
    fprintf(fid, '<script>\n');
    fprintf(fid, 'function goToPatientReport() {\n');
    fprintf(fid, '  var select = document.getElementById("patientSelect");\n');
    fprintf(fid, '  var selectedValue = select.options[select.selectedIndex].value;\n');
    fprintf(fid, '  if (selectedValue) {\n');
    fprintf(fid, '    window.location.href = selectedValue;\n');
    fprintf(fid, '  }\n');
    fprintf(fid, '}\n');
    fprintf(fid, '</script>\n');
    fprintf(fid, '</head>\n<body>\n');
    
    % Navigation Bar
    fprintf(fid, '<nav>\n');
    fprintf(fid, '  <a href="#introduction">Introduction</a>\n');
    fprintf(fid, '  <a href="#components">Components and Models</a>\n');
    fprintf(fid, '  <a href="#workflow">Workflow</a>\n');
    fprintf(fid, '  <a href="#validation">Validation and Applications</a>\n');
    fprintf(fid, '<a href="#How_to_Use_COMAK">How to Use COMAK</a>\n');
    fprintf(fid, '<a href="#Conclusion">Conclusion</a>\n');
    fprintf(fid, '  <a href="mean_results.html" class="mean-result-page">Mean Simulation Results</a>\n');  % Add class "mean-result-page"
    fprintf(fid, '<select id="patientSelect" onchange="goToPatientReport()">\n');
    fprintf(fid, '<option value="">Select Patient</option>\n');
    fprintf(fid, '%s\n', patientLinks);
    fprintf(fid, '</select>\n');
    fprintf(fid, '</nav>\n');
    
    fprintf(fid, 'nav a.main-page { background-color: #fff; color: #8B0000; }\n');  % Style for Main Page link
    
    % Title and Content
    fprintf(fid, '<div style="text-align:center; padding-top: 70px; padding-bottom: 20px; background-color: #8B0000; color: white; border-bottom: 2px solid #ccc;">\n');
    fprintf(fid, '<h1 style="margin: 0; font-size: 2.5em;">What is COMAK?</h1>\n');
    fprintf(fid, '</div>\n');
    
    % Introduction
    imagePath = '../data/images_for_visualizations/COMAK_workflow.png';
    fprintf(fid, '<section id="introduction">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Introduction to COMAK</h2>\n');
    fprintf(fid, '<p>Concurrent Optimization of Muscle Activations and Kinematics (COMAK) is a sophisticated computational approach integrated into the OpenSim-Joint Articular Mechanics (JAM) toolkit. It is designed to enhance the fidelity of musculoskeletal (MSK) simulations by concurrently optimizing muscle activations and joint kinematics. This approach is particularly valuable for studying dynamic joint mechanics, such as those involved in walking, and has applications in understanding and treating knee osteoarthritis (KOA).</p>\n');
    fprintf(fid, '<div class="image-container">\n');
    fprintf(fid, '<img src="%s" alt="COMAK Workflow" style="max-width:100%%; height:auto;">\n', imagePath);
    fprintf(fid, '</div>\n');
    fprintf(fid, '</section>\n');
    
    % Components and Models
    fprintf(fid, '<section id="components">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Components and Models</h2>\n');
    fprintf(fid, '<p>OpenSim JAM incorporates various force component plugins, models, and simulation tools to accurately represent joint mechanics:</p>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><b>Blankevoort1991Ligament:</b> Simulates ligament behavior using a spring-damper model, capturing both the nonlinear and linear response of ligament fibers.</li>\n');
    fprintf(fid, '<li><b>Smith2018ArticularContactForce and Smith2018ContactMesh:</b> Represents articular contact using triangular mesh geometries and an elastic foundation model to calculate contact pressures.</li>\n');
    fprintf(fid, '</ul>\n');
    fprintf(fid, '<p><b>Models:</b></p>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><b>Lenhart2015 Model:</b> This model includes detailed representations of the tibiofemoral and patellofemoral joints as 6-degree-of-freedom (DOF) joints, utilizing the Smith2018ArticularContactForce for cartilage contact and Blankevoort1991Ligaments for ligaments.</li>\n');
    fprintf(fid, '</ul>\n');
    fprintf(fid, '<p><b>Simulation Tools:</b></p>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><b>COMAKInverseKinematics and COMAK:</b> These tools implement the COMAK algorithm to calculate muscle forces and detailed joint mechanics during dynamic movements.</li>\n');
    fprintf(fid, '<li><b>JointMechanicsTool:</b> Enables detailed analysis of joint mechanics simulations, generating files for visualization and further analysis in MATLAB, Python, or HDF View.</li>\n');
    fprintf(fid, '</ul>\n');
    fprintf(fid, '</section>\n');
    
    % Workflow
    fprintf(fid, '<section id="workflow">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">COMAK Workflow</h2>\n');
    fprintf(fid, '<ol>\n');
    fprintf(fid, '<li><b>Knee Model Construction:</b> Develop a personalized knee model based on imaging data, integrated with a comprehensive MSK model that includes bones, muscles, and ligaments.</li>\n');
    fprintf(fid, '<li><b>Data Collection:</b> Gather experimental data through gait analysis, tracking marker trajectories and measuring ground reaction forces.</li>\n');
    fprintf(fid, '<li><b>Inverse Kinematics:</b> Use the collected data to compute primary joint angles and movements using inverse kinematics algorithms.</li>\n');
    fprintf(fid, '<li><b>Prescribed Flexion Forward Simulation:</b> Conduct a forward simulation with prescribed joint flexion to estimate initial secondary kinematic variables.</li>\n');
    fprintf(fid, '<li><b>Initialization Forward Simulation:</b> Refine secondary kinematic variables through an initialization simulation, preparing for the optimization process.</li>\n');
    fprintf(fid, '<li><b>Optimization:</b> Apply the COMAK algorithm to concurrently optimize muscle activations and secondary kinematics. The goal is to minimize the sum of weighted muscle activations squared while ensuring that predicted kinematics closely match observed data. COMAK predicts secondary coordinates based on model parameters and estimated muscle and ligament forces, considering muscle forces, ligament forces, joint geometry, and gravity for more realistic joint contact forces.</li>\n');
    fprintf(fid, '<li><b>Monte Carlo Neuromuscular Coordination (Optional):</b> Execute high-throughput computing simulations to generate probabilistic predictions of knee mechanics over multiple gait cycles.</li>\n');
    fprintf(fid, '<li><b>Output Analysis:</b> The optimized outputs include knee kinematics, muscle activations, and joint contact forces, which are crucial for understanding the mechanical environment of the knee joint.</li>\n');
    fprintf(fid, '</ol>\n');
    fprintf(fid, '</section>\n');
    
    % Validation and Applications
    fprintf(fid, '<section id="validation">\n');
    fprintf(fid, '<h2 style="font-size: 2em; color: #333; margin-bottom: 10px;">Validation and Applications</h2>\n');
    fprintf(fid, '<ul>\n');
    fprintf(fid, '<li><b>Proof of Concept:</b> Mohout et al., 2023, demonstrated the proof of concept for this approach.</li>\n');
    fprintf(fid, '<li><b>Validation of Kinematics:</b> The kinematics of the model were validated by comparing simulation outputs with observed joint angles during walking.</li>\n');
    fprintf(fid, '<li><b>Validation of Dynamics:</b> Muscle activations predicted by the model were compared with electromyography (EMG) data, showing good agreement.</li>\n');
    fprintf(fid, '<li><b>Reproducibility:</b> The reproducibility of results was tested using different trials of a patient, showing consistent outputs.</li>\n');
    fprintf(fid, '<li><b>Sensitivity Analysis:</b> A sensitivity analysis is planned to evaluate the influence of subject-specific loading and boundary conditions, using a statistical shape model to assess sensitivity to geometry, alignment, cartilage thickness, and other factors.</li>\n');
    fprintf(fid, '<li><b>Uncertainty:</b> Identifying uncertainty is challenging due to unknowns in many input parameters.</li>\n');
    fprintf(fid, '<li><b>Generalizability:</b> Testing the generalizability of the workflow with other independent datasets and instrumented patients for validation is planned but not yet completed.</li>\n');
    fprintf(fid, '<li><b>Forward Dynamic Simulation:</b> The output of COMAK can be used to drive forward dynamic simulations for further analysis.</li>\n');
    fprintf(fid, '</ul>\n');
    fprintf(fid, '</section>\n');
    
    % How to Use COMAK Section
    fprintf(fid, '<section id="How_to_Use_COMAK">\n');
    fprintf(fid, '<h2>How to Use COMAK</h2>\n');
    fprintf(fid, '<p>To use the COMAK tool, follow these steps:</p>\n');
    fprintf(fid, '<ol>\n');
    fprintf(fid, '<li>Prepare your musculoskeletal model in OpenSim.</li>\n');
    fprintf(fid, '<li>Set up the COMAK tool and configure the necessary settings.</li>\n');
    fprintf(fid, '<li>Run the COMAK simulation to compute joint contact mechanics.</li>\n');
    fprintf(fid, '<li>Analyze the results, which include joint contact pressures, muscle activations, and reserve actuator forces.</li>\n');
    fprintf(fid, '</ol>\n');
    fprintf(fid, '</section>\n');
    
    % Conclusion Section
    fprintf(fid, '<section id="Conclusion">\n');
    fprintf(fid, '<h2>Conclusion</h2>\n');
    fprintf(fid, '<p>The COMAK simulation workflow provides detailed insights into joint contact mechanics and muscle activations. The results presented in this report can be used to further understand the biomechanics of knee osteoarthritis and to inform clinical decisions.</p>\n');
    fprintf(fid, '</section>\n');
    
    fprintf(fid, '</body>\n</html>');
    
    % Close the file
    fclose(fid);
    
    % Display message
    disp('Main report generated successfully.');
end

