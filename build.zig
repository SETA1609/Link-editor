const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const nexus_dep = b.dependency("nexus_engine", .{
        .target = target,
        .optimize = optimize,
    });

    const editor_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    editor_mod.addImport("nexus", nexus_dep.module("nexus"));

    const exe = b.addExecutable(.{
        .name = "link-editor",
        .root_module = editor_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("run", "Run the Link-editor");
    run_step.dependOn(&run_cmd.step);
}
