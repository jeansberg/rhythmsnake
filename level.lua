local level = {}

function level.start(grid)
    for i = 1, 20 do
        grid[i] = {}
        for j = 1, 15 do
            grid[i][j] = 0
        end
    end
end

function level.setSnake(grid, x, y)
    for i = 1, 20 do
        for j = 1, 15 do
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
    for i = 1, 20 do
        for j = 1, 15 do
            if grid[i][j] == "apple" then
                return {col = i - 1, row = j - 1}
            end
        end
    end
end

return level
