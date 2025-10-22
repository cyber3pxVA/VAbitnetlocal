#!/usr/bin/env python3
"""
BitNet Inference Server with Flexible Token Limits
This server allows for dynamic token limits up to a maximum, 
allowing the model to stop naturally before reaching the limit.
"""

import os
import sys
import signal
import platform
import argparse
import subprocess

def run_server():
    build_dir = "build"
    if platform.system() == "Windows":
        server_path = os.path.join(build_dir, "bin", "Release", "llama-server.exe")
        if not os.path.exists(server_path):
            server_path = os.path.join(build_dir, "bin", "llama-server")
    else:
        server_path = os.path.join(build_dir, "bin", "llama-server")
    
    # Set up server with flexible token generation
    command = [
        server_path,
        '-m', args.model,
        '-c', str(args.ctx_size),
        '-t', str(args.threads),  
        '-ngl', '0',  # CPU only
        '--temp', str(args.temperature),
        '--host', args.host,
        '--port', str(args.port),
        '-cb',  # Enable continuous batching
        '--n-predict', str(args.max_tokens)  # Set server max
    ]
    
    if args.prompt:
        command.extend(['-p', args.prompt])
    
    print(f"Starting BitNet server on {args.host}:{args.port}")
    print(f"Maximum tokens per request: {args.max_tokens}")
    print("Server will allow clients to request fewer tokens dynamically.")
    
    try:
        subprocess.run(command)
    except KeyboardInterrupt:
        print("\nShutting down server...")
        sys.exit(0)

def signal_handler(sig, frame):
    print("Ctrl+C pressed, shutting down server...")
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    
    parser = argparse.ArgumentParser(description='Run BitNet llama.cpp server with flexible token limits')
    parser.add_argument("-m", "--model", type=str, 
                       help="Path to model file", required=False, 
                       default="models/BitNet-b1.58-2B-4T/ggml-model-i2_s.gguf")
    parser.add_argument("-p", "--prompt", type=str, 
                       help="System prompt for the model", required=False)
    parser.add_argument("--max-tokens", type=int, 
                       help="Maximum tokens per request", required=False, default=1000)
    parser.add_argument("-t", "--threads", type=int, 
                       help="Number of threads to use", required=False, default=8)
    parser.add_argument("-c", "--ctx-size", type=int, 
                       help="Size of the context window", required=False, default=2048)
    parser.add_argument("--temperature", type=float, 
                       help="Temperature for sampling", required=False, default=0.8)
    parser.add_argument("--host", type=str, 
                       help="IP address to listen on", required=False, default="127.0.0.1")
    parser.add_argument("--port", type=int, 
                       help="Port to listen on", required=False, default=8081)
    
    args = parser.parse_args()
    run_server()