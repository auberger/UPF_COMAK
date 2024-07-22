# COMAK Simulation Workflow

This repository contains the tools and data to analyze gait patterns, such as those of knee osteoarthritis (KOA) patients, using the Helen Hayes marker protocol. The marker set can be adjusted if needed. This workflow has been automated to make it user-friendly and potentially useful in clinical settings. The results are visualized in a comprehensive and intuitive way and are concisely summarized in an HTML report. This report includes GIFs visualizing knee kinematics and contact pressures over one gait cycle, synchronized with plots of total, medial, and lateral mean and max contact pressures as well as the total, medial, and lateral contact areas. It also provides extensive joint mechanics analyses, including center of pressure, contact force, and reaction moments for the total, medial, and lateral compartments of the knee for all three degrees of freedom. Both patellofemoral and tibiofemoral kinematics are available for all six degrees of freedom.

The report includes plots comparing the simulated knee flexion-extension angles with motion capture angles, complete with measures of agreement such as mean absolute error (MAE), max error, correlation, and Bland-Altman plot. The inverse kinematics (IK) error for the simulated results is also provided. It’s easy to investigate muscle activations from all muscles included in the model (right leg only), and reserve actuators can also be easily checked. Muscle activations are compared to four experimental EMG signals (tibialis anterior, vastus lateralis, gastrocnemius lateralis, and biceps femoris caput longus) from the subjects, and a cross-correlation analysis is performed.

The report is updated with each new patient run through the simulation, and mean simulation results are provided, plotting the mean and 95% confidence intervals for all individual-level plots. All visualizations are written to the 'COMAK/results/project_id/graphics' directory and can be easily accessed.

Check out the [example simulation report](example_report.html) for a detailed demonstration.

## Prerequisites

1. **Windows OS**
2. **OpenSim** (used to scale the generic model manually in the GUI)  
   Download from [SimTK](https://simtk.org/frs/?group_id=91).
3. **MATLAB** (any version)  
   Follow the installation guide [here](https://ch.mathworks.com/help/install/ug/install-products-with-internet-connection.html).
4. **Miniconda**  
   Download from [Miniconda](https://docs.anaconda.com/miniconda/).

## Setup Instructions

### Step 1: Download the Repository

Download the ZIP file from this GitHub repository, which includes the code and folder structure.

### Step 2: Install OpenSim and MATLAB

1. **OpenSim**: Install any OpenSim version. This will be used to manually scale the generic model in the GUI.
2. **MATLAB**: Install MATLAB; any version will work.

### Step 3: Configure OpenSim API in MATLAB

1. Extract the downloaded ZIP file, which includes the following:
   - OpenSim version with COMAK tools.
   - MATLAB and Python scripts for running the simulation and visualizing results.
   - Example data of 3 patients for simulation.
   
2. Open MATLAB and configure the OpenSim API by following the instructions [here](https://opensimconfluence.atlassian.net/wiki/spaces/OpenSim/pages/53089380/Scripting+with+Matlab):
   - The configuration file is located at `opensim-core-4.3-2021-06-27-54b40380c/COMAK/matlab_scripts/fconfigureOpenSim.m`.
   - When prompted, choose the installation directory `opensim-core-4.3-2021-06-27-54b40380c\bin`.
   - Add `opensim-core-4.3-2021-06-27-54b40380c\bin` to your system PATH environment variable.

3. You may need to install the following MATLAB toolboxes:
   - Control System Toolbox
   - Curve Fitting Toolbox
   - Image Processing Toolbox
   - Signal Processing Toolbox
   - Statistics and Machine Learning Toolbox

### Step 4: Create Python Environment for ParaView

1. Install Miniconda from [Miniconda](https://docs.anaconda.com/miniconda/).
2. Open a command prompt and create a conda environment named `paraview-env`:
   ```sh
   conda create --name paraview-env
   ```
3. Activate the environment:
   ```sh
   conda activate paraview-env
   ```
4. Install ParaView:
   ```sh
   conda install -c conda-forge paraview
   ```
5. Install the tqdm library for progress bars:
   ```sh
   pip install tqdm
   ```

### Step 5: Run the Simulation

1. Open a command line in the data folder. Navigate to the folder `opensim-core-4.3-2021-06-27-54b40380c\COMAK\data` and type `cmd` in the path bar to open a command prompt at that location.
2. Run the following command in the command prompt, replacing `absolute_path_to_data_folder` with your absolute path to the `opensim-core-4.3-2021-06-27-54b40380c\COMAK\data` folder:
   ```sh
   matlab -r "main_comak_workflow_function('absolute_path_to_data_folder'); exit"
   ```

## Detailed Information About COMAK

### Overview of COMAK Workflow

**Concurrent Optimization of Muscle Activations and Kinematics (COMAK)** is a sophisticated computational approach integrated into the OpenSim-Joint Articular Mechanics (JAM) toolkit. It is designed to enhance the fidelity of musculoskeletal (MSK) simulations by concurrently optimizing muscle activations and joint kinematics. This approach is particularly valuable for studying dynamic joint mechanics, such as those involved in walking, and has applications in understanding and treating knee osteoarthritis (KOA).

### Components and Models

**OpenSim JAM** incorporates various force component plugins, models, and simulation tools to accurately represent joint mechanics:

- **Blankevoort1991Ligament**: Simulates ligament behavior using a spring-damper model, capturing both the nonlinear and linear response of ligament fibers.
- **Smith2018ArticularContactForce and Smith2018ContactMesh**: Represents articular contact using triangular mesh geometries and an elastic foundation model to calculate contact pressures.

**Models**:
- **Lenhart2015 Model**: This model includes detailed representations of the tibiofemoral and patellofemoral joints as 6-degree-of-freedom (DOF) joints, utilizing the Smith2018ArticularContactForce for cartilage contact and Blankevoort1991Ligaments for ligaments.

**Simulation Tools**:
- **COMAKInverseKinematics and COMAK**: These tools implement the COMAK algorithm to calculate muscle forces and detailed joint mechanics during dynamic movements.
- **JointMechanicsTool**: Enables detailed analysis of joint mechanics simulations, generating files for visualization and further analysis in MATLAB, Python, or HDF View.

### How COMAK Works

1. **Knee Model Construction**:
   - Develop a personalized knee model based on imaging data, integrated with a comprehensive MSK model that includes bones, muscles, and ligaments.

2. **Data Collection**:
   - Gather experimental data through gait analysis, tracking marker trajectories and measuring ground reaction forces.

3. **Inverse Kinematics**:
   - Use the collected data to compute primary joint angles and movements using inverse kinematics algorithms.

4. **Prescribed Flexion Forward Simulation**:
   - Conduct a forward simulation with prescribed joint flexion to estimate initial secondary kinematic variables.

5. **Initialization Forward Simulation**:
   - Refine secondary kinematic variables through an initialization simulation, preparing for the optimization process.

6. **Optimization**:
   - Apply the COMAK algorithm to concurrently optimize muscle activations and secondary kinematics. The goal is to minimize the sum of weighted muscle activations squared while ensuring that predicted kinematics closely match observed data.
   - COMAK predicts secondary coordinates based on model parameters and estimated muscle and ligament forces, considering muscle forces, ligament forces, joint geometry, and gravity for more realistic joint contact forces.

7. **Monte Carlo Neuromuscular Coordination (Optional)**:
   - Execute high-throughput computing simulations to generate probabilistic predictions of knee mechanics over multiple gait cycles.

8. **Output Analysis**:
   - The optimized outputs include knee kinematics, muscle activations, and joint contact forces, which are crucial for understanding the mechanical environment of the knee joint.

### Validation and Applications

**Proof of Concept**:
- [Mohout et al., 2023](https://www.frontiersin.org/journals/bioengineering-and-biotechnology/articles/10.3389/fbioe.2023.1214693/full), demonstrated the proof of concept for this approach, validating the kinematics and dynamics of the model against experimental data.

**Validation of Kinematics**:
- The model's kinematics were validated by comparing simulation outputs with observed joint angles during walking.

**Validation of Dynamics**:
- Muscle activations predicted by the model were compared with electromyography (EMG) data, showing good agreement.

**Reproducibility**:
- The reproducibility of results was tested using different trials of a patient, showing consistent outputs.

**Sensitivity Analysis**:
- A sensitivity analysis is planned to evaluate the influence of subject-specific loading and boundary conditions, using a statistical shape model to assess sensitivity to geometry, alignment, cartilage thickness, and other factors.

**Uncertainty**:
- Identifying uncertainty is challenging due to unknowns in many input parameters.

**Generalizability**:
- Testing the generalizability of the workflow with other independent datasets and instrumented patients for validation is planned but not yet completed

**Forward Dynamic Simulation**:
- The output of COMAK can be used to drive forward dynamic simulations for further analysis.

For further details, explore the [OpenSim-JAM GitHub repository](https://github.com/clnsmith/opensim-jam/tree/master) and the original research paper [DOI: 10.3389/fbioe.2023.1214693](https://www.frontiersin.org/articles/10.3389/fbioe.2023.1214693/full).
