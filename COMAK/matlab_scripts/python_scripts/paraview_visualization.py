import os
import subprocess
import shutil
import urllib.request
import zipfile
from tqdm import tqdm
import glob
from paraview.simple import *
import sys
import mp4_to_gif

def install_ffmpeg():
    print("Downloading ffmpeg...")
    url = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
    output_zip_path = os.path.join(os.getcwd(), "ffmpeg.zip")

    # Download ffmpeg zip
    with urllib.request.urlopen(url) as response, open(output_zip_path, 'wb') as out_file:
        out_file.write(response.read())

    # Extract ffmpeg zip
    print("Extracting ffmpeg...")
    with zipfile.ZipFile(output_zip_path, 'r') as zip_ref:
        zip_ref.extractall(os.path.join(os.getcwd(), "ffmpeg"))

    # Clean up zip file
    os.remove(output_zip_path)

    # Find the bin directory inside the extracted folder
    extracted_dirs = glob.glob(os.path.join(os.getcwd(), "ffmpeg", "ffmpeg-*-essentials_build", "bin"))
    if not extracted_dirs:
        raise FileNotFoundError("Could not find the bin directory in the extracted ffmpeg files.")
    
    ffmpeg_bin = extracted_dirs[0]

    # Add ffmpeg to PATH for the current session
    os.environ["PATH"] += os.pathsep + ffmpeg_bin

    print(f"ffmpeg installed and added to PATH: {ffmpeg_bin}")

def find_ffmpeg():
    ffmpeg_path = shutil.which('ffmpeg')
    if ffmpeg_path is None:
        print("ffmpeg not found. Installing ffmpeg...")
        install_ffmpeg()
        ffmpeg_path = shutil.which('ffmpeg')
        if ffmpeg_path is None:
            raise FileNotFoundError("ffmpeg installation failed.")
    return ffmpeg_path

def run_paraview_analysis(id, project):
    ffmpeg_path = find_ffmpeg()
    print(f"Using ffmpeg at: {ffmpeg_path}")

    paraview_directory = rf'../results/{project}_{id}/graphics/paraview'
    data_directory = rf'../results/{project}_{id}/joint_mechanics'
    template_directory = r'../data/paraview_template_files'

    # Create a directory to store all screenshots
    screenshots_directories = [os.path.join(paraview_directory, 'screenshots/side'), os.path.join(paraview_directory, 'screenshots/top')]
    for screenshots_directory in screenshots_directories:
        if not os.path.exists(screenshots_directory):
            os.makedirs(screenshots_directory)

    # Ensure paraview_directory exists
    if not os.path.exists(paraview_directory):
        os.makedirs(paraview_directory)

    ########## Create paraview setup files (1 from the side and 1 from the top) for data of choice ##########

    def replace_placeholders_in_file(input_file, output_file, placeholders):
        with open(input_file, 'r') as f:
            content = f.read()

        for placeholder, value in placeholders.items():
            content = content.replace(f"{{{placeholder}}}", value)

        with open(output_file, 'w') as f:
            f.write(content)

    # Paths
    input_state_files = [template_directory + r'/paraview_state_file_side_template.pvsm', template_directory + r'/paraview_state_file_top_template.pvsm']
    output_state_files = [paraview_directory + r'/paraview_state_file_side.pvsm', paraview_directory + r'/paraview_state_file_top.pvsm']

    # Define placeholders and their replacements
    placeholders = {
        'DIRECTORY': data_directory,
        'BASENAME': 'walking_' + id
    }

    replace_placeholders_in_file(input_state_files[0], output_state_files[0], placeholders)
    replace_placeholders_in_file(input_state_files[1], output_state_files[1], placeholders)

    ########## Animation from the side and from top ##########

    # Specify your state file and output video file
    state_files = output_state_files
    output_directory = paraview_directory
    output_video_file = [paraview_directory + f'/side_animation_{project}_{id}.mp4', paraview_directory + f'/top_animation_{project}_{id}.mp4']

    for i, state_file in enumerate(state_files):

        # Load the state file
        LoadState(state_file)

        # Get the active view and render view settings
        render_view = GetActiveView()
        render_view.ViewSize = [1280, 720]  # Adjust the resolution as needed

        # Set up the animation parameters
        animation = GetAnimationScene()
        animation.PlayMode = 'Sequence'  # Ensure all frames are captured
        animation.AnimationTime = 0  # Start from the beginning

        # Calculate total number of frames
        total_frames = len(animation.TimeKeeper.TimestepValues)

        # Progress bar for screenshot creation
        with tqdm(total=total_frames, desc=f'Creating screenshots for {state_file}', unit='frames') as pbar:

            # Define a function to save each frame as an image based on time step
            def save_frame(time_step, output_dir):
                render_view.ViewTime = time_step
                file_path = os.path.join(output_dir, f"frame_{int(time_step):04d}.png")

                # Reset camera to default position and focal point
                render_view.ResetCamera()

                SaveScreenshot(file_path, render_view, ImageResolution=render_view.ViewSize)

                # Update progress bar
                pbar.update(1)

            # Save each frame based on time steps
            for time_step in animation.TimeKeeper.TimestepValues:
                save_frame(time_step, output_directory)

        # Path to input images
        input_images = os.path.join(output_directory, 'frame_%04d.png')

        # Output video file
        output_video = output_video_file[i]

        # Convert PNG frames to video using ffmpeg via subprocess
        cmd = [
            'ffmpeg',
            '-framerate', '25',
            '-i', input_images,
            '-c:v', 'libx264',
            '-pix_fmt', 'yuv420p',
            '-loglevel', 'error',  # suppress ffmpeg output
            output_video
        ]

        print(f"Converting frames to video: {output_video}")

        # Execute ffmpeg command with subprocess and suppress output
        subprocess.run(cmd)

        print(f"Animation saved as {output_video}")

        # Delete all PNG frames from the output directory and move them to the screenshot folder
        for file_name in os.listdir(output_directory):
            if file_name.endswith('.png'):
                file_path = os.path.join(output_directory, file_name)
                destination_path = os.path.join(screenshots_directories[i], file_name)
                try:
                    shutil.move(file_path, destination_path)
                except OSError as e:
                    print(f"Error moving {file_path}: {e.strerror}")

    ########## Convert MP4 to GIF ##########

    # Use the module
    visuals = ['side', 'top']  

    for i, visual in enumerate(visuals):
        input_video = output_video_file[i]   
        output_gif = paraview_directory + f'/{visual}_animation_{project}_{id}.gif'
        palette_path = paraview_directory + f'/{visual}_animation_{project}_{id}_palette.png'     

        mp4_to_gif.mp4_to_gif(input_video, output_gif, palette_path, scale='960:-1', fps=25)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Run Paraview Analysis.')
    parser.add_argument('id', type=str, help='ID for the analysis.')
    parser.add_argument('project', type=str, help='Project name for the analysis.')
    args = parser.parse_args()

    run_paraview_analysis(args.id, args.project)
