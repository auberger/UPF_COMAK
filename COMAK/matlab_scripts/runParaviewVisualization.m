function runParaviewVisualization(id, project)
    % runParaviewVisualization - Executes a Paraview visualization script from MATLAB.
    % Usage:
    %   runParaviewVisualization(id, project)
    %
    % Parameters:
    %   id      - Identifier for the visualization (string).
    %   project - Name of the project (string).
    %
    % This function sets up a Conda environment and runs a Python script 
    % for visualizing simulation results using Paraview. It checks if the 
    % necessary environment exists, creates it if not, and installs required 
    % dependencies.
    %
    % Dependencies installation steps (to be executed outside of this function):
    %   conda create -n paraview-env
    %   conda activate paraview-env
    %   conda install -c conda-forge paraview
    %   pip install tqdm
    %
    % Author: Aurel Berger
    % Date: July 2024


    % Define environment and dependencies
    envName = 'paraview-env'; % Name of the Conda environment
    dependencies = ["paraview", "tqdm"]; % Required Python packages

    % Check if Conda environment exists
    [~, envList] = system('conda env list'); % Get list of Conda environments
    envExists = contains(envList, envName); % Check if 'paraview-env' exists

    if ~envExists
        % Create the Conda environment if it doesn't exist
        system(sprintf('conda create -n %s python=3.8 -y', envName)); % Create environment
        % Activate the environment and install dependencies
        for dep = dependencies
            system(sprintf('conda run -n %s pip install %s', envName, dep)); % Install each dependency
        end
    end

    % Define the path to the Python script
    pythonScriptPath = 'python_scripts/paraview_visualization.py';

    % Create the command to run the Python script
    cmd = sprintf('conda run -n %s python "%s" %s %s', envName, pythonScriptPath, id, project);

    % Run the Python script from MATLAB
    fprintf('Running Paraview visualization for ID: %s, Project: %s...\n', id, project); % Display message
    system(cmd); % Execute the command
end
