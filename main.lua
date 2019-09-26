local snake = require("snake")

Debugging = false
local apples = require("apples")
local level = require("level")
local particles = require("particles")
local audio = require("audio")
local musicManager = require("musicManager")
local messageManager = require("messageManager")
local moonshine = require("lib/moonshine")
local colors = require("colors")

local mainFont = {}
local state = {}
local grid = {}
local screenEffect = {}
local appleEffect = {}

local flag = false
local phase = 0
local descending = false

function love.load()
    math.randomseed(os.time())
    love.window.setMode(900, 700)
    love.window.setTitle("Rhythm Snake")
    mainFont = love.graphics.newFont("content/mago3.ttf", 48)
    love.graphics.setFont(mainFont)
    love.graphics.print("Loading...", 320, 300, 0, 1.5)
    love.graphics.present()

    screenEffect = moonshine(moonshine.effects.crt).chain(moonshine.effects.scanlines)
                       .chain(moonshine.effects.chromasep).chain(moonshine.effects.glow)
    screenEffect.chromasep.radius = 3
    screenEffect.chromasep.angle = 8
    screenEffect.scanlines.opacity = 0.5
    screenEffect.scanlines.frequency = 400

    appleEffect = moonshine(moonshine.effects.glow)

    audio.init()
    musicManager.init(newBeat, messageManager)
    snake.init(eatApple, die)
    showMenu()
end

IfDebug = function(fn) if Debugging then fn() end end

function showMenu() state = "start" end

function startGame()
    state = "running"

    screenEffect.chromasep.radius = 3
    screenEffect.chromasep.angle = 8

    musicManager.start()
    level.start(grid)
    snake.start(grid)
    apples.spawn(grid, snake)
    particles.start()
end

function love.update(dt)
    if state == "running" then
        musicManager.update()
        snake.update(dt, grid)
    end
    messageManager.update(dt)
    particles.update(dt)

    if descending then
        phase = phase - dt * 5
    else
        phase = phase + dt * 5
    end

    if phase <= 180 then
        descending = false
    end

    if phase >= 180 then
        descending = true
    end

     screenEffect.scanlines.phase = phase
end

function love.draw()
    screenEffect(function()
        love.graphics.print("Rhythm Snake", 260, 10, 0, 1.5)

        if state == "start" then
            love.graphics.print("Goal: Eat apples", 300, 200, 0)
            love.graphics.print("Controls: Arrow keys or WASD", 190, 250, 0)
            love.graphics.print("Press SPACE to start", 270, 350)
            return
        end
        local oddRow = false
        local oddCol = false
        love.graphics.setColor(colors.gray)
        love.graphics.rectangle("fill", 50, 120, 800, 520)

        if musicManager.multiplier > 1 then
            local color = flag and colors.darken(colors.green) or colors.darken(colors.blue)
            for i = 0, 19 do
                oddCol = i % 2 == 1
                for j = 0, 12 do
                    love.graphics.setColor(colors.gray)
                    oddRow = j % 2 == 1

                    if oddRow then
                        if oddCol and flag then love.graphics.setColor(color) end
                        if not oddCol and not flag then love.graphics.setColor(color) end
                    else
                        if oddCol and not flag then love.graphics.setColor(color) end
                        if not oddCol and flag then love.graphics.setColor(color) end
                    end

                    love.graphics.rectangle("fill", i * 40 + 50, j * 40 + 120, 40, 40)
                end
            end
        end

        snake.draw(flag)

        local apple = level.getApple(grid)
        if apple then appleEffect(function() apples.draw(apple, flag) end) end

        musicManager.draw()
        particles.draw()
        messageManager.draw()

        love.graphics.setColor(colors.white)
        love.graphics.print("Score: " .. musicManager.points, 350, 70)
        IfDebug(function() love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10) end)

        if state == "running" then
        else
            love.graphics.print("Game over!", 340, 220)
            love.graphics.print("Press SPACE to restart", 240, 300)
        end
    end)
end

function getCommand(key)
    if key == "w" then
        return "up"
    elseif key == "a" then
        return "left"
    elseif key == "s" then
        return "down"
    elseif key == "d" then
        return "right"
    end

    return key
end

function love.keypressed(key, _, _)
    local command = getCommand(key)

    if state == "running" then
        if command == "right" or command == "left" or command == "down" or command == "up" then
            snake.setDirection(command)
            musicManager.directionChange()
        end
    elseif state == "gameover" then
        if command == "space" then
            startGame()
        else
            audio.play("bang")
            particles.random()
        end
    elseif state == "start" then
        if command == "space" then startGame() end
    end
end

function eatApple(x, y)
    audio.play("eatApple")
    musicManager.increaseScore()

    level.clear(grid, x, y)
    particles.eatApple(x * 40 + 50, (y + 2) * 40 + 50)
    messageManager.eatApple(x * 40 + 50, (y + 2) * 40 + 50)
    apples.spawn(grid, snake)
end

function die(x, y)
    musicManager.endGame()
    audio.play("die")

    state = "gameover"
    particles.die(x * 40 + 50, (y + 2) * 40 + 50)
end

function newBeat() flag = not flag  end
