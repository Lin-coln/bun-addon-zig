const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // deps:node
    // const download_cmd = b.addSystemCommand(&.{"bun run deps:node"});
    // const download_step = b.step("deps:node", "prepare deps - node");
    // download_step.dependOn(&download_cmd.step);
    const node_inc = b.path("deps/node-v24.3.0/include/node");

    // addon
    const addon_root = b.createModule(.{
        .root_source_file = b.path("src/addon.zig"), // src
        .target = target,
        .optimize = optimize,
    });
    const addon = b.addLibrary(.{
        .name = "addon",
        .linkage = .dynamic, // shared library
        .version = .{ .major = 0, .minor = 0, .patch = 0 },
        .root_module = addon_root,
    });
    addon.addSystemIncludePath(node_inc);
    addon.linkLibC();
    addon.linker_allow_shlib_undefined = true;
    // addon.addObjectFile(.{ .path = "deps/node-v24.23.0/win-x64/node.lib" }); // win only

    const install_addon = b.addInstallArtifact(addon, .{ .dest_sub_path = "addon.node" });
    b.getInstallStep().dependOn(&install_addon.step);
}
