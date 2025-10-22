#!/bin/bash
# BitNet Docker Setup Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "BitNet Docker Setup"
echo "======================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   sudo apt-get update"
    echo "   sudo apt-get install docker.io docker-compose"
    exit 1
fi

# Check if Docker Compose is installed (v2)
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose v2."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if user is in docker group
if ! groups | grep -q docker; then
    echo "⚠️  Your user is not in the 'docker' group."
    echo "   You may need to run Docker commands with sudo, or add yourself to the group:"
    echo "   sudo usermod -aG docker $USER"
    echo "   Then log out and log back in."
    echo ""
fi

# Create models directory if it doesn't exist
mkdir -p models
echo "✅ Models directory created/verified: $(pwd)/models"
echo ""

# Ask user what they want to do
echo "What would you like to do?"
echo "1) Build BitNet Docker image from source (recommended)"
echo "2) Use pre-built image (faster, community-maintained)"
echo "3) Download a model first"
echo "4) Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Building BitNet Docker image..."
        docker compose build bitnet
        echo ""
        echo "✅ Build complete!"
        echo ""
        echo "To run BitNet, use:"
        echo "  docker compose run --rm bitnet"
        ;;
    2)
        echo ""
        echo "Pulling pre-built image..."
        docker pull ghcr.io/kth8/bitnet:latest
        echo ""
        echo "✅ Pull complete!"
        echo ""
        echo "To run BitNet, use:"
        echo "  docker compose --profile prebuilt run --rm bitnet-prebuilt"
        ;;
    3)
        echo ""
        echo "To download models, you need huggingface-cli installed."
        echo ""
        if ! command -v huggingface-cli &> /dev/null; then
            echo "Installing huggingface-cli..."
            pip3 install --user huggingface-hub
        fi
        echo ""
        echo "Downloading BitNet-b1.58-2B-4T model (this may take a while)..."
        huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf --local-dir models/BitNet-b1.58-2B-4T
        echo ""
        echo "✅ Model downloaded to: $(pwd)/models/BitNet-b1.58-2B-4T"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo "Setup complete! 🚀"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. If you haven't downloaded a model yet, run:"
echo "   ./setup-docker.sh (and choose option 3)"
echo ""
echo "2. Start the container:"
echo "   docker compose run --rm bitnet"
echo ""
echo "3. Inside the container, run inference:"
echo "   python3 run_inference.py -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf -p \"Hello!\" -cnv"
echo ""
echo "See README_DOCKER.md for more information."
