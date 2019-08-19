local snake = require("snake")
local apples = require("apples")
local level = require("level")
local particles = require("particles")
local music = require("music")
local mainFont = {}
local color = {0.02, 1, 0.63, 3}
local score = 0
local running = true
local beats = 0
local clicked = false
local grid = {}

function love.load()
    math.randomseed(os.time())
    love.window.setMode(800, 600)
    mainFont = love.graphics.newFont("mago3.ttf", 48)
    love.graphics.setFont(mainFont)

    startGame()
end

function startGame()
    score = 0
    running = true

    music.start()
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
    music.draw()
    love.graphics.setColor(color)

    snake.draw()

    local apple = level.getApple(grid)
    if apple then
        apples.draw(apple)
    end
    love.graphics.rectangle("line", 0, 80, 800, 520)

    particles.draw()
    if running then
        love.graphics.print("Score: " .. score, 300, 20)
    else
        love.graphics.print("Game over!", 290, 220)
        love.graphics.print("Score: " .. score, 300, 260)
        love.graphics.print("Press any key to restart", 200, 300)
    end
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
    particles.eatApple(x * 40, (y + 2) * 40)
    apples.spawn(grid)
end

function die(x, y)
    music.stop()
    running = false
    particles.die(x * 40, (y + 2) * 40)
end
