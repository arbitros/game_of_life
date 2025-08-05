const rl = @import("raylib");
const rlm = rl.math;
const std = @import("std");

pub fn gameOfLife(gridSize: usize) type {
    const GridType = [gridSize][gridSize]u2;

    return struct {
        const Self = @This();

        cells: GridType,

        pub fn init(startingCells: []const Cell) Self {
            var cells = std.mem.zeroes(GridType);

            for (startingCells) |cell| {
                cells[cell.x][cell.y] = 1;
            }

            return Self{ .cells = cells };
        }
        pub fn tick(self: *Self) void {
            var newCells: GridType = self.cells;
            for (0..gridSize) |i| {
                for (0..gridSize) |j| {
                    newCells[i][j] = @intFromBool(self.checkState(Cell.init(i, j)));
                }
            }
            self.cells = newCells;
        }

        fn checkState(self: *Self, cell: Cell) bool { //fix out of bounds problem. maybe helper function
            var cnt: u8 = 0;
            if (inBounds(cell)) {
                cnt += self.cells[cell.x - 1][cell.y - 1]; //clockwise circle starting for bottom left
                cnt += self.cells[cell.x - 1][cell.y];
                cnt += self.cells[cell.x - 1][cell.y + 1];
                cnt += self.cells[cell.x][cell.y + 1];
                cnt += self.cells[cell.x + 1][cell.y + 1];
                cnt += self.cells[cell.x + 1][cell.y];
                cnt += self.cells[cell.x + 1][cell.y - 1];
                cnt += self.cells[cell.x][cell.y - 1];

                if (self.cells[cell.x][cell.y] == 1) {
                    return cnt >= 2 and cnt <= 3;
                } else {
                    return cnt == 3;
                }
            }
            return false;
        }

        fn inBounds(cell: Cell) bool {
            if (cell.x > 0 and cell.x < gridSize - 1) {
                if (cell.y > 0 and cell.y < gridSize - 1) {
                    return true;
                }
            }
            return false;
        }
    };
}

pub const Cell = struct {
    x: usize,
    y: usize,

    pub fn init(x: usize, y: usize) Cell {
        return Cell{
            .x = x,
            .y = y,
        };
    }
};
