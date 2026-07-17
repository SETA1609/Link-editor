const std = @import("std");
const engine = @import("engine_interface");

pub fn main() !void {
    const factory = @extern(engine.EngineFactory, .{ .name = "createEngineInterface" });
    var iface = factory();
    errdefer iface.deinit();

    try iface.init(.{
        .title = "Link-editor (Crucible)",
        .width = 1600,
        .height = 900,
    });

    while (!iface.shouldClose()) {
        try iface.tick();
    }
}
