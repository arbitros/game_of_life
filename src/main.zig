const rl = @import("raylib");
const rlm = rl.math;
const gameoflife = @import("api.zig");
const gameRules = @import("gamelife.zig");
const std = @import("std");

const Cell = gameRules.Cell;
const Ivector2 = gameoflife.Ivector2;

pub fn main() anyerror!void {
    const screenWidth = 1440;
    const screenHeight = 1200;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    const startingCells1: [58]Cell = .{
        // Pulsar
        Cell.init(33, 31), Cell.init(34, 31), Cell.init(35, 31), Cell.init(39, 31), Cell.init(40, 31), Cell.init(41, 31),
        Cell.init(31, 33), Cell.init(36, 33), Cell.init(38, 33), Cell.init(43, 33), Cell.init(31, 34), Cell.init(36, 34),
        Cell.init(38, 34), Cell.init(43, 34), Cell.init(31, 35), Cell.init(36, 35), Cell.init(38, 35), Cell.init(43, 35),
        Cell.init(33, 36), Cell.init(34, 36), Cell.init(35, 36), Cell.init(39, 36), Cell.init(40, 36), Cell.init(41, 36),
        Cell.init(33, 38), Cell.init(34, 38), Cell.init(35, 38), Cell.init(39, 38), Cell.init(40, 38), Cell.init(41, 38),
        Cell.init(31, 39), Cell.init(36, 39), Cell.init(38, 39), Cell.init(43, 39), Cell.init(31, 40), Cell.init(36, 40),
        Cell.init(38, 40), Cell.init(43, 40), Cell.init(31, 41), Cell.init(36, 41), Cell.init(38, 41), Cell.init(43, 41),
        Cell.init(33, 43), Cell.init(34, 43), Cell.init(35, 43), Cell.init(39, 43), Cell.init(40, 43), Cell.init(41, 43),

        // Glider
        Cell.init(11, 10), Cell.init(12, 11), Cell.init(10, 12), Cell.init(11, 12), Cell.init(12, 12),

        // THE INTERCEPTOR
        //
        Cell.init(10, 40),
        Cell.init(9, 40),  Cell.init(8, 40),  Cell.init(10, 41), Cell.init(9, 42),
    };

    const startingCells2: [10]Cell = .{
        Cell.init(32, 32),
        Cell.init(31, 32),
        Cell.init(31, 33),
        Cell.init(32, 33),
        Cell.init(31, 31),
        Cell.init(30, 30),
        Cell.init(33, 34),
        Cell.init(32, 34),
        Cell.init(31, 34),
        Cell.init(30, 31), //spinner
    };
    _ = startingCells2;

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const GameType = gameoflife.GameOfLife(64);

    var game = GameType.init(&startingCells1, rand);

    while (!rl.windowShouldClose()) {
        game.update();

        rl.beginDrawing();

        rl.clearBackground(.white);
        game.draw();

        defer rl.endDrawing();
    }
}
