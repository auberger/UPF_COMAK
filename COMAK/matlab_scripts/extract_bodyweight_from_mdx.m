function bodyWeight = extract_bodyweight_from_mdx(directory)
    % EXTRACT_BODYWEIGHT_FROM_MDX Extracts body weight from an MDX file.
    %
    % This function reads an MDX file in the specified directory and extracts the 
    % body weight value associated with the label "mTB".
    %
    % Parameters:
    %   directory (string): The directory containing the .mdx file.
    %
    % Returns:
    %   bodyWeight (double): The extracted body weight in kilograms.
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Define the path to the MDX file
    file_info = dir(fullfile(directory, '*.mdx'));
    
    % Ensure there is exactly one .mdx file in the directory
    if isempty(file_info)
        error('No .mdx file found in the specified directory.');
    elseif length(file_info) > 1
        error('Multiple .mdx files found in the specified directory.');
    end

    % Read the XML file
    xmlDoc = xmlread(fullfile(file_info.folder, file_info.name));

    % Get the root element
    rootElement = xmlDoc.getDocumentElement();

    % Find all "mass" elements
    massElements = rootElement.getElementsByTagName('mass');

    % Initialize the body weight variable
    bodyWeight = [];

    % Loop through each mass element to find the total body mass
    for i = 0:massElements.getLength()-1
        massElement = massElements.item(i);
        if strcmp(char(massElement.getAttribute('label')), 'mTB')
            bodyWeight = str2double(massElement.getAttribute('data')) / 1000; % Convert to kg
            break;
        end
    end

    % Check if the body weight was found and handle the case where it was not
    if isempty(bodyWeight)
        error('Body weight not found in the .mdx file.');
    end
end
