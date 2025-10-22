# BitNet Docker Image for CPU Inference
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3-pip \
    git \
    wget \
    cmake \
    build-essential \
    lsb-release \
    software-properties-common \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install LLVM/Clang 18
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 18 && \
    rm llvm.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up alternatives for clang
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 100

# Set working directory
WORKDIR /BitNet

# Copy the project files
COPY . /BitNet/

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Build the project
RUN python3 setup_env.py --model-dir models/BitNet-b1.58-2B-4T --quant-type i2_s || true

# Create models directory
RUN mkdir -p /BitNet/models

# Expose port for server mode (if needed)
EXPOSE 8080

# Default command
CMD ["/bin/bash"]
