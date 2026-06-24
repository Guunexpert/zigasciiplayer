const std = @import("std");

const ma_engine = opaque {};
const MA_SUCCESS = 0;

pub extern fn ma_engine_init(pConfig: ?*anyopaque, pEngine: *ma_engine) c_int;
pub extern fn ma_engine_uninit(pEngine: *ma_engine) void;
pub extern fn ma_engine_play_sound(pEngine: *ma_engine, pFilePath: [*c]const u8, pGroup: ?*anyopaque) c_int;

pub fn main() !void {
    // ma_engine with stack buffer
    var raw_ctx: [4096]u8 align(8) = undefined;
    const sound = @as(*ma_engine, @ptrCast(&raw_ctx));

    if (ma_engine_init(null, sound) != MA_SUCCESS) {
        std.debug.print("failed initialize audio\n", .{});
        return;
    }
    defer ma_engine_uninit(sound);
    if (ma_engine_play_sound(sound, "bad_apple.mp3", null) != MA_SUCCESS) { //you can change mp3 song here
        std.debug.print("failed to load song\n", .{});
        return;
    }

    const file = try std.fs.cwd().openFile("bad_apple_all.txt", .{}); //and you can change the txt too :) containing big ascii
    defer file.close();

    // memory allocation based on file
    const file_size = (try file.stat()).size;
    const raw_byte = try std.heap.page_allocator.alloc(u8, file_size);
    defer std.heap.page_allocator.free(raw_byte); // end program clearing
    _ = try file.readAll(raw_byte);

    var frames = std.mem.splitSequence(u8, raw_byte, "SPLIT");
    var timer = try std.time.Timer.start();

    const target_fps = 15; // change your fps here based on your ascii txt and extracting frames from ffmpeg
    const ns_per_frame: u64 = std.time.ns_per_s / target_fps;
    var count: u64 = 0;

    while (frames.next()) |raw_frame| {
        const frame = std.mem.trim(u8, raw_frame, "\r\n");
        if (frame.len == 0) continue;

        count += 1;
        const target = count * ns_per_frame;
        const current = timer.read();

        if (current < target) {
            std.time.sleep(target - current);
        }

        const diff: i64 = @intCast(current);
        const delta = @divTrunc(diff - @as(i64, @intCast(target)), std.time.ns_per_ms);
        
        std.debug.print("\x1B[2J\x1B[H{s}\n--------------------------------------------------\nzig ascii, frame: {d}, delta: {d} ms\n", .{ 
            frame, 
            count, 
            delta 
        });
    }

    std.debug.print("\nEND HERE\n", .{});
}
