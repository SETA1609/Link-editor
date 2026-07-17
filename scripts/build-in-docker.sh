#!/usr/bin/env bash
# Build Link-editor inside the Docker container.
# Usage: ./scripts/build-in-docker.sh [step]
#   step: pipeline (default), build-editor, build-engine, run, or any zig build step
set -euo pipefail

STEP="${1:-pipeline}"

cd "$(dirname "$0")/.."

git submodule update --init --recursive

echo "==> Link-editor: zig build ${STEP}"
zig build "${STEP}"
