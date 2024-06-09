import os
import numpy as np
from read_opensim_mot import read_opensim_mot  # Assuming this is a custom function you'll need to implement

def save_output_to_text_file(project_id, numeric_id, forces_file):
    """
    Save relevant force data to a text file.

    Parameters:
        project_id (string): The project identifier
        numeric_id (string): The numeric identifier for the project
        forces_file (string): Path to the forces file
    """
    # Extract the relevant data and labels
    forces_data, forces_labels, _ = read_opensim_mot(forces_file)
    columns_indices = list(range(584, 595)) + [3, 4, 599, 600, 605, 606, 611, 612, 625, 626, 627, 628, 629, 630, 635, 636, 641, 642, 655, 656, 657, 658, 659, 660, 673, 674, 675, 676, 677, 678, 691, 692, 693, 694, 695, 696]
    columns = [forces_labels[i] for i in columns_indices]
    data = forces_data[:, columns_indices]

    # Define the directory and file name
    directory = f'../results/{project_id}_{numeric_id}/'
    filename = os.path.join(directory, 'force_data.txt')

    # Create the directory if it doesn't exist
    os.makedirs(directory, exist_ok=True)

    # Write the data to the file
    with open(filename, 'w') as file:
        # Write column titles to the file
        file.write('\t'.join(columns) + '\n')

        # Write data to the file
        for row in data:
            file.write('\t'.join(map(str, row)) + '\n')

    print(f'Data has been saved to {filename}')
