# BitNet Quick Start Guide 🚀

Your Docker image is built and ready! Here's how to get started:

## Step 1: Download a Model

You need a BitNet model to run inference. Download the official 2B model:

```bash
# Install huggingface-cli if you don't have it
pip3 install --user huggingface-hub

# Download the model (this will take a few minutes - it's several GB)
huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf --local-dir ./models/BitNet-b1.58-2B-4T
```

Or download manually from: https://huggingface.co/microsoft/BitNet-b1.58-2B-4T-gguf

## Step 2: Run BitNet

### Option A: Interactive Shell (Recommended for first time)

```bash
# Start the container
docker compose run --rm bitnet

# Inside the container, run inference:
python3 run_inference.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -p "You are a helpful assistant" \
  -cnv
```

### Option B: Quick Run Script

```bash
# Single query
./run-bitnet.sh -p "What is artificial intelligence?"

# Interactive chat mode
./run-bitnet.sh -cnv
```

### Option C: Direct Command

```bash
docker compose run --rm bitnet \
  python3 run_inference.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -p "Explain quantum computing" \
  -n 100
```

## Common Commands

### Chat Mode (Interactive Conversation)
```bash
docker compose run --rm bitnet python3 run_inference.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -p "You are a helpful assistant" \
  -cnv
```

### Single Query
```bash
docker compose run --rm bitnet python3 run_inference.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -p "Write a haiku about AI" \
  -n 50
```

### Run Benchmark
```bash
docker compose run --rm bitnet python3 utils/e2e_benchmark.py \
  -m models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf \
  -n 128 -p 512 -t 4
```

## Command Line Options

- `-m MODEL` - Path to model file (required)
- `-p PROMPT` - Your prompt/question (required)
- `-cnv` - Enable chat/conversation mode
- `-n N_PREDICT` - Number of tokens to generate
- `-t THREADS` - Number of CPU threads to use
- `-temp TEMPERATURE` - Sampling temperature (0.0-1.0)

## Folder Structure

```
/media/frasod/4T NVMe/BitNet/
├── models/                          ← Put your .gguf model files here
│   └── BitNet-b1.58-2B-4T/
│       └── ggml-model-i2_s.gguf
├── Dockerfile                       ← Docker image definition
├── docker-compose.yml               ← Docker compose config
├── setup-docker.sh                  ← Setup helper script
├── run-bitnet.sh                    ← Quick run script
└── README_DOCKER.md                 ← Full documentation
```

## Available Models

| Model | Size | Description |
|-------|------|-------------|
| BitNet-b1.58-2B-4T | 2.4B | Official Microsoft model (recommended) |
| bitnet_b1_58-large | 0.7B | Smaller, faster model |
| bitnet_b1_58-3B | 3.3B | Larger model |
| Llama3-8B-1.58-100B-tokens | 8.0B | Based on Llama3 |

Download from: https://huggingface.co/microsoft

## Troubleshooting

### Model not found error?
- Make sure the model file is in `./models/` directory
- Check the path matches: `models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf`

### Container won't start?
```bash
# Check Docker is running
docker ps

# Rebuild if needed
docker compose build bitnet
```

### Slow performance?
- Use `-t` flag to set more CPU threads
- Try a smaller model (0.7B instead of 2B)

## Next Steps

1. **Try different prompts** - Experiment with various questions
2. **Adjust parameters** - Play with temperature and token count
3. **Try other models** - Download and test different model sizes
4. **Set up VS Code Dev Containers** - For integrated development

## Resources

- **Full Documentation**: `README_DOCKER.md`
- **Official Repo**: https://github.com/microsoft/BitNet
- **Models**: https://huggingface.co/microsoft
- **Paper**: https://arxiv.org/abs/2402.17764

---

**Your BitNet is ready to go! 🎉**

Start with: `./setup-docker.sh` (option 3 to download a model)
