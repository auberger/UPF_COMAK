function bodyWeight = extract_bodyweight_from_emt(filePath)
    % EXTRACT_BODYWEIGHT_FROM_EMT Extracts body weight from an EMT file.
    %
    % This function reads an EMT file in the specified directory and extracts the 
    % body weight value associated with the "mTB" line.
    %
    % Parameters:
    %   filePath (string): The path to the directory containing the .emt file.
    %
    % Returns:
    %   bodyWeight (double): The extracted body weight in kilograms.
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Open the file
    file_1 = dir(fullfile(filePath, '*.emt'));
    file = [file_1.folder '/' file_1.name];

    fileID = fopen(file, 'r');
    if fileID == -1
        error('Cannot open the file: %s', file_1.name);
    end

    % Initialize body weight variable
    bodyWeight = [];

    % Read the file line by line
    line = fgetl(fileID);
    while ischar(line)
        % Check for the "mTB" line and extract the body weight
        if contains(line, 'mTB')
            line = fgetl(fileID);  % Read the next line containing the weight
            bodyWeight = str2double(strtrim(line));
            break;
        end
        line = fgetl(fileID);
    end

    % Close the file
    fclose(fileID);

    % Check if the body weight was found and handle the case where it was not
    if isempty(bodyWeight)
        error('Body weight not found in the .emt file.');
    end
end
