local particles = {}
local systems = {}
local appleColor = {1, 0.44, 0.91, 1}
local snakeColor = {1, 0.98, 0.59, 1}

local function initCanvas(width, height, size, color)
    local c = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(c) -- Switch to drawing on canvas 'c'
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", width / 2, height / 2, size, size)
    love.graphics.setCanvas() -- Switch back to drawing on main screen
    love.graphics.setColor(1, 1, 1, 1)

    return c
end

function particles.start()
    systems = {}
end

function particles.eatApple(x, y)
    local img = initCanvas(40, 40, 10, appleColor)
    local system = love.graphics.newParticleSystem(img, 100)
    system:setPosition(x, y)
    system:setEmitterLifetime(0.1)
    system:setParticleLifetime(0.5, 0.5)
    system:setEmissionRate(100)
    system:setSpread(8)
    system:setSpeed(200)
    system:setColors(1, 1, 1, 1, 1, 1, 1, 0)

    table.insert(systems, system)
end

function particles.die(x, y)
    local img = initCanvas(40, 40, 40, snakeColor)
    local system = love.graphics.newParticleSystem(img, 100)
    system:setPosition(x, y)
    system:setEmitterLifetime(0.1)
    system:setParticleLifetime(1, 1)
    system:setEmissionRate(100)
    system:setSpread(8)
    system:setSpeed(200)
    system:setColors(1, 1, 1, 1, 1, 1, 1, 0)

    table.insert(systems, system)
end

function particles.draw()
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
