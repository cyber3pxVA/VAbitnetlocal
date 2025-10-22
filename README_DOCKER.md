# BitNet Docker Setup

This setup allows you to run BitNet in Docker on your Pop!_OS machine.

## Quick Start

### Option 1: Use Pre-built Image (Fastest)

Run BitNet using a community-built image:

```bash
# Start the container with pre-built image
docker-compose --profile prebuilt run --rm bitnet-prebuilt

# Inside the container, run inference
python3 run_inference.py -m models/ggml-model-i2_s.gguf -p "What is Pop!_OS?" -cnv
```

### Option 2: Build from Source (Recommended for Development)

Build your own image with the latest code:

```bash
# Build the Docker image
docker-compose build bitnet

# Start the container
docker-compose run --rm bitnet

# Inside the container, run inference
python3 run_inference.py -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf -p "What is Pop!_OS?" -cnv
```

## Directory Structure

```
/media/frasod/4T NVMe/BitNet/
├── models/              # Your model files go here (mounted in Docker)
│   └── BitNet-b1.58-2B-4T/
│       └── ggml-model-i2_s.gguf
├── src/                 # Source code
├── Dockerfile           # Docker image definition
├── docker-compose.yml   # Docker compose configuration
└── README_DOCKER.md     # This file
```

## Downloading Models

Models are stored in the `./models` directory. Download them before running:

```bash
# Download the official BitNet 2B model
huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf --local-dir models/BitNet-b1.58-2B-4T

# Or manually download and place in ./models/
```

## Running Inference

### Interactive Chat Mode

```bash
docker-compose run --rm bitnet
# Inside container:
python3 run_inference.py -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf -p "You are a helpful assistant" -cnv
```

### Single Query

```bash
docker-compose run --rm bitnet python3 run_inference.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -p "Explain quantum computing in simple terms" \
  -n 100
```

### Benchmark

```bash
docker-compose run --rm bitnet python3 utils/e2e_benchmark.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -n 200 -p 256 -t 4
```

## Command Reference

### run_inference.py Options

- `-m MODEL` - Path to model file (required)
- `-p PROMPT` - Prompt text (required)
- `-n N_PREDICT` - Number of tokens to generate (default: varies)
- `-t THREADS` - Number of threads to use
- `-c CTX_SIZE` - Size of the prompt context
- `-temp TEMPERATURE` - Temperature for randomness
- `-cnv` - Enable conversation/chat mode

## VS Code Dev Containers (Optional)

To use VS Code's Dev Containers feature:

1. Install the "Dev Containers" extension in VS Code
2. Open this folder in VS Code
3. Press F1 and select "Dev Containers: Reopen in Container"
4. VS Code will build and connect to the container

## Troubleshooting

### Container won't start
```bash
# Check Docker is running
docker ps

# Check logs
docker-compose logs bitnet
```

### Model not found
- Ensure your model file is in `./models/` directory
- Check the path matches what you specify with `-m`

### Permission errors
```bash
# Fix permissions on models directory
sudo chown -R $USER:$USER ./models
```

## Cleanup

```bash
# Stop and remove containers
docker-compose down

# Remove images
docker-compose down --rmi all

# Remove volumes (careful! this deletes data)
docker-compose down -v
```
