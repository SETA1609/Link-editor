# Architecture Decisions — Link-editor

## 1. Engine-agnostic consumer via EngineInterface

The editor consumes the engine **entirely through a vtable contract** — no direct
source dependency on any engine module.

- `src/main.zig` resolves `createEngineInterface` via `@extern` at link time
- Links a pre-built `.a` from `plugins/` via `exe.addObjectFile()`
- All engine behavior (init, tick, shutdown, queries) goes through `EngineInterface`
- The contract lives in the bundle root at `contract/engine_interface.zig`

This decoupling means any engine that exports `createEngineInterface` can drive
the editor — Nexus today, others in the future.

Full contract: [`../contract/engine_interface.zig`](../../contract/engine_interface.zig)
Bundle rationale: [`../docs/architecture-decisions.md`](../../docs/architecture-decisions.md)

## 2. Script encapsulation for CI

No non-trivial bash/Python inline in `.github/workflows/*.yml`. All meaningful
logic goes in `scripts/` and is called from CI.

**Example:** `.github/workflows/build.yml` calls `python3 scripts/validate-workflows.py`
instead of inlining the Python. The same script is usable locally.

See `scripts/validate-workflows.py` · `scripts/build-in-docker.sh`
