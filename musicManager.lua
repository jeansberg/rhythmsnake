-- Responsible for keeping track of the beat and all other rhythm elements
local musicManager = {multiplier = 1, points = 0, state = {}}
local colors = require("colors")
local audio = require("audio")
local smallHeart = {}
local bigHeart = {}
local lastBeat = -1
local beat = 0
local beatFrac = 0
local hitFrac = 0
local beatMargin = {}
local gracePeriod = false
local indicatorZone = {x = 250, y = 660, width = 400, height = 40}

function scale(num, destMin, destMax, sourceMin, sourceMax)
    return (destMax - destMin) * (num - sourceMin) / (sourceMax - sourceMin) + destMin
end

function lerp(a, b, t) return a * (1 - t) + b * t end

function musicManager.createWaitingForKeyState()
    -- print("Waitforkey")
    return {
        enter = function() end,
        hit = function(beatMargin)
            local beatRating = {}
            if beatMargin < 0.2 then
                beatRating = "Great"
            elseif beatMargin < 0.4 then
                beatRating = "Good"
            elseif beatMargin < 0.6 then
                beatRating = "Ok"
            else
                -- IfDebug(function() print("Hit too late") end)
                musicManager.missBeat()
                musicManager.state = musicManager.createWaitingForBeatState()
                return
            end
            -- IfDebug(function() print("Hit") end)
            musicManager.messageManager.hitBeat(beatRating)
            if gracePeriod == true then gracePeriod = false end
            musicManager.state = musicManager.createWaitingForBeatState()
        end,
        newBeat = function()
            IfDebug(function() print("Beat") end)
            if not gracePeriod then
                musicManager.missBeat()
                musicManager.state = musicManager.createWaitingForBeatState()
            else
                gracePeriod = false
            end
        end
    }
end

function musicManager.createWaitingForBeatState()
    print("Waitforbeat")
    return {
        hit = function()
            -- IfDebug(function() print("Hit at wrong time") end)
            musicManager.missBeat()
        end,
        newBeat = function()
            IfDebug(function() print("Beat") end)
            musicManager.state = musicManager.createWaitingForKeyState()
        end
    }
end

function musicManager.inWindow() return beatMargin > 0 end

-- Initializes the module with a callback to indicate when a new beat is hit
function musicManager.init(newBeat, messageManager)
    musicManager.newBeatCallback = newBeat
    musicManager.messageManager = messageManager
    smallHeart = love.graphics.newImage("content/smallheart.png")
    bigHeart = love.graphics.newImage("content/bigheart.png")
end

-- Reset the music and state
function musicManager.start()
    gracePeriod = false
    musicManager.points = 0
    musicManager.multiplier = 1
    audio.start()
    musicManager.state = musicManager.createWaitingForBeatState()
end

-- Toggles the song to the "game over" phase
function musicManager.endGame() audio.toggleSongPhase("gameover") end

-- Called by the main update loop
function musicManager.update()
    -- Shared logic
    local songTime = audio.getSongTime()
    beat, beatFrac = math.modf(songTime / (60 / 133))
    beatMargin = 0.5 - beatFrac
    local isNewBeat = beat ~= lastBeat
    if isNewBeat then
        musicManager.state.newBeat()
        musicManager.newBeatCallback()
        lastBeat = beat
    end
end

-- Draws the graphics indicating when the player needs to change direction
function drawIndicator(beatFrac)
    local leftBracketStart = indicatorZone.x
    local leftBracketEnd = indicatorZone.x + indicatorZone.width / 2 - 10 - 24

    local rightBracketStart = indicatorZone.x + indicatorZone.width - 10
    local rightBracketEnd = indicatorZone.x + indicatorZone.width / 2 + 24

    if musicManager.inWindow() then
        love.graphics.setColor(colors.pink)
        love.graphics.draw(bigHeart, indicatorZone.x + indicatorZone.width / 2 - 24, indicatorZone.y - 17, 0, 3, 3)
    else
        local linearCoeff = scale(beatFrac, 0, 1, 0.5, 1)
        local leftBracketPos = lerp(leftBracketStart, leftBracketEnd, linearCoeff)
        local rightBracketPos = lerp(rightBracketStart, rightBracketEnd, linearCoeff)

        love.graphics.setColor(colors.white)
        love.graphics.rectangle("fill", leftBracketPos, indicatorZone.y - 12, 10, indicatorZone.height + 7)
        love.graphics.rectangle("fill", rightBracketPos, indicatorZone.y - 12, 10, indicatorZone.height + 7)

        love.graphics.setColor(colors.pink)
        love.graphics.draw(smallHeart, indicatorZone.x + indicatorZone.width / 2 - 24, indicatorZone.y - 17, 0, 3, 3)
    end
end

-- Called from the main draw loop
function musicManager.draw()
    love.graphics.setColor(musicManager.multiplier == 1 and colors.white or colors.green)
    IfDebug(function()
        love.graphics.print(hitFrac, 100, 100)
        if gracePeriod then love.graphics.print("grace", 100, 120) end
    end)
    love.graphics.print("Multiplier: " .. musicManager.multiplier, 650, 660)

    drawIndicator(beatFrac)
end

-- Called when the snake direction is successfully changed
function musicManager.directionChange()
    hitFrac = beatFrac
    musicManager.state.hit(beatMargin)
end

-- Increments the score and raises the multiplier
function musicManager.increaseScore()
    musicManager.points = musicManager.points + 10 * musicManager.multiplier
    musicManager.multiplier = musicManager.multiplier + 1

    -- Going from multiplier 1 to 2 activates the more action-packed song phase and also enables a grace period
    if musicManager.multiplier == 2 then
        audio.toggleSongPhase("active")
        gracePeriod = true
    end
end

function musicManager.missBeat()
    -- IfDebug(function() print("Miss") end)
    if musicManager.multiplier > 1 then
        musicManager.multiplier = 1
        audio.play("reset")
    end
    audio.toggleSongPhase("passive")
    musicManager.messageManager.missBeat()
end

return musicManager
