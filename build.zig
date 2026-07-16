const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ============================================================
    // T2 dependency: Nexus-engine (Cherno boundary)
    //   - Import the nexus module for types/API
    //   - Link libnexus-engine.a for the compiled engine
    // ============================================================
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
    editor_mod.linkLibrary(nexus_dep.artifact("nexus-engine"));

    const exe = b.addExecutable(.{
        .name = "link-editor",
        .root_module = editor_mod,
    });

    b.installArtifact(exe);

    // ============================================================
    // Named DAG steps for pipeline visibility.
    // build-lib must complete before the editor links the .a.
    // ============================================================
    const engine_step = b.step("build-engine",
        "Build Nexus static library (T2 — Cherno engine core)");
    engine_step.dependOn(nexus_dep.builder.step("build-lib",
        "Build libnexus-engine.a (Cherno engine core — no editor)"));

    const editor_step = b.step("build-editor",
        "Build Link-editor (links libnexus-engine.a)");
    editor_step.dependOn(&exe.step);

    const pipeline_step = b.step("pipeline",
        "Full pipeline: Nexus static lib → Link-editor");
    pipeline_step.dependOn(engine_step);
    pipeline_step.dependOn(editor_step);
    pipeline_step.dependOn(b.getInstallStep());

    b.default_step = pipeline_step;

    // ============================================================
    // Run
    // ============================================================
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("run", "Run the Link-editor");
    run_step.dependOn(&run_cmd.step);
}