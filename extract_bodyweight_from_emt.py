import os

def extract_bodyweight_from_emt(file_path):
    """
    Extract bodyweight from an EMT file in the specified directory
    
    Parameters:
        file_path (str): The path to the .emt file
    
    Returns:
        float: The extracted body weight in kilograms
    """
    # Open the file
    file_1 = next((f for f in os.listdir(file_path) if f.endswith('.emt')), None)
    if not file_1:
        raise FileNotFoundError("No .emt file found in the specified directory.")

    file = os.path.join(file_path, file_1)
    
    body_weight = None

    # Read the file line by line
    with open(file, 'r') as file_id:
        for line in file_id:
            if 'mTB' in line:
                body_weight = float(next(file_id).strip())
                break

    # Check if the body weight was found and handle the case where it was not
    if body_weight is None:
        raise ValueError("Body weight not found in the .emt file.")

    return body_weight
