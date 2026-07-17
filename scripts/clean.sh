#!/usr/bin/env bash
# Clean up Docker resources created by Link-editor builds.
set -euo pipefail

source_dir="$(dirname "$0")/.."

echo "==> Removing Link-editor Docker volumes and dangling images..."
docker image prune -f --filter "label=component=link-editor" 2>/dev/null || true

rm -rf "${source_dir}/.zig-cache" "${source_dir}/zig-out" "${source_dir}/build" \
       "${source_dir}/zig-pkg" "${source_dir}/libs/nexus-engine/.zig-cache" 2>/dev/null || true
echo "==> Done."
