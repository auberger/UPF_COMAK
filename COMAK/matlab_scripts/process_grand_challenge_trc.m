% MATLAB script to convert frame numbers from floats to integers and rename columns in a TRC file
% and to modify TRC file column names and convert frame numbers to integers

% Select input TRC file
[fileName, filePath] = uigetfile('*.trc', 'Select the input TRC file');
if isequal(fileName, 0) || isequal(filePath, 0)
    disp('User cancelled the file selection. Script terminated.');
    return;
end
inputFileName = fullfile(filePath, fileName);

% Select output TRC file
[fileName, filePath] = uiputfile('*.trc', 'Save As');
if isequal(fileName, 0) || isequal(filePath, 0)
    disp('User cancelled saving the file. Script terminated.');
    return;
end
outputFileName = fullfile(filePath, fileName);

% Specify the new column names
newColumnNames = {
    'Thoracic', 'c7';
    'R.Asis', 'r.asis';
    'L.Asis', 'l.asis';
    'R.ShoulderAnterior', 'r.should';
    'L.ShoulderAnterior', 'l.should';
    'L.Thigh.Superior', 'l.bar1';
    'L.Knee.Lateral', 'l.knee1';
    'L.Knee.Medial', 'l.kneem';
    'L.Shank.Superior', 'l.bar1';
    'L.Ankle.Lateral', 'l.mall';
    'L.Ankle.Medial', 'l.mallm';
    'R.Thigh.Superior', 'r.bar1';
    'R.Knee.Lateral', 'r.knee1';
    'R.Knee.Medial', 'r.kneem';
    'R.Shank.Superior', 'r.bar1';
    'R.Ankle.Lateral', 'r.mall';
    'R.Ankle.Medial', 'r.mallm';
    'R.Heel', 'r.heel';
    'R.Toe', 'r.met';
    'L.Heel', 'l.heel';
    'L.Toe', 'l.met';
    'Sacral', 'sacrum'
};

% Read the TRC file
fileContent = fileread(inputFileName);

% Split the content into lines
fileLines = strsplit(fileContent, '\n');

% Modify the header line with new column names
headerLineIndex = 4; % Adjust as per your TRC file structure
headerLine = fileLines{headerLineIndex};
for i = 1:size(newColumnNames, 1)
    oldName = newColumnNames{i, 1};
    newName = newColumnNames{i, 2};
    headerLine = strrep(headerLine, oldName, newName);
end
fileLines{headerLineIndex} = headerLine;

% Find the line with the frame numbers
dataStartLineIndex = headerLineIndex + 1; % Assuming frame numbers start right after header

% Loop through the data lines to convert frame numbers to integers
for i = dataStartLineIndex:length(fileLines)
    % Split the current line by tabs
    lineData = strsplit(fileLines{i}, '\t');
    
    if length(lineData) > 1
        % Convert the frame number (first element) to an integer
        frameNumber = round(str2double(lineData{1}));
        
        % Replace the first element with the integer frame number
        lineData{1} = num2str(frameNumber);
        
        % Join the line back together
        fileLines{i} = strjoin(lineData, '\t');
    end
end

% Write the modified content to the output file
fileID = fopen(outputFileName, 'w');
for i = 1:length(fileLines)
    fprintf(fileID, '%s\n', fileLines{i});
end
fclose(fileID);

disp(['Modified TRC file saved as ', outputFileName]);