local particles = {}
local systems = {}
local colors = require("colors")

local function initCanvas(width, height, size, color)
    local c = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(c) -- Switch to drawing on canvas 'c'
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(colors.white)
    love.graphics.rectangle("fill", width / 2, height / 2, size, size)
    love.graphics.setCanvas() -- Switch back to drawing on main screen
    love.graphics.setColor(1, 1, 1, 1)

    return c
end

function particles.start()
    systems = {}
end

function particles.eatApple(x, y)
    local img = initCanvas(40, 40, 40, colors.pink)
    local system = love.graphics.newParticleSystem(img, 100)
    system:setPosition(x, y)
    system:setEmitterLifetime(0.1)
    system:setParticleLifetime(0.5, 0.5)
    system:setEmissionRate(200)
    system:setSpread(8)
    system:setSpeed(200)
    system:setSpin(1)

    system:setColors(1, 1, 1, 1, colors.pink[1], colors.pink[2], colors.pink[3], 1, 1, 1, 1, 0)

    table.insert(systems, system)
end

function particles.die(x, y)
    local img = initCanvas(40, 40, 40, colors.purple)
    local system = love.graphics.newParticleSystem(img, 100)
    system:setPosition(x, y)
    system:setEmitterLifetime(0.4)
    system:setParticleLifetime(1, 2)
    system:setEmissionRate(100)
    system:setSpread(8)
    system:setSpeed(200)
    system:setSpin(1)
    system:setColors(1, 1, 1, 1, colors.purple[1], colors.purple[2], colors.purple[3], 1, 1, 1, 1, 0)

    table.insert(systems, system)
end

function particles.draw()
    love.graphics.setColor(1, 1, 1, 1)
    for k, v in pairs(systems) do
        love.graphics.draw(v)
    end
end

function particles.update(dt)
    for k, v in pairs(systems) do
        v:update(dt)
    end
end

return particles
