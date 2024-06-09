import os
import xml.etree.ElementTree as ET

def extract_bodyweight_from_mdx(directory):
    """
    Extract bodyweight from an MDX file in the specified directory
    
    Parameters:
        directory (str): The directory containing the .mdx file
    
    Returns:
        float: The extracted body weight in kilograms
    """
    # Define the path to the MDX file
    file_info = next((f for f in os.listdir(directory) if f.endswith('.mdx')), None)
    
    # Ensure there is exactly one .mdx file in the directory
    if not file_info:
        raise FileNotFoundError("No .mdx file found in the specified directory.")

    file_path = os.path.join(directory, file_info)

    # Read the XML file
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Initialize the body weight variable
    body_weight = None

    # Find all "mass" elements and extract the body weight
    for mass_element in root.findall('.//mass'):
        if mass_element.get('label') == 'mTB':
            body_weight = float(mass_element.get('data')) / 1000  # Convert to kg
            break

    # Check if the body weight was found and handle the case where it was not
    if body_weight is None:
        raise ValueError("Body weight not found in the .mdx file.")

    return body_weight
