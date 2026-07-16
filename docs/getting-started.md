# Link-editor — Getting started

> **Prerequisites:** Zig 0.16+, Vulkan 1.2+ driver, Nexus Engine repo (for `EditorHost`).

---

## Build

```sh
# Clone with submodules
git clone git@github.com:SETA1609/Link-editor.git
cd Link-editor
git submodule update --init --recursive

# Build the editor
zig build

# Run
zig build run
```

## How Nexus is consumed

The editor follows the Cherno pattern: import the `nexus` module for types, link the pre-built static library for the compiled engine:

```zig
editor_mod.addImport("nexus", nexus_dep.module("nexus"));
editor_mod.linkLibrary(nexus_dep.artifact("nexus-engine"));
```

Nexus produces `libnexus-engine.a` as its primary artifact (T2). The pipeline builds the static lib before the editor links it.

---

## Dependencies

| Dependency | Source | Required | Notes |
|-----------|--------|----------|-------|
| Nexus Engine | `SETA1609/Nexus-engine` | Yes | `EditorHost`, `SceneTree`, `ResourceDB` via `nexus` module + `libnexus-engine.a` |
| zGameLib | Transitive via Nexus | Yes | Platform, Vulkan, GPU |
| Dear ImGui | zGameLib `zimgui` (`-DimGui=true`) | **Yes** | Hard dependency for Crucible |
| Flecs | Transitive via Nexus | No direct | Editor uses `EditorHost.getEcsComponents` |

---

## Project layout

```
Link-editor/
├── build.zig              # Zig build script
├── build.zig.zon          # Package manifest
├── src/
│   ├── main.zig           # Entrypoint — init Nexus + ImGui, main loop
│   ├── panels/            # Dock panel implementations
│   │   ├── scene_tree.zig
│   │   ├── inspector.zig
│   │   ├── viewport.zig
│   │   └── asset_browser.zig
│   ├── toolbar.zig        # Play/stop/build buttons
│   ├── file_watcher.zig   # OS file notification watcher
│   ├── theme.zig          # Style/color configuration
│   └── host.zig           # EditorHost client wrapper
├── docs/                  # This documentation
├── examples/              # Example editor projects (future)
└── libs/                  # Git submodules (Nexus-engine, etc.)
```

---

## Configuration

Editor settings are stored in the project's `project.nexus` file under an `[editor]` section:

```ini
[editor]
theme = "dark"
docking_enabled = true
viewport_msaa = 4
autosave_interval_sec = 60
```

---

## Usage

1. Launch the editor: `zig build run`
2. Create a new project or open an existing one.
3. The scene tree dock shows the root `Node` hierarchy.
4. Add nodes via right-click context menu.
5. Select a node to inspect/edit its properties.
6. Use the viewport to navigate the scene (orbit: middle-mouse, pan: shift+middle-mouse).
7. Press **Play** to enter play-in-editor mode.
8. Press **Stop** to exit — choose to apply or discard runtime changes.

---

## Build options

| Option | Description |
|--------|-------------|
| `-Drelease` | ReleaseFast build |
| `-Ddebug-ui` | Enable ImGui debug overlay |
| `-Dhot-shaders` | Enable shader hot reload (requires Nexus Engine support) |

---

## Learning path

1. Read this document.
2. Review [`docs/architecture.md`](architecture.md) for the editor design.
3. Read the Nexus Engine [`Nexus_Reference.md` §9](https://github.com/SETA1609/Nexus-engine/blob/main/docs/Nexus_Reference.md#9-link-editor-tier-3-interaction) for the `EditorHost` API.
4. Walk the theory ladder: [`docs/theory/README.md`](theory/README.md).
5. Explore the [Nexus Engine theory docs](https://github.com/SETA1609/Nexus-engine/tree/main/docs/theory) for engine-side design.
