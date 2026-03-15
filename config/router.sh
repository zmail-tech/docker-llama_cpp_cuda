#!/bin/bash
exec ./llama-server \
  --host 0.0.0.0 \
  --port 8000 \
  --models-preset /app/models.ini \
  --models-max 1 \
  --models-autoload \
  -ngl 99 \
  "$@"

