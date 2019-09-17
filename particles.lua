-- Responsible for managing particle effects
local particles = {}
local systems = {}
local colors = require("colors")

-- Creates a canvas to draw particle systems on
local function initCanvas(width, height, size)
    local c = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(c) -- Switch to drawing on canvas 'c'
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(colors.white)
    love.graphics.rectangle("fill", width / 2, height / 2, size, size)
    love.graphics.setCanvas() -- Switch back to drawing on main screen
    love.graphics.setColor(1, 1, 1, 1)
    return c
end

-- Clears the list of particle systems
function particles.start() systems = {} end

-- Creates a new particle system and adds it to the list of active systems
function particles.createSystem(x, y, emitterLifetime, particleLifetimeMin, particleLifetimeMax, spread, rate, color)
    local img = initCanvas(40, 40, 40)
    local system = love.graphics.newParticleSystem(img, 100)

    system:setPosition(x, y)
    system:setEmitterLifetime(emitterLifetime)
    system:setParticleLifetime(particleLifetimeMin, particleLifetimeMax)
    system:setEmissionRate(rate)
    system:setSpread(spread)
    system:setSpeed(200)
    system:setSpin(1)
    system:setColors(1, 1, 1, 1, color[1], color[2], color[3], 1, 1, 1, 1, 0)

    table.insert(systems, system)
end

-- Factory methods for specific types of particle systems
function particles.eatApple(x, y) particles.createSystem(x, y, 0.1, 0.5, 0.5, 8, 200, colors.pink) end
function particles.die(x, y) particles.createSystem(x, y, 0.4, 1, 2, 8, 100, colors.purple) end
function particles.special(x, y) particles.createSystem(x, y, 0.1, 1, 2, 8, 100, colors.yellow) end

-- Creates a random type of particle effect at a random point
function particles.random()
    local type = math.random(0, 1)
    local x = math.random(0, 900)
    local y = math.random(0, 700)

    if type == 0 then
        particles.special(x, y)
    elseif type == 1 then
        particles.eatApple(x, y)
    end
end

-- Called from the main draw loop
function particles.draw()
    love.graphics.setColor(1, 1, 1, 1)
    for k, v in pairs(systems) do love.graphics.draw(v) end
end

-- Called from the main update loop
function particles.update(dt) for k, v in pairs(systems) do v:update(dt) end end

return particles
