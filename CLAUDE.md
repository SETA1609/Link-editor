# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Link-editor (alias "Crucible") — Tier 3 (T3) of a 3-tier bundle. A standalone Zig
executable that drives a game engine (Nexus, T2) which it consumes as a **pre-built
static library**, never as source. `AGENTS.md` in this directory is the per-tier
source of truth; read it alongside this file.

Requires Zig `0.16.0`+ (see `build.zig.zon` / `docker/Dockerfile`).

## Build & run

```sh
zig build                # default step = "pipeline": builds + installs the exe
zig build build-editor   # compile only (no install)
zig build run            # build + run (needs a display + Vulkan loader at runtime)
zig build run -- <args>  # extra args are forwarded to the executable
```

Executable name is `link-editor`. There is **no `test` step** — do not run `zig build test`.

### Hard prerequisite: the engine plugin `.a`

The build will not link without `plugins/libnexus-engine.a` present.
`build.zig` links it via `exe.addObjectFile(b.path("plugins/libnexus-engine.a"))`.
`plugins/` is committed but the `.a` is **gitignored** (`*.a` in `.gitignore`), so a
fresh checkout has only `plugins/README.md`. Produce the lib first:

```sh
cd ../engine && zig build build-lib
cp zig-out/lib/libnexus-engine.a ../editor/plugins/
```

In the full bundle this copy is done by the root pipeline's install-plugin step; the
engine only has to export `createEngineInterface` (found via `@extern` at link time).

### Docker

`scripts/build-in-docker.sh [step]` (default `pipeline`), `scripts/shell.sh`
(interactive container), `scripts/clean.sh` (remove caches + Docker artifacts).
`docker/Dockerfile` is Ubuntu 24.04 + Zig 0.16.0 + Vulkan/Xvfb.

## Architecture

The editor talks to the engine **only** through a vtable contract — no direct
dependency on any engine's source or modules.

- **Contract module** — `build.zig` adds an import named `engine_interface` pointing at
  `../contract/engine_interface.zig` (bundle root, outside this repo). It defines
  `EngineOptions`, `VTable`, `EngineInterface` (the wrapper struct with
  `init`/`deinit`/`tick`/`shouldClose`/`getEngineName`/`getEngineVersion`), and
  `EngineFactory = *const fn () EngineInterface`.
- **`src/main.zig`** is the entire current implementation: it resolves the engine's
  `createEngineInterface` symbol via `@extern(engine.EngineFactory, ...)`, calls it to
  get an `EngineInterface`, then `init` + a `while (!shouldClose()) tick()` loop. All
  engine behavior is behind the vtable.
- Nexus-specific features (Flecs, SceneNode, hot-reload) are meant to be reached through
  optional capability flags on the contract, keeping the editor engine-agnostic.

## Gotchas / discrepancies

- **`docs/` is largely aspirational.** `docs/architecture.md` and
  `docs/getting-started.md` describe a much larger design (Dear ImGui docks, `EditorHost`
  API, `src/panels/`, `src/host.zig`, a `nexus` module import, git submodules under
  `libs/`). **None of that exists yet** — `src/` contains only `main.zig`, there are no
  submodules, and the build imports `engine_interface`/links a plain `.a`, not a `nexus`
  dependency. Treat those docs as roadmap, not current state; trust `build.zig` and
  `src/main.zig`.
- `build/` and `zig-out/` are gitignored; an installed binary was observed at
  `build/bin/link-editor` (the pipeline installs there via a non-default prefix).
- CI: `.github/workflows/build.yml` calls the reusable `.github/workflows/reusable/build.yml`.
