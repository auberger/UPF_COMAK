function save_output_to_text_file(project_id, numeric_id, forces_file)
    % save_output_to_text_file saves relevant data from forces file to a text file.
    %
    % Inputs:
    %   project_id - Identifier for the project.
    %   numeric_id - Numeric identifier for the patient.
    %   forces_file - File containing joint forces data.
    %
    % This function extracts relevant data from the provided forces file and saves it to a text file
    % named 'force_data.txt' in the results directory of the project.
    %
    % Author: Aurel Berger
    % Date: July 2024
    
    % Extract the relevant data and labels
    [forces_data, forces_labels, ~] = read_opensim_mot(forces_file);
    columns = forces_labels([584:594, 3, 4, 599, 600, 605, 606, 611, 612, 625:630, 635, 636, 641, 642, 655:660, 673:678, 691:696], :);
    data = forces_data(:, [584:594, 3, 4, 599, 600, 605, 606, 611, 612, 625:630, 635, 636, 641, 642, 655:660, 673:678, 691:696]);

    % Define the directory and file name
    directory = ['../results/' project_id '_' numeric_id '/'];
    filename = fullfile(directory, 'force_data.txt');

    % Create the directory if it doesn't exist
    if ~exist(directory, 'dir')
        mkdir(directory);
    end

    % Open the file for writing
    fileID = fopen(filename, 'w');
    if fileID == -1
        error('Cannot open file for writing: %s', filename);
    end

    % Write column titles to the file
    fprintf(fileID, '%s\t', columns{:});
    fprintf(fileID, '\n');

    % Write data to the file
    for row = 1:size(data, 1)
        fprintf(fileID, '%f\t', data(row, :));
        fprintf(fileID, '\n');
    end

    % Close the file
    fclose(fileID);

    disp(['Data has been saved to ' filename]);
end
