local level = require("level")
local color = {1, 0.98, 0.59, 1}

local snake = {}
local size = 40
local speed = 200
snake.pendingChild = false
snake.pendingTurn = false

snake.active = {}

snake.eatApple = {}
snake.die = {}

function snake.start(eatApple, die, grid)
    snake.rowFrac = 0
    snake.colFrac = 0
    snake.row = 0
    snake.col = 0
    snake.lastRow = 0
    snake.lastCol = 0
    snake.direction = "right"
    snake.child = nil

    snake.active = true
    snake.eatApple = eatApple
    snake.die = die
    grid[snake.row][snake.col] = "head"
end

function snake.update(dt, grid)
    if not snake.active then
        return
    end

    snake.lastCol = snake.col
    snake.lastRow = snake.row

    local delta = {}

    if snake.direction == "right" or snake.direction == "left" then
        if snake.direction == "right" then
            delta = snake.colFrac + dt * speed
            snake.col = snake.col + math.floor(delta / 40)
            snake.colFrac = delta % 40
        elseif snake.direction == "left" then
            delta = snake.colFrac + dt * speed
            snake.col = snake.col - math.floor(delta / 40)
            snake.colFrac = delta % 40
        end
    else
        if snake.direction == "down" then
            delta = snake.rowFrac + dt * speed * 0.75
            snake.row = snake.row + math.floor(delta / 30)
            snake.rowFrac = delta % 30
        elseif snake.direction == "up" then
            delta = snake.rowFrac + dt * speed * 0.75
            snake.row = snake.row - math.floor(delta / 30)
            snake.rowFrac = delta % 30
        end
    end

    if snake.lastCol ~= snake.col or snake.lastRow ~= snake.row then
        snake.pendingTurn = false
        if level.collision(grid, snake.col, snake.row) then
            print("bam!")
            snake.die()
            return
        end

        if snake.pendingChild then
            snake.addChild(grid)
        end

        snake.moveChildren(grid)

        level.clear(grid, snake.lastCol, snake.lastRow)

        if grid[snake.col][snake.row] == 0 then
            level.setSnake(grid, snake.col, snake.row)
        end

        -- Found an apple
        if grid[snake.col][snake.row] == "apple" then
            snake.eatApple(snake.col, snake.row)
            snake.pendingChild = true
        end
    end
end

function snake.addChild(grid)
    local snakeEnd = snake

    while snakeEnd.child ~= nil do
        snakeEnd = snakeEnd.child
    end

    snakeEnd.child = {col = snakeEnd.lastCol, row = snakeEnd.lastRow}
    level.addTail(grid, snakeEnd.lastCol, snakeEnd.lastRow)
    snake.pendingChild = false
end

function snake.moveChildren(grid)
    local snakeEnd = snake

    while snakeEnd.child ~= nil do
        local newCol = snakeEnd.lastCol
        local newRow = snakeEnd.lastRow

        snakeEnd = snakeEnd.child

        level.moveTail(grid, snakeEnd.col, snakeEnd.row, newCol, newRow)

        snakeEnd.lastCol = snakeEnd.col
        snakeEnd.lastRow = snakeEnd.row
        snakeEnd.col = newCol
        snakeEnd.row = newRow
    end
end

function snake.draw()
    love.graphics.setColor(color)

    if not snake.active then
        return
    end
    love.graphics.rectangle("fill", snake.col * size, snake.row * size + 80, size, size)

    local snakeEnd = snake
    while snakeEnd.child ~= nil do
        snakeEnd = snakeEnd.child

        love.graphics.rectangle("fill", snakeEnd.col * size + 5, snakeEnd.row * size + 5 + 80, size - 10, size - 10)
    end
end

function snake.setDirection(newDirection)
    if snake.pendingTurn then
        return
    end

    if snake.direction == "left" or snake.direction == "right" then
        if newDirection == "down" then
            snake.direction = "down"
            snake.rowFrac = snake.colFrac
            snake.colFrac = 0
            snake.pendingTurn = true
        elseif newDirection == "up" then
            snake.direction = "up"
            snake.rowFrac = snake.colFrac
            snake.colFrac = 0
            snake.pendingTurn = true
        end
    elseif snake.direction == "down" or snake.direction == "up" then
        if newDirection == "left" then
            snake.direction = "left"
            snake.colFrac = snake.rowFrac
            snake.rowFrac = 0
            snake.pendingTurn = true
        elseif newDirection == "right" then
            snake.direction = "right"
            snake.colFrac = snake.rowFrac
            snake.rowFrac = 0
            snake.pendingTurn = true
        end
    end
end

return snake
