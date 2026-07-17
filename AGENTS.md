# Link-editor — agent instructions

## Build & run

```sh
zig build              # compile (default: pipeline → engine lib → editor)
zig build run          # build + run (needs display + Vulkan loader)
zig build build-editor # editor only (depends on build-lib from engine)
```

Requires Zig **0.16.0**.

## Docker development

```sh
./scripts/build-in-docker.sh              # `zig build pipeline` in Docker
./scripts/build-in-docker.sh build-editor # editor only
./scripts/shell.sh                        # interactive container shell
./scripts/clean.sh                        # remove volumes + build artifacts
```

## Dependency: Nexus-engine

Symlinked at `libs/nexus-engine` (Git submodule). The editor imports the `nexus`
module for types and links `libnexus-engine.a`.

```sh
git submodule update --init --recursive
```

## CI

Reusable workflow: `.github/workflows/reusable/build.yml`.
Main CI: `.github/workflows/build.yml` — cross-platform pipeline build.
