local songtimer = require("songtimer")
local snake = require("snake")
local apples = require("apples")
local score = 0
local beats = 0
local clicked = false
local grid = {}
local apple = nil

function love.load()
    math.randomseed(os.time())
    songtimer.start(1, scoreFn)

    for i = 1, 20 do
        grid[i] = {}
        for j = 1, 15 do
            grid[i][j] = 0
        end
    end

    snake.start(eatApple, grid)
    apples.spawn(grid, setApple)
end

function love.update(dt)
    songtimer.update(dt)
    snake.update(dt, grid)
end

function love.draw()
    --love.graphics.print("Score: " .. score, 200, 200)
    --love.graphics.print("Beats: " .. beats, 400, 200)
    snake.draw()

    if apple.col then
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

function eatApple()
    apple = {}
    print("Ate apple")
end

function setApple(point)
    print("apple: " .. point.x .. ", " .. point.y)
    apple = {}
    apple.row = point.y
    apple.col = point.x
    grid[point.x + 1][point.y + 1] = "apple"
end
