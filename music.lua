local colors = require("colors")
local audio = require("audio")
local music = {}
local lastBeat = -1
local beat = 0
local beatFrac = 0
local gracePeriod = false
local state = {}
local indicator = {x = 250, y = 660, width = 400, height = 40}

music.callback = {}

function music.start(callback)
    music.callback = callback
    audio.start()
    music.multiplier = 1
    state = "waitingForBeat"
end

function music.endGame() audio.toggleSong("gameoverSong") end

function music.update()
    local songTime = audio.getSongTime()

    beat, beatFrac = math.modf(songTime / (60 / 133))
    local newBeat = beat ~= lastBeat
    if state == "waitingForKey" then
        if newBeat then
            music.callback()
            lastBeat = beat

            state = "waitingForKey"

            if music.multiplier ~= 1 and not gracePeriod then
                music.multiplier = 1
                audio.toggleSong("passiveSong")
                audio.play("reset")
            end

            gracePeriod = false
        end
    elseif state == "waitingForBeat" then
        if newBeat then
            music.callback()
            lastBeat = beat
            state = "waitingForKey"
        end
    end
end

function music.draw()
    love.graphics.setColor(music.multiplier == 1 and colors.white or
                               colors.green)
    love.graphics.print("Multiplier: " .. music.multiplier, 650, 660)
    if gracePeriod then love.graphics.rectangle("fill", 600, 660, 40, 40) end

    love.graphics.rectangle("fill",
                            indicator.x + indicator.width / 2 * beatFrac,
                            indicator.y + indicator.height / 4,
                            indicator.width - indicator.width * beatFrac,
                            indicator.height)

    local alpha = 1.0 - beatFrac
    love.graphics.setColor(colors.fade(colors.pink, alpha))
end

function music.hitKey()
    if state == "waitingForKey" then
        state = "waitingForBeat"
        lastPos = beatFrac

        if gracePeriod == true then gracePeriod = false end
    end
end

function music.score()
    local points = 10 * music.multiplier
    music.multiplier = music.multiplier + 1
    if music.multiplier == 2 then
        audio.toggleSong("activeSong")
        gracePeriod = true
    end

    return points
end

return music
