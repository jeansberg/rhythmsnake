-- Responsible for spawning apples
local apples = {}
local level = require("level")
local colors = require("colors")

-- Indicates whether a position will be occupied by the snake after the next movement step
function apples.pendingSnake(x, y, pendingSnakePos)
    for _, v in pairs(pendingSnakePos) do if v.x == x and v.y == y then return true end end
    return false
end

-- Spawn an apple
function apples.spawn(grid, snake)
    local pendingSnakePos = snake.pendingPosition

    local validPoints = {}
    local count = 0
    for x = 0, 19 do
        for y = 0, 12 do
            if apples.pendingSnake(x, y, pendingSnakePos) == false then
                count = count + 1
                local point = {x = x, y = y}
                validPoints[count] = point
            end
        end
    end

    if count == 0 then
        print("No valid points")
        return
    end

    local rnd = math.random(count)
    level.addApple(grid, validPoints[rnd].x, validPoints[rnd].y)
end

-- Called from the main draw loop
function apples.draw(apple, flag)
    local x = apple.col * 40 + 50
    local y = apple.row * 40 + 120
    love.graphics.setColor(colors.pink)
    love.graphics.rectangle("fill", x, y, 40, 40)
    love.graphics.setColor(colors.black)

    local offset = flag and -4 or 4
    love.graphics.rectangle("fill", x + 4 + offset, y + 10, 10, 10)
    love.graphics.rectangle("fill", x + 26 + offset, y + 10, 10, 10)
    love.graphics.rectangle("fill", x + 10, y + 24, 20, 10)

    love.graphics.setColor(1, 1, 1, 1)
end

return apples
