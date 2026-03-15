#!/bin/bash

docker build -t llama-cpp:latest --target server -f .devops/cuda.Dockerfile .
