local snake = require("snake")
local apples = require("apples")
local level = require("level")
local score = 0
local beats = 0
local clicked = false
local grid = {}

function love.load()
    math.randomseed(os.time())

    level.start(grid)
    snake.start(eatApple, die, grid)
    apples.spawn(grid)
end

function love.update(dt)
    snake.update(dt, grid)
end

function love.draw()
    love.graphics.print(score, 700, 0)
    snake.draw()

    local apple = level.getApple(grid)
    if apple then
        apples.draw(apple)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "right" or key == "left" or key == "down" or key == "up" then
        snake.setDirection(key)
    end
end

function eatApple(x, y)
    print("Ate apple")
    score = score + 1
    level.clear(grid, x, y)
    apples.spawn(grid)
end

function die()
    print("Died")
    score = 0
    level.start(grid)
    snake.start(eatApple, die, grid)
    apples.spawn(grid)
end
