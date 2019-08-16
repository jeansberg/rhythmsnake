local songtimer = require("songtimer")

local timer = {}
local score = 0

function love.load()
    timer = songtimer.new(1)
    timerstart()
end

function love.update(dt)
    if timer:update(dt) then
    end
end

function love.draw()
    love.graphics.print("Score " .. score, 100, 100)
    if waiting then
        love.graphics.print("Click!", 200, 200)
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 and waiting and not clicked then
        clicked = true
        score = score + 10
    end
end
