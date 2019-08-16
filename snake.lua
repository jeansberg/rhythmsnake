local level = require("level")

local snake = {}
local size = 40
local speed = 200
snake.pendingChild = false

snake.rowFrac = 0
snake.colFrac = 0
snake.row = 0
snake.col = 0
snake.direction = "right"
snake.active = {}

snake.eatApple = {}

function snake.start(eatApple, grid)
    snake.active = true
    snake.eatApple = eatApple
    grid[snake.row][snake.col] = "head"
end

function snake.update(dt, grid)
    if not snake.active then
        return
    end

    local lastHeadCol = snake.col
    local lastHeadRow = snake.row

    local delta = {}

    if snake.direction == "right" or snake.direction == "left" then
        if snake.direction == "right" then
            delta = snake.colFrac + dt * speed
            snake.col = math.min(19, snake.col + math.floor(delta / 40))
            snake.colFrac = delta % 40
        elseif snake.direction == "left" then
            delta = snake.colFrac + dt * speed
            snake.col = math.max(0, snake.col - math.floor(delta / 40))
            snake.colFrac = delta % 40
        end
    else
        if snake.direction == "down" then
            delta = snake.rowFrac + dt * speed * 0.75
            snake.row = math.min(14, snake.row + math.floor(delta / 30))
            snake.rowFrac = delta % 30
        elseif snake.direction == "up" then
            delta = snake.rowFrac + dt * speed * 0.75
            snake.row = math.max(0, snake.row - math.floor(delta / 30))
            snake.rowFrac = delta % 30
        end
    end

    if lastHeadCol ~= snake.col or lastHeadRow ~= snake.row then
        if snake.pendingChild then
            local tail = snake

            repeat
                tail = tail.child
            until tail.child == nil

            tail.child = {x = tail.lastX, y = tail.lastY}

            do
            end
        end

        level.clear(grid, lastHeadCol, lastHeadRow)

        -- Move each child to the last position of its parent

        if grid[snake.col][snake.row] == 0 then
            level.setSnake(grid, snake.col, snake.row)
        end

        if grid[snake.col][snake.row] == "apple" then
            snake.eatApple(snake.col, snake.row)
            pendingChild = true
        end

    -- move children as well
    end
end

function snake.draw()
    if not snake.active then
        return
    end

    love.graphics.rectangle("fill", snake.col * size, snake.row * size, size, size)
end

function snake.setDirection(newDirection)
    if snake.direction == "left" or snake.direction == "right" then
        if newDirection == "down" then
            snake.direction = "down"
            snake.rowFrac = snake.colFrac
            snake.colFrac = 0
        elseif newDirection == "up" then
            snake.direction = "up"
            snake.rowFrac = snake.colFrac
            snake.colFrac = 0
        end
    elseif snake.direction == "down" or snake.direction == "up" then
        if newDirection == "left" then
            snake.direction = "left"
            snake.colFrac = snake.rowFrac
            snake.rowFrac = 0
        elseif newDirection == "right" then
            snake.direction = "right"
            snake.colFrac = snake.rowFrac
            snake.rowFrac = 0
        end
    end
end

return snake
