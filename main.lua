local snake = require("snake")
local apples = require("apples")
local level = require("level")
local particles = require("particles")
local audio = require("audio")
local music = require("music")
local moonshine = require("moonshine")
local colors = require("colors")

local mainFont = {}
local score = 0
local state = {}
local grid = {}
local screenEffect = {}
local appleEffect = {}

local flag = false

function love.load()
    math.randomseed(os.time())
    love.window.setMode(900, 700)
    mainFont = love.graphics.newFont("mago3.ttf", 48)
    love.graphics.setFont(mainFont)
    love.graphics.print("Loading...", 320, 300, 0, 1.5)
    love.graphics.present()

    screenEffect = moonshine(moonshine.effects.crt).chain(
                       moonshine.effects.scanlines).chain(
                       moonshine.effects.chromasep)
                       .chain(moonshine.effects.glow)
    screenEffect.chromasep.radius = 3
    screenEffect.chromasep.angle = 8
    screenEffect.scanlines.opacity = 0.5
    screenEffect.scanlines.frequency = 400

    appleEffect = moonshine(moonshine.effects.glow)

    music.init()
    showMenu()
end

function showMenu() state = "start" end

function startGame()
    score = 0
    state = "running"

    screenEffect.chromasep.radius = 3
    screenEffect.chromasep.angle = 8

    music.start(hitBeat, endSong)
    level.start(grid)
    snake.start(eatApple, die, grid)
    apples.spawn(grid, snake)
    particles.start()
end

function love.update(dt)
    if state == "running" then
        music.update()
        snake.update(dt, grid)
    end
    particles.update(dt)
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
        love.graphics.rectangle("fill", 50, 130, 800, 520)

        if music.multiplier > 1 then
            local color = flag and colors.darken(colors.green) or
                              colors.darken(colors.blue)
            for i = 0, 19 do
                oddCol = i % 2 == 1
                for j = 0, 12 do
                    love.graphics.setColor(colors.gray)
                    oddRow = j % 2 == 1

                    if oddRow then
                        if oddCol and flag then
                            love.graphics.setColor(color)
                        end
                        if not oddCol and not flag then
                            love.graphics.setColor(color)
                        end
                    else
                        if oddCol and not flag then
                            love.graphics.setColor(color)
                        end
                        if not oddCol and flag then
                            love.graphics.setColor(color)
                        end
                    end

                    if grid[i][j] == "tail" then
                        -- love.graphics.setColor(1, 1, 1)
                    end

                    love.graphics.rectangle("fill", i * 40 + 50, j * 40 + 130,
                                            40, 40)
                end
            end
        end

        snake.draw(flag)

        local apple = level.getApple(grid)
        if apple then
            appleEffect(function() apples.draw(apple, flag) end)
        end

        music.draw()
        particles.draw()

        love.graphics.print("Score: " .. score, 350, 70)

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
        print(command)

        if command == "right" or command == "left" or command == "down" or
            command == "up" then
            local success = snake.setDirection(command)
            if success then music.hitKey() end
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
    score = score + music.score()

    level.clear(grid, x, y)
    particles.eatApple(x * 40 + 50, (y + 2) * 40 + 50)
    apples.spawn(grid, snake)
end

function die(x, y)
    music.endGame()
    audio.play("die")

    state = "gameover"
    particles.die(x * 40 + 50, (y + 2) * 40 + 50)
end

function hitBeat() flag = not flag end
