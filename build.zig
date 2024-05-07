const std = @import("std");

pub fn build(b: *std.Build) void {
    // Set the name and root source file for the executable
    const exe = b.addExecutable(.{
        .name = "contact_management",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    // Add the contact.zig and database.zig files as dependencies using addPackage
    exe.addPackage("contact", .{
        .root = "src/contact.zig",
    });
    exe.addPackage("database", .{
        .root = "src/database.zig",
    });

    // Install the executable
    b.installArtifact(exe);

    // Allow running the executable with `zig build run`
    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the contact management application");
    run_step.dependOn(&run_cmd.step);
}
