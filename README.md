# llama.cpp Docker Container

This project provides a Docker-based solution for running **llama.cpp** on GPU acceleration within a containerized environment.

## Prerequisites

Before setting up this project, ensure you have:
- NVIDIA drivers installed
- NVIDIA Container Toolkit installed

## Environment Variables

Copy the environment template and configure your settings:

```bash
cp .env.skel .env
```

| Variable | Description | Default |
|----------|-------------|---------|
| `DOCKER_TAG` | The Docker image tag to pull from ghcr.io (e.g., `server-cuda`, `server-cpu`) | `server-cuda` |
| `PORT` | The host port to expose (maps to container port 8000) | `8000` |
| `LLAMA_API_KEY` | API key for authentication (optional) | `Your secure api key here` |

## Installation Steps

### 1. Login to Github docker repository

Clone the llama.cpp repository into this directory:

```bash
docker login ghcr.io
```

### 2. Configure Models

Return to the project root directory:

```bash
cd ..
mkdir -p models
```

Place all your **GGUF** model files into the `models` folder.

Copy the template configuration file:

```bash
cp config/models.ini.skel config/models.ini
```

Edit `config/models.ini` with your desired model settings. This configuration file references models from your `models` folder by default.

> 📝 Example: See the [omnicoder 9b](./models/omnicoder-9b.Q4_K_M.gguf) for a working reference.

### 3. Configure API Key

Enter your API key in the `.env` file. If you do not wish to use an API key, simply comment out the following line in `docker-compose.yml`:

```yaml
# - LLAMA_API_KEY=${LLAMA_API_KEY}
```

### 4. Start the Container

Run the following command to start the Docker container:

```bash
docker compose up -d
```

### 5. Access the Web Interface

Start the llama.cpp web interface:

```bash
./start-router.sh
```

The web interface will be available at: `http://localhost:8000`

In the web interface:
- View your configured models in the dropdown menu
- Click the **power button** on a model to load it into memory

## Router Configuration

You can customize additional settings by editing the `router.sh` script in the `config` folder:

```bash
#!/bin/bash
exec ./llama-server \
  --host 0.0.0.0 \
  --port 8000 \
  --models-preset /app/models.ini \
  --models-max 1 \
  --models-autoload \
  -ngl 99 \
  "$@"
```

### Setting Explanations

| Setting | Description |
|---------|-------------|
| `--host 0.0.0.0` | Bind the server to all network interfaces. Allows access from outside the container (e.g., from your host or other containers). |
| `--port 8000` | Set the server to listen on port 8000. Change this if needed to avoid port conflicts. |
| `--models-preset /app/models.ini` | Specify the path to the models configuration file. The server reads model definitions from this INI file. |
| `--models-max 1` | Limit the maximum number of models that can be loaded simultaneously. Set to `1` to load only one model at a time. |
| `--models-autoload` | Automatically load all models listed in the configuration file on startup. Remove this flag to load models manually. |
| `-ngl 99` | Enable GPU offloading. The value `99` means offload all layers to GPU. Lower values (e.g., `-ngl 35`) can be used if you're running out of VRAM. |
| `"$@"` | Pass any additional arguments provided to the script through to the llama-server executable. |

### Customization Tips

- **Multiple Models**: Increase `--models-max` if you want to load multiple models simultaneously.
- **Port Change**: If port 8000 is in use, modify the `--port` value or use a different port.
- **VRAM Optimization**: If you encounter out-of-memory errors, reduce the `-ngl` value to keep some layers on the CPU.
- **Disable Autoload**: Remove `--models-autoload` to manually select models via the web interface.

---

*For more information on llama.cpp, visit [ggml-org/llama.cpp](https://github.com/ggml-org/llama.cpp)*