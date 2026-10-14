const std = @import("std");

const Cli = struct {
    pattern: []const u8,
    path: []const u8,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 3) {
        std.debug.print("Usage: zig-grep <pattern> <filepath>\n", .{});
        return error.InvalidArguments;
    }

    const cli = Cli{
        .pattern = args[1],
        .path = args[2],
    };

    const file = try std.Io.Dir.cwd().openFile(io, cli.path, .{});
    defer file.close(io);

    std.debug.print("pattern: {s}\n", .{cli.pattern});
    std.debug.print("path: {s}\n", .{cli.path});

    var reader_buffer: [4096]u8 = undefined;
    var file_reader = file.reader(io, &reader_buffer);
    const reader = &file_reader.interface;

    try grep(reader);
}

// TODO: grepの中身の理解
fn grep(reader: *std.Io.Reader) !void {
    var buffer: [4096]u8 = undefined;
    var start: usize = 0;
    var end: usize = 0;

    while (true) {
        const data = buffer[start..end];
        if (std.mem.indexOfScalar(u8, data, '\n')) |pos| {
            const newline_index = start + pos;
            const line = buffer[start..newline_index];

            std.debug.print("line: {s}\n", .{line});

            start = newline_index + 1;
            continue;
        }

        const remaining = end - start;
        std.mem.copyForwards(
            u8,
            buffer[0..remaining],
            buffer[start..end],
        );

        start = 0;
        end = remaining;

        if (end == buffer.len) {
            return error.LineTooLong;
        }

        const n = try reader.readSliceShort(buffer[end..]);

        if (n == 0) {
            if (start < end) {
                const line = buffer[start..end];
                std.debug.print("line: {s}\n", .{line});
            }
            break;
        }

        end += n;
    }
}
//
// fn processLine(line: []const u8, pattern: []const u8) void {
//     // 部分一致を調べる
//     // 一致した行を出力する
// }
