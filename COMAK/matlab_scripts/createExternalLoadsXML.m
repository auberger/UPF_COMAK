function createExternalLoadsXML(datafile, templateFile, targetDirectory)
    % createExternalLoadsXML generates an external loads XML file based on a template.
    %
    % This function creates an external loads XML file by copying a template file,
    % replacing a placeholder with the path to the actual external loads data file,
    % and saving the modified XML file in the specified target directory.
    %
    % Inputs:
    %   datafile - The path to the file containing external loads data.
    %   templateFile - The path to the template XML file to use as a basis.
    %   targetDirectory - The directory where the generated XML file will be saved.
    %
    % Outputs: None
    %
    % Author: Aurel Berger
    % Date: July 2024

    % Define paths
    targetFile = fullfile(targetDirectory, 'external_loads.xml');

    % Copy the template file to the target directory
    copyfile(templateFile, targetFile);

    % Read the contents of the copied file
    xmlString = fileread(targetFile);

    % Replace the placeholder with the actual datafile value
    xmlString = strrep(xmlString, '0003_aa_Walking_10_grf.mot', datafile);

    % Write the modified XML string back to the file
    fid = fopen(targetFile, 'w');
    fwrite(fid, xmlString, 'char');
    fclose(fid);
end
