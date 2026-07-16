const std = @import("std");
const nexus = @import("nexus");

pub fn main() !void {
    var app = try nexus.NexusApp.init(.{
        .title = "Link-editor (Crucible)",
        .width = 1600,
        .height = 900,
    });
    defer app.deinit();

    while (!app.shouldClose()) {
        try app.tick();
    }
}
