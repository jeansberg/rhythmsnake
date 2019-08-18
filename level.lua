local level = {}

function level.start(grid)
    for i = 0, 19 do
        grid[i] = {}
        for j = 0, 12 do
            grid[i][j] = 0
        end
    end
end

function level.setSnake(grid, x, y)
    for i = 0, 19 do
        for j = 0, 12 do
            if grid[i][j] == "head" then
                grid[i][j] = 0
            end
        end
    end
    grid[x][y] = "head"
end

function level.addApple(grid, x, y)
    grid[x][y] = "apple"
end

function level.clear(grid, x, y)
    grid[x][y] = 0
end

function level.getApple(grid)
    for i = 0, 19 do
        for j = 0, 12 do
            if grid[i][j] == "apple" then
                return {col = i, row = j}
            end
        end
    end
end

function level.addTail(grid, col, row)
    grid[col][row] = "tail"
end

function level.moveTail(grid, oldCol, oldRow, newCol, newRow)
    grid[oldCol][oldRow] = 0
    grid[newCol][newRow] = "tail"
end

function level.collision(grid, col, row)
    local outOfBounds = col < 0 or col > 19 or row < 0 or row > 12

    if outOfBounds then
        return true
    end

    return grid[col][row] == "tail"
end

return level
