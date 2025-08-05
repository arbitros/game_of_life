const rl = @import("raylib");
const rlm = rl.math;
const gameoflife = @import("gamelife.zig");
const std = @import("std");

const Cell = gameoflife.Cell;

pub const Ivector2 = struct {
    x: i32,
    y: i32,

    pub fn init(x: i32, y: i32) Ivector2 {
        return Ivector2{
            .x = x,
            .y = y,
        };
    }
};

pub fn GameOfLife(gridSize: usize) type {
    const GameLogic = gameoflife.gameOfLife(gridSize);
    return struct {
        const Self = @This();

        const ColorArrayType = [gridSize][gridSize]rl.Color;

        const cellSize: i32 = 20;
        game: GameLogic,
        rand: std.Random,
        colors: ColorArrayType,

        pub fn init(startingCells: []const Cell, rand: std.Random) Self {
            const colors: ColorArrayType = blk: {
                var colors_: ColorArrayType = undefined;
                for (0..gridSize) |i| {
                    for (0..gridSize) |j| {
                        colors_[i][j] = rl.Color.init(
                            rand.intRangeAtMost(u8, 1, 255),
                            rand.intRangeAtMost(u8, 1, 255),
                            rand.intRangeAtMost(u8, 1, 255),
                            1,
                        );
                    }
                }
                break :blk colors_;
            };

            std.debug.print("{any}", .{colors});

            return Self{
                .game = GameLogic.init(startingCells),
                .rand = rand,
                .colors = colors,
            };
        }

        pub fn update(self: *Self) void {
            if (rl.isKeyPressedRepeat(.space) or rl.isKeyPressed(.space)) {
                self.game.tick();
            }
        }

        pub fn draw(self: *Self) void {
            for (0..gridSize) |i| {
                for (0..gridSize) |j| {
                    if (self.game.cells[i][j] == 1) {
                        rl.drawRectangle(
                            cellSize * @as(i32, @intCast(i)),
                            cellSize * @as(i32, @intCast(j)),
                            cellSize,
                            cellSize,
                            self.colors[i][j],
                        );
                    }
                }
            }
        }
        fn randomColor(self: *const Self) rl.Color {
            return rl.Color.init(
                self.rand.intRangeAtMost(u8, 1, 255),
                self.rand.intRangeAtMost(u8, 1, 255),
                self.rand.intRangeAtMost(u8, 1, 255),
                255,
            );
        }
    };
}
