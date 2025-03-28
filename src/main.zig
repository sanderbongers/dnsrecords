const std = @import("std");

const RecordType = enum {
    A,
    AAAA,
    MX,
    NS,
    SOA,
    TXT,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() != .ok) @panic("leak");
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        const stderr = std.io.getStdErr().writer();
        try stderr.print("Usage: {s} <domain>\n", .{args[0]});
        std.process.exit(1);
    }

    const domain = args[1];
    const record_types = [_]RecordType{ .A, .AAAA, .NS, .SOA, .MX, .TXT };

    for (record_types) |record_type| {
        try lookupAndPrintRecord(allocator, domain, record_type);
    }
}

fn lookupAndPrintRecord(allocator: std.mem.Allocator, domain: []const u8, record_type: RecordType) !void {
    const stdout = std.io.getStdOut().writer();
    const record_type_str = @tagName(record_type);

    const args = [_][]const u8{ "dig", "+nocmd", "+noall", "+answer", domain, record_type_str };

    const result = try runCommand(allocator, &args);
    defer allocator.free(result);

    if (result.len > 0) {
        try stdout.writeAll(result);
        if (result[result.len - 1] != '\n') {
            try stdout.writeByte('\n');
        }
    }
}

fn runCommand(allocator: std.mem.Allocator, args: []const []const u8) ![]u8 {
    var child = std.process.Child.init(args, allocator);
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Pipe;

    try child.spawn();

    const output = try child.stdout.?.reader().readAllAlloc(allocator, 1024);
    errdefer allocator.free(output);

    const term = try child.wait();

    switch (term) {
        .Exited => |code| {
            if (code != 0) {
                allocator.free(output);
                return error.CommandFailed;
            }
        },
        else => {
            allocator.free(output);
            return error.CommandFailed;
        },
    }

    return output;
}
