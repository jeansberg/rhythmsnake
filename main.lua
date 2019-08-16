local songtimer = require("songtimer")
local snake = require("snake")
local apples = require("apples")
local level = require("level")
local score = 0
local beats = 0
local clicked = false
local grid = {}

function love.load()
    math.randomseed(os.time())
    songtimer.start(1, scoreFn)

    level.start(grid)
    snake.start(eatApple, grid)
    apples.spawn(grid)
end

function love.update(dt)
    songtimer.update(dt)
    snake.update(dt, grid)
end

function love.draw()
    snake.draw()

    local apple = level.getApple(grid)
    if apple then
        apples.draw(apple)
    end
end

function scoreFn()
    beats = beats + 1
    if not clicked then
        score = 0
    end

    clicked = false
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 and not clicked then
        score = score + 1
        clicked = true
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "right" or key == "left" or key == "down" or key == "up" then
        snake.setDirection(key)
    end
end

function eatApple(x, y)
    print("Ate apple")
    level.clear(grid, x, y)
end
