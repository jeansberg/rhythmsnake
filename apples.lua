local apples = {}
apples.setApple = {}

function apples.spawn(grid, setApple)
    apples.setApple = setApple
    local validPoints = {}
    local count = 0
    for i = 1, 20 do
        for j = 1, 15 do
            if grid[i][j] == 0 then
                count = count + 1
                local point = {x = i, y = j}
                validPoints[count] = point
            end
        end
    end

    local rnd = math.random(count)
    print(validPoints[rnd].x .. " " .. validPoints[rnd].y)
    setApple((validPoints[rnd]))
end

function apples.draw(apple)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", apple.col * 40, apple.row * 40, 40, 40)
    love.graphics.setColor(1, 1, 1)
end

return apples
