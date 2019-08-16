local level = {}

function level.start(grid)
    for i = 0, 19 do
        grid[i] = {}
        for j = 0, 14 do
            grid[i][j] = 0
        end
    end
end

function level.setSnake(grid, x, y)
    for i = 0, 19 do
        for j = 0, 14 do
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
        for j = 0, 14 do
            if grid[i][j] == "apple" then
                return {col = i, row = j}
            end
        end
    end
end

return level
