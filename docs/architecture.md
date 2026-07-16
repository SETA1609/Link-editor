# Link-editor architecture

> **Alias:** Crucible.  
> **Role:** Tier 3 — detachable immediate-mode editor for Nexus Engine.  
> **Consumes:** `EditorHost` API (Nexus Engine v1.0.0+).  
> **UI framework:** Dear ImGui (hard dependency).  
> **No direct Flecs linkage** — ECS introspection via `EditorHost.getEcsComponents`.

---

## High-level design

```ascii
┌──────────────────────────────────────────────────────┐
│                    CRUCIBLE (editor)                   │
│                                                        │
│  ┌────────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Scene Tree │  │ Inspector│  │ Viewport (gizmo)  │  │
│  │ Dock       │  │ Dock     │  │ Dock              │  │
│  └─────┬──────┘  └────┬─────┘  └────────┬─────────┘  │
│        │              │                  │            │
│  ┌─────┴──────────────┴──────────────────┴─────────┐  │
│  │              EditorHost (client)                 │  │
│  │  getSceneTree · getSelection · setProperty       │  │
│  │  beginUndoTransaction · playInEditor             │  │
│  └──────────────────────┬──────────────────────────┘  │
└─────────────────────────┼────────────────────────────┘
                          │ (in-process calls)
┌─────────────────────────▼────────────────────────────┐
│              NEXUS ENGINE (Tier 2)                     │
│  EditorHost (impl) · SceneTree · ResourceDB · EcsBridge│
└──────────────────────────────────────────────────────┘
```

### Key architectural decisions

| Decision | Rationale |
|----------|-----------|
| **Separate binary** | Editor is a standalone executable linking `libnexus-engine.a` (Cherno model). Engine ships games without editor. |
| **Same-process** | Editor and runtime share one process. Avoids IPC, serialization, sync complexity. |
| **Immediate-mode UI** | Dear ImGui — panels rebuilt every frame. Naturally hot-reloadable, no retained widget tree. |
| **EditorHost boundary** | All editor→engine communication through a documented API. No direct access to engine internals. |
| **No direct Flecs** | Editor inspects ECS via `EditorHost.getEcsComponents`. The adapter is swappable without editor changes. |
| **SceneTree fork for play** | Play mode clones the scene; editor tree stays editable. Changes can be applied or discarded. |

---

## Dock panels

### Scene tree dock

- Displays full `SceneNode` hierarchy from `EditorHost.getSceneTree()`.
- Drag-and-drop reparenting, multi-select, filtering.
- Right-click context menu: add node, delete, duplicate, copy/paste.

### Inspector dock

- Reads/writes `SceneNode` properties via `EditorHost.setProperty` / direct read.
- Type-aware editors: float sliders, color pickers, resource pickers, enum dropdowns.
- Undo/redo via `EditorHost.beginUndoTransaction` / `commitUndoTransaction`.
- ECS component view when bridge is active (read-only by default).

### Viewport dock

- Renders the active scene through Nexus Engine's `RenderingServer`.
- Gizmo for translate/rotate/scale (ImGuizmo or custom).
- Camera controls: orbit, pan, zoom.
- Grid, selection outline, debug draw overlay.

### Asset browser dock

- Browses the project's resource tree via `EditorHost` resource queries.
- Thumbnail previews, drag-to-scene instantiation.
- Import settings editor for `.fimport` sidecars.

### Toolbar

- Play / pause / step / stop buttons.
- Build (trigger `zig build`) and run.
- Locale switching (v1.2.0+).

---

## EditorHost API

The `EditorHost` is implemented in Nexus Engine and consumed by Crucible. The full contract is defined in [Nexus_Reference.md §9](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md#9-link-editor-tier-3-interaction):

```zig
const EditorHost = struct {
    getSceneTree: *fn () *SceneTree,
    getSelection: *fn () []NodeId,
    setProperty: *fn (node: NodeId, name: []const u8, value: Variant) Error!void,
    beginUndoTransaction: *fn (label: []const u8) TransactionId,
    playInEditor: *fn () Error!void,
    stopInEditor: *fn () void,
    getEcsComponents: ?*fn (node: NodeId) []ComponentView,
};
```

---

## Play-in-editor

See [Nexus Engine theory/09 → Play-in-editor](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md#play-in-editor-as-hot-reload) for full design.

1. **Same-process** — game runs inside editor, no IPC.
2. **SceneTree fork** — snapshot via `PackedScene`, play mutates clone.
3. **Shared ResourceDB** — both editor and play mode see same loaded resources.
4. **Apply or discard** — on stop, merge changes back or restore snapshot.

---

## UI model

Crucible follows the **three UI lanes** defined in Nexus Engine:

| Lane | Technology | When |
|------|-----------|------|
| Editor (T3) | Dear ImGui (required) | Crucible — panels, inspector, gizmos |
| In-game (T2) | zGameLib 2D batcher | HUD, menus, Control nodes |
| Debug (T2/opt) | ImGui OR debug draw | `debug-ui` example (v0.8.0) |

Crucible **never draws in-game UI**. It edits scene data only.

---

## Hot reload

Crucible is both consumer and driver of hot reload:

- **Consumer**: file watcher → `EditorHost.reimport` / `reloadScene` / `reloadLocale`.
- **Driver**: "Reimport" button, inspector property writes, locale compile triggers.
- **Editor UI**: ImGui is naturally hot-reloadable — every frame is a fresh draw.

Full design: [theory/09-hot-reload-crucible.md](https://github.com/SETA1609/Nexus-engine/blob/main/docs/theory/09-hot-reload-crucible.md).

---

## Comparison with other editors

| Feature | Godot | Unity | Unreal | Crucible |
|---------|-------|-------|--------|----------|
| UI toolkit | Custom retained | UIToolkit / IMGUI | Slate | Dear ImGui |
| Play mode | Same-process | Same-process | PIE / SIE | Same-process, scene fork |
| Editor ↔ runtime comm | Built-in | AssetDatabase | FDirectoryWatcher | EditorHost API |
| ECS introspection | N/A (no ECS) | DOTS debugger | Not built-in | Via EditorHost |
| Detachable | No | Editor is external | Editor is separate | Yes — separate binary |
