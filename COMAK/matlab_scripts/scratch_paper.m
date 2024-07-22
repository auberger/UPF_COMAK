project = 'STRATO';
id = '001';
BW = 63.3; 
time_start = 4.572;
time_stop = 5.508;
sf = 1000;


%% Set global plot parameters
set(0, 'DefaultLineLineWidth', 2); % Default line width
set(0, 'DefaultAxesFontSize', 14); % Default font size for axes
set(0, 'DefaultAxesLabelFontSizeMultiplier', 1.2); % Multiplier for axis label font size
set(0, 'DefaultAxesTitleFontSizeMultiplier', 1.4); % Multiplier for axis title font size
set(0, 'DefaultLegendFontSize', 12); % Default legend font size
set(0, 'DefaultFigureColor', 'w'); % Default figure background color



directory_walking = 'C:\Users\admin\Documents\OpenSim\opensim-core-4.3-2021-06-27-54b40380c\COMAK\data\STRATO_004\walking';

% Get the full path of the currently running MATLAB file
currentFile = mfilename('fullpath');

% Get the directory of the currently running MATLAB file
currentDirectory = fileparts(currentFile);

forces_file = fullfile(currentDirectory, ['../results/' project_id '_' numeric_id '/joint_mechanics/walking_' numeric_id '_ForceReporter_forces.sto']);


gif_save_path = 'C:\Users\admin\Documents\OpenSim\opensim-core-4.3-2021-06-27-54b40380c\COMAK\results\STRATO_004\graphics\paraview';

% Call the function to create animated plots and save as GIF
% create_animated_joint_mechanics_gif(project_id, numeric_id, forces_file, BW, gif_save_path);

% plot_joint_mechanics_extended(project_id, numeric_id, forces_file, BW);

%plot_primary_coordinates_vs_mocap(numeric_id, project_id, directory_walking)


%plot_all_patients_pressure_and_area()

runParaviewVisualization(id, project)