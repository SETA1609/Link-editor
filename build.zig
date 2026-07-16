const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ============================================================
    // T2 dependency: Nexus-engine (provides the nexus module)
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

    const exe = b.addExecutable(.{
        .name = "link-editor",
        .root_module = editor_mod,
    });

    b.installArtifact(exe);

    // ============================================================
    // Named DAG steps for pipeline visibility.
    // The module import already creates the dependency edge;
    // these steps make the full chain visible in --summary all.
    // ============================================================
    const engine_step = b.step("build-engine",
        "Build Nexus-engine (T2)");
    engine_step.dependOn(&nexus_dep.builder.install_tls.step);

    const editor_step = b.step("build-editor",
        "Build Link-editor binary");
    editor_step.dependOn(&exe.step);

    const pipeline_step = b.step("pipeline",
        "Full pipeline: Nexus-engine → Link-editor");
    pipeline_step.dependOn(engine_step);
    pipeline_step.dependOn(editor_step);

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
