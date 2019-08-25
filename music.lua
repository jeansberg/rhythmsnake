local music = {}
local path = "song3.mp3"
local song = {}
local lastBeat = -1
local beat = 0
local beatFrac = 0
local flag = false
local waitingForKey = true
local hitKey = false
local multiplier = 1
local indicator = {x = 250, y = 660, width = 400, height = 40}
local resetSfx = love.audio.newSource("reset.wav", "static")
local green = {5 / 255, 255 / 255, 161 / 255}
local red = {255 / 255, 113 / 255, 206 / 255}
local lastPos = -1

music.callback = {}

function music.start(callback)
    music.callback = callback
    song = love.audio.newSource(path, "stream")
    multiplier = 1
    love.audio.play(song)
end

function music.stop()
    love.audio.stop(song)
end

function music.update()
    local seconds = song:tell()
    beat, beatFrac = math.modf(seconds / (60 / 133))
    if beat ~= lastBeat then
        lastBeat = beat
        if waitingForKey and multiplier ~= 1 then
            lastPos = -1
            love.audio.play(resetSfx)
            multiplier = 1
        end
        hitKey = false
        flag = not flag
        music.callback()
        waitingForKey = true
    end
end

function music.draw()
    local color = beatFrac < 0.75 and green or red
    love.graphics.setColor(color)
    love.graphics.rectangle(
        "fill",
        indicator.x + 200 * (beatFrac),
        indicator.y,
        indicator.width - indicator.width * beatFrac,
        indicator.height
    )

    color = multiplier < 2 and {1, 1, 1} or green
    love.graphics.setColor(color)

    love.graphics.print("Multiplier: " .. multiplier, 650, 660)

    love.graphics.setColor(1, 0, 0)

    love.graphics.rectangle("fill", indicator.x + 200 * (lastPos), indicator.y, 5, indicator.height)

    love.graphics.setColor {1, 1, 1}
end

function music.hitKey()
    if (beatFrac < 0.75) then
        print("Hit")
        lastPos = beatFrac
        hitKey = true
        waitingForKey = false
    end
end

function music.score(score)
    local points = 10 * multiplier
    multiplier = multiplier + 1
    return points
end

return music
