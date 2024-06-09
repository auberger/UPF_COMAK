import os
import shutil

def create_external_loads_xml(datafile, template_file, target_directory):
    """
    Create an external loads XML file by copying a template and replacing a placeholder with the actual datafile value.

    Parameters:
        datafile (string): The name of the data file to be inserted into the XML.
        template_file (string): The path to the template XML file.
        target_directory (string): The directory where the modified XML file will be saved.
    """
    target_file = os.path.join(target_directory, 'external_loads.xml')

    # Copy the template file to the target directory
    shutil.copy(template_file, target_file)

    # Read the contents of the copied file
    with open(target_file, 'r') as file:
        xml_string = file.read()

    # Replace the placeholder with the actual datafile value
    xml_string = xml_string.replace('0003_aa_Walking_10_grf.mot', datafile)

    # Write the modified XML string back to the file
    with open(target_file, 'w') as file:
        file.write(xml_string)
