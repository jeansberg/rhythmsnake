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

    if grid[x][y] == "apple" then
        print("Moved head on apple")
    end

    grid[x][y] = "head"
end

function level.addApple(grid, x, y)
    print("Added apple to " .. x .. ", " .. y .. " -- " .. grid[x][y])
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
    if grid[col][row] == "apple" then
        print("Added tail on apple")
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
        return true
    end

    return grid[col][row] == "tail"
end

function level.nonTailAdjacent(grid, col, row)
    local numAdjacent = 0
    for i = col - 2, col + 2 do
        for j = row - 2, row + 2 do
            if grid[i][j] == "tail" then
                numAdjacent = numAdjacent + 1
            end
        end
    end

    print(numAdjacent)
    return numAdjacent == 0
end

return level
