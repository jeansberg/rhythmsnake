local music = {}
local path = "song3_short.mp3"
local song = {}
local lastBeat = -1
local beat = 0
local beatFrac = 0
local state = {}
local multiplier = 1
local indicator = {x = 250, y = 660, width = 400, height = 40}
local resetSfx = love.audio.newSource("reset.wav", "static")
local green = {5 / 255, 255 / 255, 161 / 255}
local red = {255 / 255, 113 / 255, 206 / 255}

music.callback = {}
music.endSong = {}

function music.start(callback, endSong)
    music.callback = callback
    music.endSong = endSong
    song = love.audio.newSource(path, "stream")
    multiplier = 1
    love.audio.play(song)
    state = "waitingForBeat"
end

function music.stop()
    love.audio.stop(song)
end

function music.update()
    local songTime = song:tell()
    if not song:isPlaying() then
        endSong()
    end

    beat, beatFrac = math.modf(songTime / (60 / 133))
    local newBeat = beat ~= lastBeat
    if state == "waitingForKey" then
        if newBeat then
            music.callback()
            lastBeat = beat
            lastPos = -1

            if multiplier ~= 1 then
                multiplier = 1
                love.audio.play(resetSfx)
                state = "waitingForKey"
            end
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
    local color = green
    love.graphics.setColor(color)
    love.graphics.rectangle(
        "fill",
        indicator.x + 200 * (beatFrac),
        indicator.y + indicator.height / 4,
        indicator.width - indicator.width * beatFrac,
        indicator.height
    )

    color = multiplier < 2 and {1, 1, 1} or green
    love.graphics.setColor(color)

    love.graphics.print("Multiplier: " .. multiplier, 650, 660)

    color = red
    local alpha = 1.0 - beatFrac
    color[4] = alpha
    love.graphics.setColor(red)

    --[[     if lastPos >= 0 then
        love.graphics.rectangle("fill", indicator.x + 150, indicator.y, indicator.width - 300, indicator.height / 4)
    end ]]
    love.graphics.setColor {1, 1, 1}
end

function music.hitKey()
    if state == "waitingForKey" then
        state = "waitingForBeat"
    end
end

function music.score()
    local points = 10 * multiplier
    multiplier = multiplier + 1
    return points
end

return music
