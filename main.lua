local snake = require("snake")
local apples = require("apples")
local level = require("level")
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

    level.start(grid)
    snake.start(eatApple, die, grid)
    apples.spawn(grid)
end

function love.update(dt)
    if running then
        snake.update(dt, grid)
    else
        if love.keyboard.isDown("return") then
            startGame()
        end
    end
end

function love.draw()
    if running then
        love.graphics.print("Score: " .. score, 300, 20)
        love.graphics.rectangle("line", 0, 80, 800, 520)

        love.graphics.setColor(color)

        snake.draw()

        local apple = level.getApple(grid)
        if apple then
            apples.draw(apple)
        end
    else
        love.graphics.print("Game over!", 290, 220)
        love.graphics.print("Score: " .. score, 300, 260)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "right" or key == "left" or key == "down" or key == "up" then
        snake.setDirection(key)
    end
end

function eatApple(x, y)
    print("Ate apple")
    score = score + 100
    level.clear(grid, x, y)
    apples.spawn(grid)
end

function die()
    running = false
    print("Died")
end
