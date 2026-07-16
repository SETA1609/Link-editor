# Link-editor — theory reading path

Crucible inherits most of its theory from **Nexus Engine's theory ladder**.
The editor is a consumer of the engine; its design decisions follow from the
engine's architecture.

---

## Nexus Engine theory docs

Read these first (in order) to understand the engine the editor edits:

| # | Doc | Relevance to Crucible |
|---|-----|----------------------|
| 01 | [Scene representation](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/01-scene-representation.md) | SceneNode hierarchy the editor will display and mutate |
| 02 | [ECS integration](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/02-ecs-integration.md) | ECS bridge — editor inspects via EditorHost, never direct Flecs |
| 03 | [Systems and update loop](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/03-systems-and-update-loop.md) | Tick phases — play-in-editor runs the same loop |
| 04 | [Performance considerations](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/04-performance-considerations.md) | When to use ECS — informs editor's performance display |
| 05 | [Resource and asset management](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/05-resource-and-asset-management.md) | ResourceDB — editor imports, reimports, browses assets |
| 06 | [UI and localization](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/06-ui-and-localization.md) | Three UI lanes — editor is the ImGui lane |
| 08 | [Hot reload (engine)](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/08-hot-reload-nexus-engine.md) | ReloadEventBus — editor drives resource/scene hot reload |
| 09 | [Hot reload (Crucible)](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md) | Editor-specific hot reload — file watcher, play-in-editor |
| 10 | [Hazel/Hazelnut split](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/10-hazel-hazelnut-split.md) | Why the editor is a separate binary |

---

## Editor-specific theory

These concepts are unique to Crucible and documented here:

| Topic | Where | Status |
|-------|-------|--------|
| Dear ImGui integration | [`docs/architecture.md`](../architecture.md) | Planned |
| Play-in-editor mechanics | [Nexus theory/09](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md) | Specified |
| EditorHost protocol | [Nexus_Reference.md §9](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md#9-link-editor-tier-3-interaction) | Specified |
| File watcher design | Nexus theory/09 | Specified |
| Undo/redo system | Not yet documented | Planned |
| Editor plugin API | Not yet documented | Post-1.2 |
| Detached (IPC) mode | Not yet documented | Post-1.2 |

---

## Recommended reading order

```
 1. Nexus theory/01 — SceneNode (what the editor edits)
 2. Nexus theory/09 — Hot reload in Crucible (editor mechanics)
 3. Nexus theory/10 — Hazel/Hazelnut split (why separate repo)
 4. Nexus Reference §9 — EditorHost API (the contract)
 5. Nexus Reference §13 — Three UI lanes (ImGui role)
 6. docs/architecture.md — This editor's architecture
 7. docs/getting-started.md — Build and run
```
