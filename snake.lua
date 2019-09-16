local level = require("level")
local colors = require("colors")

local snake = {}
local size = 40
local speed = 266
snake.pendingChild = nil
snake.pendingTurn = false
snake.pendingPosition = {}

snake.active = {}

snake.eatApple = {}
snake.die = {}

function snake.start(eatApple, die, grid)
    snake.rowFrac = 0
    snake.colFrac = 0
    snake.row = 6
    snake.col = 9
    snake.lastRow = 0
    snake.lastCol = 0
    snake.lastDirection = "right"

    snake.direction = "right"

    level.setSnake(grid, snake.col, snake.row)
    snake.child = {col = snake.col - 1, row = snake.row}
    level.addTail(grid, snake.child.col, snake.child.row)
    local child = snake.child

    child.child = {col = child.col - 1, row = child.row}
    level.addTail(grid, child.child.col, child.child.row)

    table.insert(snake.pendingPosition, {x = 10, y = 6})
    table.insert(snake.pendingPosition, {x = 9, y = 6})
    table.insert(snake.pendingPosition, {x = 8, y = 6})

    snake.active = true
    snake.eatApple = eatApple
    snake.die = die
    grid[snake.row][snake.col] = "head"
end

function snake.update(dt, grid)
    if not snake.active then return end

    snake.lastCol = snake.col
    snake.lastRow = snake.row
    snake.lastDirection = snake.direction

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
            snake.col = snake.lastCol
            snake.row = snake.lastRow
            snake.die(snake.col, snake.row)
            snake.active = false
            return
        end

        snake.pendingPosition = {}
        local nextHeadPos = {x = snake.col, y = snake.row}
        local direction = snake.direction

        if direction == "left" then
            nextHeadPos.x = nextHeadPos.x - 1
        elseif direction == "right" then
            nextHeadPos.x = nextHeadPos.x + 1
        elseif direction == "up" then
            nextHeadPos.y = nextHeadPos.y - 1
        elseif direction == "down" then
            nextHeadPos.y = nextHeadPos.y + 1
        end

        table.insert(snake.pendingPosition, nextHeadPos)

        if snake.pendingChild ~= nil then
            snake.addChild(grid, snake.pendingChild)
        end

        snake.moveChildren(grid)

        if grid[snake.col][snake.row] == 0 then
            level.setSnake(grid, snake.col, snake.row)
        end

        if grid[snake.col][snake.row] == "apple" then
            local snakeEnd = snake

            while snakeEnd.child ~= nil do snakeEnd = snakeEnd.child end

            snake.pendingChild = snakeEnd
            table.insert(snake.pendingPosition,
                         {x = snakeEnd.col, y = snakeEnd.row})
            snake.eatApple(snake.col, snake.row)
        end
    end
end

function snake.addChild(grid, snakeEnd)
    snakeEnd.child = {
        col = snakeEnd.col,
        row = snakeEnd.row,
        direction = snakeEnd.direction
    }
    level.addTail(grid, snakeEnd.col, snakeEnd.row)
    snake.pendingChild = nil
end

function snake.moveChildren(grid)
    local snakeEnd = snake

    while snakeEnd.child ~= nil do
        local newCol = snakeEnd.lastCol
        local newRow = snakeEnd.lastRow
        local newDirection = snakeEnd.lastDirection

        table.insert(snake.pendingPosition, {x = snakeEnd.col, y = snakeEnd.row})

        snakeEnd = snakeEnd.child

        level.moveTail(grid, snakeEnd.col, snakeEnd.row, newCol, newRow)

        snakeEnd.lastCol = snakeEnd.col
        snakeEnd.lastRow = snakeEnd.row
        snakeEnd.lastDirection = snakeEnd.direction

        snakeEnd.col = newCol
        snakeEnd.row = newRow

        snakeEnd.direction = newDirection
    end
end

function snake.drawHead()
    local x = snake.col * size + 50
    local y = snake.row * size + 80 + 50

    love.graphics.rectangle("fill", x, y, size, size)
    love.graphics.setColor(colors.black)
end

function snake.draw(flag)
    love.graphics.setColor(colors.purple)

    if not snake.active then return end

    snake.drawHead()
    love.graphics.setColor(colors.purple)

    local snakeEnd = snake
    while snakeEnd.child ~= nil do
        snakeEnd = snakeEnd.child

        local tailX = snakeEnd.col * size + 5 + 50
        local tailY = snakeEnd.row * size + 5 + 80 + 50
        if snakeEnd.child == nil then
            tailX, tailY = snake.wiggle(tailX, tailY, snakeEnd.direction, flag)
        end

        love.graphics.rectangle("fill", tailX, tailY, size - 10, size - 10)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function snake.wiggle(x, y, direction, flag)
    if flag then
        -- wiggle right
        if direction == "left" then
            y = y - 10
        elseif direction == "right" then
            y = y + 10
        elseif direction == "up" then
            x = x + 10
        elseif direction == "down" then
            x = x - 10
        end
    else
        -- wiggle left
        if direction == "left" then
            y = y + 10
        elseif direction == "right" then
            y = y - 10
        elseif direction == "up" then
            x = x - 10
        elseif direction == "down" then
            x = x + 10
        end
    end

    return x, y
end

function snake.setDirection(newDirection)
    if snake.pendingTurn then return end

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
        else
            return false
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
        else
            return false
        end
    end

    return true
end

return snake
