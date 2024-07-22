import subprocess

def generate_palette(input_video, palette_path, scale=None, fps=15):
    """
    Generates a color palette from the input video for optimized GIF conversion.

    Parameters:
    input_video (str): Path to the input MP4 video.
    palette_path (str): Path to save the generated palette.
    scale (str): Scale parameter for resizing the video (e.g., '960:-1'). Optional.
    fps (int): Frames per second for the GIF.

    Returns:
    None
    """
    # Build ffmpeg command to generate palette
    command = [
        'ffmpeg',
        '-i', input_video,
        '-vf', (f'fps={fps},scale={scale}:flags=lanczos,palettegen' if scale else f'fps={fps},scale=-1:480:flags=lanczos,palettegen'),
        '-y',  # Overwrite output file if it exists
        palette_path
    ]

    try:
        # Execute ffmpeg command to generate palette
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode == 0:
            print(f'[INFO] Palette generated and saved as {palette_path}')
        else:
            print(f'[ERROR] Error generating palette: {result.stderr}')
    except subprocess.CalledProcessError as e:
        print(f'[ERROR] Subprocess error generating palette: {e}')

def convert_mp4_to_gif_with_palette(input_video, output_gif, palette_path, scale=None, fps=15):
    """
    Converts an MP4 video to a GIF using the generated palette for optimized colors.

    Parameters:
    input_video (str): Path to the input MP4 video.
    output_gif (str): Path to save the output GIF.
    palette_path (str): Path to the generated palette.
    scale (str): Scale parameter for resizing the video (e.g., '960:-1'). Optional.
    fps (int): Frames per second for the GIF.

    Returns:
    None
    """
    # Build ffmpeg command to convert video to gif using the palette
    command = [
        'ffmpeg',
        '-i', input_video,
        '-i', palette_path,
        '-filter_complex', (f'fps={fps},scale={scale}:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a' if scale else f'fps={fps},scale=-1:480:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a'),
        '-loop', '0',
        '-y',  # Overwrite output file if it exists
        output_gif
    ]

    try:
        # Execute ffmpeg command to convert video to gif using palette
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode == 0:
            print(f'[INFO] Conversion successful. GIF saved as {output_gif}')
        else:
            print(f'[ERROR] Error converting video to GIF: {result.stderr}')
    except subprocess.CalledProcessError as e:
        print(f'[ERROR] Subprocess error converting video to GIF: {e}')

def mp4_to_gif(input_video, output_gif, palette_path, scale=None, fps=15):
    """
    Converts an MP4 video to a high-quality GIF using a two-pass method with palette optimization.

    Parameters:
    input_video (str): Path to the input MP4 video.
    output_gif (str): Path to save the output GIF.
    palette_path (str): Path to save the generated palette.
    scale (str): Scale parameter for resizing the video (e.g., '960:-1'). Optional.
    fps (int): Frames per second for the GIF.

    Returns:
    None
    """
    # Generate palette
    generate_palette(input_video, palette_path, scale=scale, fps=fps)
    
    # Convert video to GIF using the palette
    convert_mp4_to_gif_with_palette(input_video, output_gif, palette_path, scale=scale, fps=fps)

