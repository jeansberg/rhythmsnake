local level = require("level")

local apples = {}

function apples.spawn(grid)
    local validPoints = {}
    local count = 0
    for i = 0, 19 do
        for j = 0, 14 do
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

function apples.draw(apple)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", apple.col * 40, apple.row * 40, 40, 40)
    love.graphics.setColor(1, 1, 1)
end

return apples
