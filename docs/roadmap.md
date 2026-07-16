# Link-editor roadmap

> **Official name:** **Link-editor** (alias: *Crucible*, Tier 3).  
> **Consumes:** Nexus Engine v1.0.0+ with `EditorHost` API frozen.  
> **UI framework:** Dear ImGui via `zgame.zimgui` (late Tier 1 module).

The editor roadmap is aligned with the [Nexus Engine ROADMAP](https://github.com/SETA1609/Nexus-engine/blob/main/docs/ROADMAP.md). Crucible ships **after** the engine is feature-complete enough to need a visual editor.

---

## Milestones

### v0.0.1 — Bootstrap

**Goal:** Repo builds, links Nexus Engine, opens ImGui window.

- [ ] `build.zig` with Nexus Engine as a dependency
- [ ] `src/main.zig` — init Nexus context + ImGui, main loop
- [ ] Empty ImGui window with docking enabled
- [ ] File watcher stub (OS notifications skeleton)
- [ ] Legal scaffold: `LICENSE`, `NOTICE`

**Documentation:**
- [x] `docs/` — architecture, getting-started, roadmap, theory path

**Dependency gate:** Nexus Engine v1.0.0 shipped, zGameLib `zimgui` shipped.

---

### v1.1.0 — Editor core

**Goal:** Usable scene editing.

- [ ] Scene tree dock — displays `SceneNode` hierarchy, drag reparent, add/delete
- [ ] Inspector dock — property editing with undo/redo
- [ ] Viewport dock — scene render, orbit/pan/zoom camera
- [ ] Gizmo — translate/rotate/scale (ImGuizmo or custom)
- [ ] Play/pause/stop toolbar with play-in-editor
- [ ] Asset browser dock — thumbnail grid, drag-to-scene
- [ ] File watcher → `EditorHost.reimport`, `EditorHost.reloadScene`
- [ ] Editor settings panel
- [ ] `.ini` docking layout persistence

**Documentation:**
- [ ] Panel API docs
- [ ] EditorHost client guide

**Engine gate:** Nexus Engine v1.1.0+, `EditorHost` with scene mutation + play mode.

---

### v1.2.0 — Localization tooling

**Goal:** Support the localization pipeline in the editor.

- [ ] `.po` file editor or integration with external editors
- [ ] Locale preview — switch locale, see scene text change
- [ ] Compile locale button → triggers Nexus Engine `.po`→JSON build
- [ ] Locale heatmap — which strings are untranslated

**Documentation:**
- [ ] Locale editing workflow
- [ ] Reference: Nexus Engine `LocalizationSystem`

**Engine gate:** Nexus Engine v1.2.0, `LocalizationSystem` shipped.

---

### Post-1.2 — Stretch goals

- **Multi-viewport:** split view, 2D/3D side by side
- **Shader editor:** basic material graph or GLSL editing
- **Timeline/animation editor**
- **Tilemap editor**
- **Detached mode:** editor in separate process (IPC)
- **Dark/light theme switching** with live preview
- **Plugin system** for custom editor panels

---

## Dependency alignment

| Crucible version | Requires Nexus Engine | Requires zGameLib |
|------------------|----------------------|-------------------|
| v0.0.1 | v1.0.0 | v1.0.x + `zimgui` |
| v1.1.0 | v1.1.0+ | v1.1.x + `zimgui` |
| v1.2.0 | v1.2.0+ | v1.1.x + `zimgui` |

---

See also: [Nexus Engine ROADMAP](https://github.com/SETA1609/Nexus-engine/blob/main/docs/ROADMAP.md) for the full 3-tier version context.
