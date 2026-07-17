# Link-editor — agent instructions

## Build & run

```sh
zig build              # compile (default: pipeline)
zig build run          # build + run (needs display + Vulkan loader)
```

Requires a pre-built engine `.a` in `plugins/`.

```sh
# First build the engine and install its plugin:
cd ../engine && zig build build-lib
cp zig-out/lib/libnexus-engine.a ../editor/plugins/

# Then build the editor:
cd ../editor && zig build
```

## Dependency: Engine plugin

The editor links against a static library (`.a` / `.lib`) placed in `plugins/`.
The engine must export `createEngineInterface()` — discovered via `@extern` at
link time. No direct source dependency on any engine repo.

## Architecture decisions

Locked-in decisions at [`docs/architecture-decisions.md`](docs/architecture-decisions.md):
engine-agnostic consumer through EngineInterface, script encapsulation for CI.

## EngineInterface contract

Defined in `contract/engine_interface.zig` at the bundle root. The editor
imports this module for types and consumes the engine entirely through the
vtable-based `EngineInterface`.

## CI

Reusable workflow: `.github/workflows/reusable/build.yml`.
Main CI: `.github/workflows/build.yml` — cross-platform pipeline build.
Auto-rebase: `.github/workflows/rebase-branches.yml` — on push to main, rebases all branches onto it (skips conflicts, logs failures).
