# Link-editor — Tier 3 documentation

> **Official name:** **Link-editor** (alias: *Crucible*).  
> **Status:** Planned — ships with Nexus Engine **v1.1.0+**.  
> **Repository:** `SETA1609/Link-editor` (this repo).  
> **Consumes:** Nexus Engine via `EditorHost` API (frozen at Nexus v1.0.0).

Crucible is the **detachable immediate-mode editor** for the Nexus game engine stack. It edits `SceneNode` hierarchies, inspects ECS state (through `EditorHost`, never direct Flecs linkage), and uses **Dear ImGui** for all tool UI.

---

## Documentation suite

| Doc | Description |
|-----|-------------|
| [`architecture.md`](architecture.md) | Editor architecture — detached process, ImGui panels, EditorHost |
| [`getting-started.md`](getting-started.md) | Build, run, and configure the editor |
| [`roadmap.md`](roadmap.md) | Editor version milestones |
| [`dependencies.yml`](dependencies.yml) | Dependency inventory |
| [`file-tree.yml`](file-tree.yml) | Repo file status |
| [`theory/README.md`](theory/README.md) | Theory reading path |
| [`examples/`](examples/) | Editor example design docs |

---

## References to engine docs

The editor is described in the following Nexus Engine documents:

| Engine doc | What it says about Crucible |
|------------|-----------------------------|
| [`Nexus_Reference.md` §9](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md) | EditorHost API contract |
| [`Nexus_Reference.md` §13](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md) | Three UI lanes (Editor/In-game/Debug) |
| [`architecture.md`](https://github.com/SETA1609/Nexus-engine/blob/main/docs/architecture.md) | 3-tier stack overview |
| [`theory/09-hot-reload-crucible.md`](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md) | Editor-driven hot reload |
| [`theory/10-hazel-hazelnut-split.md`](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/10-hazel-hazelnut-split.md) | Hazel/Hazelnut lessons for 3-tier |
| [`ROADMAP.md`](https://github.com/SETA1609/Nexus-engine/blob/main/docs/ROADMAP.md) | Editor milestones in engine context |

---

## 3-tier model

```ascii
┌──────────────────────────────────────────────────────────────┐
│  TIER 3: LINK-EDITOR (this repo)                               │
│    • Immediate-mode UI (Dear ImGui)                          │
│    • Edits SceneNode hierarchy; inspects ECS via EditorHost  │
│    • Detachable — ships as separate binary                   │
└────────────────────────────┬─────────────────────────────────┘
                             │ EditorHost API
┌────────────────────────────▼─────────────────────────────────┐
│  TIER 2: NEXUS ENGINE (Nexus-engine repo)                      │
│    • Hybrid SceneNode + optional ECS (Flecs)                 │
│    • Servers, resources, localization                        │
│    • Ships games without editor                              │
└────────────────────────────┬─────────────────────────────────┘
                             │ zgame.*
┌────────────────────────────▼─────────────────────────────────┐
│  TIER 1: zGAMELIB (zGameLib repo)                           │
│    • Platform, Vulkan, GPU, FrameRing                        │
│    • Optional: ImGui (late), fonts, audio                    │
└──────────────────────────────────────────────────────────────┘
```
