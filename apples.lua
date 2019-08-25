local level = require("level")
local color = {255 / 255, 113 / 255, 206 / 255}

local apples = {}

function apples.spawn(grid)
    local validPoints = {}
    local count = 0
    for i = 0, 19 do
        for j = 0, 12 do
            if grid[i][j] == 0 then
                count = count + 1
                local point = {x = i, y = j}
                validPoints[count] = point
            end
        end
    end

    local rnd = math.random(count)
    --print(validPoints[rnd].x .. " " .. validPoints[rnd].y)
    level.addApple(grid, validPoints[rnd].x, validPoints[rnd].y)
end

function apples.draw(apple, flag)
    local x = apple.col * 40 + 50
    local y = apple.row * 40 + 80 + 50
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, 40, 40)
    love.graphics.setColor(0, 0, 0)

    local offset = flag and -4 or 4
    love.graphics.rectangle("fill", x + 4 + offset, y + 10, 10, 10)
    love.graphics.rectangle("fill", x + 26 + offset, y + 10, 10, 10)
    love.graphics.rectangle("fill", x + 10, y + 24, 20, 10)

    love.graphics.setColor(1, 1, 1, 1)
end

return apples
