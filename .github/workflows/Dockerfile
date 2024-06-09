FROM python:3.9

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    libglu1-mesa \
    libxi-dev \
    libxmu-dev \
    libblas-dev \
    liblapack-dev \
    libboost-all-dev \
    libtbb-dev \
    swig \
    wget

# Download and extract OpenSim
RUN wget https://github.com/opensim-org/opensim-core/releases/download/v4.2/opensim-core-4.2.tgz && \
    tar -xzf opensim-core-4.2.tgz && \
    cd opensim-core-4.2 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Set environment variables for OpenSim
ENV OPENSIM_HOME=/opensim-core-4.2
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENSIM_HOME/build
ENV PYTHONPATH=$PYTHONPATH:$OPENSIM_HOME/build

# Install Python dependencies
RUN pip install numpy pandas matplotlib scipy

# Copy your Python scripts
COPY . /app
WORKDIR /app

CMD ["python", "main_comak_workflow.py"]
