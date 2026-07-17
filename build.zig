const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ============================================================
    // Engine plugin — pre-built .a / .lib from a compliant engine
    // (e.g. Nexus) placed in plugins/ by the user or the bundle
    // orchestrator. Symbols are found via @extern at link time.
    // EngineInterface contract from ../contract/engine_interface.zig
    // ============================================================
    const editor_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    editor_mod.addImport("engine_interface", b.createModule(.{
        .root_source_file = b.path("../contract/engine_interface.zig"),
        .target = target,
        .optimize = optimize,
    }));

    const exe = b.addExecutable(.{
        .name = "link-editor",
        .root_module = editor_mod,
    });
    exe.root_module.addObjectFile(b.path("plugins/libnexus-engine.a"));

    b.installArtifact(exe);

    // ============================================================
    // Named DAG steps
    // ============================================================
    const editor_step = b.step("build-editor",
        "Build Link-editor (links engine plugin from plugins/)");
    editor_step.dependOn(&exe.step);

    const pipeline_step = b.step("pipeline",
        "Build Link-editor (requires a pre-built engine .a in plugins/)");
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
