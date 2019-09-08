local level = {}

function level.start(grid)
    for x = 0, 19 do
        grid[x] = {}
        for y = 0, 12 do
            grid[x][y] = 0
        end
    end
end

function level.setSnake(grid, x, y)
    for x = 0, 19 do
        for y = 0, 12 do
            if grid[x][y] == "head" then
                grid[x][y] = 0
            end
        end
    end

    if grid[x][y] == "apple" then
        print("Moved head on apple")
    end

    grid[x][y] = "head"
end

function level.addApple(grid, x, y)
    -- if grid[x][y] ~= 0 then
    --print("Added apple to " .. x .. ", " .. y .. " -- " .. grid[x][y])
    --end
    grid[x][y] = "apple"
end

function level.clear(grid, x, y)
    grid[x][y] = 0
end

function level.getApple(grid)
    for x = 0, 19 do
        for y = 0, 12 do
            if grid[x][y] == "apple" then
                return {col = x, row = y}
            end
        end
    end
end

function level.addTail(grid, col, row)
    if grid[col][row] == "apple" then
        print("Added tail on apple" .. col .. ", " .. row)
    end

    if row == nil then
        print("row was nil")
        return
    end

    grid[col][row] = "tail"
end

function level.moveTail(grid, oldCol, oldRow, newCol, newRow)
    if grid[newCol][newRow] == "apple" then
        print("Moved tail on apple")
    end

    if oldRow == nil then
        print("oldRow was nil")
        return
    end

    grid[oldCol][oldRow] = 0
    grid[newCol][newRow] = "tail"
end

function level.collision(grid, col, row)
    local outOfBounds = col < 0 or col > 19 or row < 0 or row > 12

    if outOfBounds then
        print("Out of bounds")
        return true
    end

    if grid[col][row] == "tail" then
        print("Tail collision")
        return true
    end

    return false
end

function level.draw()
end

return level
