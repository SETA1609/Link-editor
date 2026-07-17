# Engine plugins

Pre-built engine static libraries (.a / .lib) go here. The editor links
whichever engine it finds in this directory.

## Usage

Build a compliant engine (one that exports `createEngineInterface`) and copy
its static library here:

```sh
# Build Nexus-engine
cd ../engine && zig build build-lib

# Copy the static lib into the editor's plugin directory
cp zig-out/lib/libnexus-engine.a ../editor/plugins/
```

## On macOS / Windows

The same idea applies — place `.dylib` or `.lib` here as appropriate for
your platform.
