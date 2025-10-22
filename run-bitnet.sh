#!/bin/bash
# Quick run script for BitNet inference

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Default values
MODEL="models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf"
PROMPT=""
CONVERSATION=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -p|--prompt)
            PROMPT="$2"
            shift 2
            ;;
        -cnv|--conversation)
            CONVERSATION=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./run-bitnet.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -m, --model MODEL      Path to model file (default: models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf)"
            echo "  -p, --prompt PROMPT    Prompt text"
            echo "  -cnv, --conversation   Enable conversation mode"
            echo "  -h, --help            Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./run-bitnet.sh -p \"What is AI?\""
            echo "  ./run-bitnet.sh -cnv"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

# Build command
CMD="python3 run_inference.py -m $MODEL"

if [ -n "$PROMPT" ]; then
    CMD="$CMD -p \"$PROMPT\""
else
    CMD="$CMD -p \"You are a helpful assistant\""
fi

if [ "$CONVERSATION" = true ]; then
    CMD="$CMD -cnv"
fi

# Run in Docker
echo "Running BitNet in Docker..."
echo "Command: $CMD"
echo ""

docker compose run --rm bitnet bash -c "$CMD"
