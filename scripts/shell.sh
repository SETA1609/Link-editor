#!/usr/bin/env bash
# Drop into an interactive container for debugging Link-editor builds.
set -euo pipefail

source_dir="$(dirname "$0")/.."

echo "==> Starting interactive shell in Link-editor Docker container..."
docker build -t editor-builder -f "${source_dir}/docker/Dockerfile" "${source_dir}"
docker run --rm -it \
    -v "${source_dir}:/workspace" \
    --entrypoint /bin/bash \
    editor-builder
