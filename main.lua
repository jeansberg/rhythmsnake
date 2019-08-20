local snake = require("snake")
local apples = require("apples")
local level = require("level")
local particles = require("particles")
local music = require("music")
local moonshine = require("moonshine")

local darkgreen = {0.005, 0.25, 0.1575}
local darkergreen = {0.0025, 0.125, 0.07875}
local darkblue = {0, 0.40, 0.5}
local black = {0, 0, 0}

local mainFont = {}
local score = 0
local running = true
local beats = 0
local clicked = false
local grid = {}
local screenEffect = {}
local glowEffect = {}

local flag = false

function love.load()
    math.randomseed(os.time())
    love.window.setMode(900, 700)
    mainFont = love.graphics.newFont("mago3.ttf", 48)
    love.graphics.setFont(mainFont)
    screenEffect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.crt)
    screenEffect.chromasep.radius = 2
    screenEffect.chromasep.angle = 4

    glowEffect = moonshine(moonshine.effects.glow)
    startGame()
end

function startGame()
    score = 0
    running = true

    music.start(hitBeat)
    level.start(grid)
    snake.start(eatApple, die, grid)
    apples.spawn(grid)
    particles.start()
end

function love.update(dt)
    if running then
        music.update()
        snake.update(dt, grid)
    end
    particles.update(dt)
end

function love.draw()
    screenEffect(
        function()
            for i = 0, 19 do
                for j = 0, 12 do
                    if j % 2 == 1 then
                        if i % 2 == 1 then
                            love.graphics.setColor(flag and darkergreen or darkgreen)
                        else
                            love.graphics.setColor(flag and darkgreen or darkergreen)
                        end
                    else
                        if i % 2 == 1 then
                            love.graphics.setColor(flag and darkgreen or darkergreen)
                        else
                            love.graphics.setColor(flag and darkergreen or darkgreen)
                        end
                    end

                    love.graphics.rectangle("fill", i * 40 + 50, j * 40 + 130, 40, 40)
                end
            end
            love.graphics.setColor(1, 1, 1, 1)

            snake.draw(flag)

            local apple = level.getApple(grid)
            if apple then
                glowEffect(
                    function()
                        apples.draw(apple, flag)
                    end
                )
            end

            --love.graphics.rectangle("line", 50, 80, 800, 570)
            particles.draw()
            if running then
                love.graphics.print("Score: " .. score, 350, 70)
            else
                love.graphics.print("Game over!", 340, 220)
                love.graphics.print("Score: " .. score, 350, 260)
                love.graphics.print("Press any key to restart", 220, 300)
            end
        end
    )
end

function love.keypressed(key, scancode, isrepeat)
    if running then
        if key == "right" or key == "left" or key == "down" or key == "up" then
            snake.setDirection(key)
        end
    else
        startGame()
    end
end

function eatApple(x, y)
    score = score + 100
    level.clear(grid, x, y)
    particles.eatApple(x * 40 + 50, (y + 2) * 40 + 50)
    apples.spawn(grid)
end

function die(x, y)
    music.stop()
    running = false
    particles.die(x * 40 + 50, (y + 2) * 40 + 50)
end

function hitBeat()
    flag = not flag
end
