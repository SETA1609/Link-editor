# Link-editor Roadmap

> **Official name:** **Link-editor** (alias: *Crucible*, Tier 3).  
> **Consumes:** Nexus Engine v1.0.0+ with `EditorHost` API frozen.  
> **UI framework:** Dear ImGui via `zgame.zimgui` (late Tier 1 module).

The editor roadmap is aligned with the [Nexus Engine ROADMAP](https://github.com/SETA1609/Nexus-engine/blob/main/docs/ROADMAP.md) and the [Bundle coordination ROADMAP](https://github.com/SETA1609/Link_and_nexus_bundle/blob/main/ROADMAP.md).

**2D-first rule:** Crucible launches with **2D-native editing** — pan/zoom viewport, `Node2D` / `Sprite2D` inspectors, sprite atlases — because the first shippable game is 2D. **3D viewport and orbit camera** ship at editor **v2.0.0** after Nexus opens the 3D track.

**Priority legend:** **🎯** supports first 2D game workflow · **🔧** editor-only · **⏳** post–first 2D ship

Crucible ships **after** Nexus v1.0.0 freezes `EditorHost` — the 2D game ships without the editor.

---

## Strategic alignment

| Pillar | Crucible role |
|--------|---------------|
| **2D editing** | Scene tree, 2D viewport, sprite/asset workflow at v1.1.0 🎯 |
| **Data-driven** | File watcher → `EditorHost.reimport` / `reloadScene` 🎯 |
| **Hot reload** | Drive Nexus `ReloadEventBus`; play-in-editor scene fork 🎯 |
| **WASM modding** | Hide compilation; templates + Build Mod + Test Mod at v1.1.1 🎯 |
| **Localization** | `.po` preview + compile button at v1.2.0 🔧 |
| **3D editing** | Orbit viewport, mesh inspector at v2.0.0 ⏳ |

**Architectural decisions (fixed):**

- Separate binary linking Nexus as a library ([theory/10](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/10-hazel-hazelnut-split.md))
- Same-process `EditorHost` calls — no IPC at launch
- Immediate-mode Dear ImGui — no retained widget tree
- No direct Flecs linkage — ECS via `EditorHost.getEcsComponents`
- WASM toolchain abstraction — modders never invoke `wasm32` flags manually ([theory/13](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/13-wasm-modding.md))

---

## Milestones

| Version | Priority | Goal | Proving deliverable |
|---------|----------|------|---------------------|
| **v0.0.1** | 🔧 | Bootstrap | Empty ImGui window + Nexus link |
| **v1.1.0** | 🎯 | **2D editor core** | Edit `minimal-2d-game` scene in viewport |
| **v1.1.1** | 🎯 | **Mod tooling** | Build + hot-reload a WASM mod |
| **v1.2.0** | 🔧 | Localization | Locale preview + `.po` workflow |
| **v2.0.0** | ⏳ | 3D viewport | Orbit camera + `Node3D` gizmo |
| **v2.1.0** | ⏳ | Net debug | GNS session panel (stretch) |

---

### v0.0.1 — Bootstrap 🔧

**Goal:** Repo builds, links Nexus Engine, opens ImGui window.

- [ ] `build.zig` with Nexus Engine as a dependency
- [ ] `src/main.zig` — init Nexus context + ImGui, main loop
- [ ] Empty ImGui window with docking enabled
- [ ] File watcher stub (OS notifications skeleton)
- [ ] Legal scaffold: `LICENSE`, `NOTICE`

**Documentation:**

- [x] `docs/` — architecture, getting-started, roadmap, theory path

**Dependency gate:** Nexus Engine v1.0.0 shipped, zGameLib `zimgui` shipped.

**Example:** none — proves `zig build` + window open.

---

### v1.1.0 — 2D editor core 🎯

**Goal:** Usable **2D** scene editing for the first shipped game and follow-on content.

- [ ] Scene tree dock — `Node2D` / `Sprite2D` / `Camera2D` hierarchy; drag reparent; add/delete
- [ ] Inspector dock — 2D property editing (transform, sprite texture, visibility) with undo/redo
- [ ] **2D viewport dock** — orthographic scene render; **pan + zoom** (not orbit)
- [ ] **2D gizmo** — translate (rotate/scale stretch for 2D)
- [ ] Grid + snap; selection outline
- [ ] Play/pause/stop toolbar with play-in-editor (scene fork)
- [ ] Asset browser dock — **texture + atlas thumbnails**; drag `Sprite2D` into scene
- [ ] File watcher → `EditorHost.reimport`, `EditorHost.reloadScene`
- [ ] Editor settings panel
- [ ] `.ini` docking layout persistence
- [ ] Stretch: **tilemap paint mode** for `TileMapLayer` (if Nexus v1.0.0 ships tilemaps)

**Documentation:**

- [ ] Panel API docs
- [ ] EditorHost client guide
- [ ] 2D editing workflow (viewport, assets, play mode)

**Engine gate:** Nexus Engine v1.1.0+, `EditorHost` with scene mutation + play mode.

**Proving workflow:** Open `minimal-2d-game` project → edit sprite positions → play-in-editor → see changes.

**Deferred to v2.0.0 ⏳:** orbit camera, 3D gizmo, mesh inspector, multi-viewport 2D/3D split.

---

### v1.1.1 — WASM mod tooling 🎯

**Goal:** Abstract WASM compilation so modders iterate on the **2D game** without toolchain knowledge.

- [ ] **New Mod Project** wizard — Zig / Rust templates ([theory/13](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/13-wasm-modding.md))
- [ ] **Data-only mod** template — `mod.json` + `data/` overrides, no `.wasm`
- [ ] **Build Mod** button (Ctrl+B) — spawn compiler subprocess; capture errors in panel
- [ ] **Test Mod** button — `EditorHost.reloadMod` → Nexus `ModManager.reload`
- [ ] Mod list panel — enabled/disabled, version, dependency warnings
- [ ] Output console — structured WASM compile + runtime log with mod prefix

**Documentation:**

- [ ] Mod authoring guide (Zig template first)
- [ ] Data-only mod guide (locale overrides, JSON tables)

**Engine gate:** Nexus v1.0.0 `WasmHost` + v1.1.1 `reloadMod` on `EditorHost`.

**Proving workflow:** Create Zig mod → spawn extra `Sprite2D` → edit mod → Test Mod → hot reload.

---

### v1.2.0 — Localization tooling 🔧

**Goal:** Support the localization pipeline for the 2D game and mods.

- [ ] `.po` file editor or integration with external editors
- [ ] Locale preview — switch locale, see scene text change
- [ ] Compile locale button → triggers Nexus Engine `.po`→JSON build
- [ ] Locale heatmap — which strings are untranslated
- [ ] Mod locale overrides — merge `data/locale/` from mod packages

**Documentation:**

- [ ] Locale editing workflow
- [ ] Reference: Nexus Engine `LocalizationSystem`

**Engine gate:** Nexus Engine v1.2.0, `LocalizationSystem` shipped.

**Proving workflow:** Edit `.po` → compile → preview in 2D viewport → ship locale in build.

---

### v2.0.0 — 3D editor ⏳

**Goal:** Edit Nexus v2.x 3D scenes after the 2D game has shipped.

- [ ] **3D viewport** — orbit, pan, zoom; perspective camera
- [ ] 3D gizmo — translate / rotate / scale on `Node3D`
- [ ] Mesh / material inspector
- [ ] Optional: multi-viewport (2D + 3D side by side)

**Engine gate:** Nexus Engine v2.0.0+, `Node3D` / `Camera3D`.

---

### Post-2.0 — Stretch goals ⏳

- **Shader editor:** basic material graph or GLSL editing (3D materials)
- **Timeline / animation editor** — sprite tracks first; skeletal later
- **Detached mode:** editor in separate process (IPC)
- **Dark/light theme switching** with live preview
- **Plugin system** for custom editor panels
- **Net debug panel** — GNS session stats when Nexus v2.2.0 lands

---

## Dependency alignment

| Link-editor version | Requires Nexus Engine | Requires zGameLib | Priority |
|---------------------|----------------------|-------------------|----------|
| v0.0.1 | v1.0.0 | v1.1.x + `zimgui` | 🔧 |
| v1.1.0 | v1.1.0+ | v1.1.x + `zimgui` | 🎯 |
| v1.1.1 | v1.1.1+ (mod API) | v1.1.x + `zimgui` | 🎯 |
| v1.2.0 | v1.2.0+ | v1.1.x + `zimgui` | 🔧 |
| v2.0.0 | v2.0.0+ | v2.0.x + `zimgui` | ⏳ |

---

## 2D vs 3D feature matrix

| Feature | v1.1.0 (2D ship) | v2.0.0 (post-ship) |
|---------|------------------|---------------------|
| Viewport camera | Orthographic pan/zoom | + Perspective orbit |
| Scene nodes | `Node2D`, `Sprite2D`, `Camera2D` | + `Node3D`, meshes |
| Gizmo | 2D translate (stretch: rotate/scale) | Full 3D TRS |
| Asset browser | Textures, atlases | + glTF, materials |
| Tilemap editor | Stretch at v1.1.0 | Mature tool |
| Mod tooling | v1.1.1 WASM + data mods | Same pipeline |
| Networking UI | — | Net debug panel ⏳ |

---

## Cross-tier timeline

```ascii
Nexus 1.0.0 minimal-2d-game 🎯
    │
    ├──► zGameLib 1.1.0 zimgui
    │
    └──► Link-editor 1.1.0 2D editor core 🎯
              │
              └──► 1.1.1 mod build UI 🎯
                        │
Nexus 1.2.0 i18n ───────┴──► Link-editor 1.2.0 locale panels
                                    │
Nexus 2.0.0 3D ⏳ ──────────────────┴──► Link-editor 2.0.0 3D viewport ⏳
```

---

## See also

- [Nexus Engine ROADMAP](https://github.com/SETA1609/Nexus-engine/blob/main/docs/ROADMAP.md)
- [Bundle ROADMAP](https://github.com/SETA1609/Link_and_nexus_bundle/blob/main/ROADMAP.md)
- [zGameLib ROADMAP](https://github.com/SETA1609/zGameLib/blob/main/docs/ROADMAP.md)
- [Architecture](architecture.md) · [EditorHost §9](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md)
- [WASM modding](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/13-wasm-modding.md)
- [Hot reload (Crucible)](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md)