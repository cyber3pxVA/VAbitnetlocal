#!/bin/bash
# Optimized inference script for VA workstation

export PATH="/c/Users/VHAWRJDRESCF/OneDrive - Department of Veterans Affairs/Documents/GitHub/VAbitnet/tools/mingw64/bin:$PATH"

MODEL="models/bitnet_b1_58-large/ggml-model-tl2.gguf"
LLAMA_CLI="./build_mingw/bin/llama-cli.exe"

# Optimized settings based on performance testing:
# - 4 threads (best performance on this CPU)
# - Batch 512 (good balance)
# - Context 1024 (saves memory)
# - Temp 0.7 (coherent output)

if [ -z "$1" ]; then
    echo "Usage: $0 \"Your prompt here\" [num_tokens]"
    echo ""
    echo "Example:"
    echo "  $0 \"What is the Department of Veterans Affairs?\" 100"
    echo ""
    echo "Optimized for VA workstation (Intel i7-1265U)"
    echo "Performance: ~7 tokens/second"
    exit 1
fi

PROMPT="$1"
TOKENS="${2:-100}"

echo "Running optimized inference..."
echo "Prompt: $PROMPT"
echo "Tokens: $TOKENS"
echo "---"

$LLAMA_CLI \
    -m "$MODEL" \
    -p "$PROMPT" \
    -n "$TOKENS" \
    -t 4 \
    -b 512 \
    -c 1024 \
    --temp 0.7 \
    --repeat_penalty 1.1

echo ""
echo "---"
echo "Performance optimized for VA workstation"
