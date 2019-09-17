-- Responsible for keeping track of the beat and all other rhythm elements
local musicManager = {multiplier = 1, points = 0}
local colors = require("colors")
local audio = require("audio")
local lastBeat = -1
local beat = 0
local beatFrac = 0
local gracePeriod = false
local indicatorZone = {x = 250, y = 660, width = 400, height = 40}
local state = {}

-- Initializes the module with a callback to indicate when a new beat is hit
function musicManager.init(newBeat) musicManager.newBeat = newBeat end

-- Reset the music and state
function musicManager.start()
    gracePeriod = false
    musicManager.points = 0
    musicManager.multiplier = 1
    audio.start()
    state = "waitingForBeat"
end

-- Toggles the song to the "game over" phase
function musicManager.endGame() audio.toggleSongPhase("gameover") end

-- Called by the main update loop
function musicManager.update()
    local songTime = audio.getSongTime()

    beat, beatFrac = math.modf(songTime / (60 / 133))
    local isNewBeat = beat ~= lastBeat
    if state == "waitingForKey" then
        if isNewBeat then
            musicManager.newBeat()
            lastBeat = beat

            state = "waitingForKey"

            if musicManager.multiplier ~= 1 and not gracePeriod then
                musicManager.multiplier = 1
                audio.toggleSongPhase("passive")
                audio.play("reset")
            end

            gracePeriod = false
        end
    elseif state == "waitingForBeat" then
        if isNewBeat then
            musicManager.newBeat()
            lastBeat = beat
            state = "waitingForKey"
        end
    end
end

-- Called from the main draw loop
function musicManager.draw()
    love.graphics.setColor(musicManager.multiplier == 1 and colors.white or colors.green)
    love.graphics.print("Multiplier: " .. musicManager.multiplier, 650, 660)
    if gracePeriod then love.graphics.rectangle("fill", 600, 660, 40, 40) end

    love.graphics.rectangle("fill", indicatorZone.x + indicatorZone.width / 2 * beatFrac,
                            indicatorZone.y + indicatorZone.height / 4,
                            indicatorZone.width - indicatorZone.width * beatFrac, indicatorZone.height)

    local alpha = 1.0 - beatFrac
    love.graphics.setColor(colors.fade(colors.pink, alpha))
end

-- Called when the snake direction is successfully changed
function musicManager.directionChange()
    if state == "waitingForKey" then
        state = "waitingForBeat"
        if gracePeriod == true then gracePeriod = false end
    end
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

return musicManager
