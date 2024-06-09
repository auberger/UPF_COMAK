import numpy as np

def read_opensim_mot(file):
    """
    Read OpenSim .mot file.

    Parameters:
        file (str): Path to the .mot file.

    Returns:
        data (np.ndarray): Data matrix [nFrames x nLabels].
        labels (list): List of label strings.
        header (dict): Dictionary containing header information.
    """
    if not file:
        raise ValueError('File path must be provided.')

    header = {}
    data = []
    labels = []

    with open(file, 'r') as fid:
        print(f'Loading file: {file}')

        # Read the file name line
        header['filename'] = fid.readline().strip()

        # Read Header
        line = fid.readline()
        while 'endheader' not in line.lower():
            if not line:
                raise EOFError('ERROR: Reached EOF before "endheader"')

            line_space = line.replace('=', ' ')
            split_line = line_space.split()

            if len(split_line) == 2:
                var, value = split_line
                if var.lower() == 'version':
                    header['version'] = float(value)
                elif var.lower() in ['nrows', 'datarows']:
                    nr = int(value)
                    header['nRows'] = nr
                elif var.lower() in ['ncolumns', 'datacolumns']:
                    nc = int(value)
                    header['nColumns'] = nc
                elif var.lower() == 'indegrees':
                    header['indegrees'] = value.strip()

            line = fid.readline()

        # Load Column Headers
        line = fid.readline()
        labels = line.split()

        # Now load the data
        data = np.loadtxt(fid)

        if data.shape[0] < nr:
            print(f'Number of rows ({data.shape[0]}) is less than that specified in header ({nr})')
            data = data[:data.shape[0], :]

    return data, labels, header

