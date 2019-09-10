local colors = require("colors")
local music = {}
local passivePath = "psy_passive.ogg"
local activePath = "psy_active.ogg"
local activeLoop = {}
local passiveLoop = {}
local lastBeat = -1
local beat = 0
local beatFrac = 0
local lastPos = -1
local gracePeriod = false
local state = {}
local indicator = {x = 250, y = 660, width = 400, height = 40}
local resetSfx = {}

music.callback = {}
music.endSong = {}


function music.crossFadeTo(song)
    if song == "active" then
        passiveLoop:setVolume(0)
        activeLoop:setVolume(1)
    else
        passiveLoop:setVolume(1)
        activeLoop:setVolume(0)
    end
end

function music.init()
    resetSfx = love.audio.newSource("reset.wav", "static")
    activeLoop = love.audio.newSource(activePath, "static")
    activeLoop:setLooping(true)
    activeLoop:setVolume(0)
    passiveLoop = love.audio.newSource(passivePath, "static")
    passiveLoop:setLooping(true)
    passiveLoop:setVolume(1)
end

function music.start(callback, endSong)
    music.callback = callback
    music.endSong = endSong

    music.crossFadeTo("passive")
    love.audio.play(activeLoop)
    love.audio.play(passiveLoop)

    music.multiplier = 1
    state = "waitingForBeat"
end

function music.stop()
    love.audio.stop(activeLoop)
    love.audio.stop(passiveLoop)
end

function music.update()
    local songTime = activeLoop:tell()

    beat, beatFrac = math.modf(songTime / (60 / 133))
    local newBeat = beat ~= lastBeat
    if state == "waitingForKey" then
        if newBeat then
            music.callback()
            lastBeat = beat

            state = "waitingForKey"

            if music.multiplier ~= 1 and not gracePeriod then
                music.multiplier = 1
                music.crossFadeTo("passive")
                love.audio.play(resetSfx)
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
    love.graphics.setColor(music.multiplier == 1 and colors.white or colors.green)
    love.graphics.print("Multiplier: " .. music.multiplier, 650, 660)
    if gracePeriod then
        love.graphics.rectangle("fill",600,660, 40,40)
    end
    --love.graphics.print(round(beatFrac, 1), 150, 660)
    --love.graphics.print(beat, 250, 660)

    if music.multiplier == 1 then
    -- return
    end

    love.graphics.rectangle(
        "fill",
        indicator.x + indicator.width / 2 * beatFrac,
        indicator.y + indicator.height / 4,
        indicator.width - indicator.width * beatFrac,
        indicator.height
    )

    local alpha = 1.0 - beatFrac
    love.graphics.setColor(colors.fade(colors.pink, alpha))
    --[[ 
    if lastPos >= 0 then
        love.graphics.rectangle(
            "fill",
            indicator.x + indicator.width / 2 - lastPos * indicator.width / 2,
            indicator.y,
            lastPos * indicator.width,
            indicator.height / 4
        )
    end ]]
end

function music.hitKey()
    if state == "waitingForKey" then
        state = "waitingForBeat"
        lastPos = beatFrac

        if gracePeriod == true then
            gracePeriod = false
        end
    end
end

function music.score()
    local points = 10 * music.multiplier
    music.multiplier = music.multiplier + 1
    if music.multiplier == 2 then
        music.crossFadeTo("active")
        gracePeriod = true
    end

    return points
end

return music
