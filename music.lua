local music = {}
local path = "song.ogg"
local song = {}
local lastBeat = -1
local thisBeat = 0
local flag = false

local blue = {0, 0.80, 1}
local green = {0.02, 1, 0.63}

local callback = {}

function music.start(callback)
    callback = callback
    song = love.audio.newSource(path, "stream")
    love.audio.play(song)
end

function music.stop()
    love.audio.stop(song)
end

function music.update()
    local seconds = song:tell()
    thisBeat = math.floor(seconds / (60 / 115))
    if thisBeat ~= lastBeat then
        lastBeat = thisBeat
        flag = not flag
    end
end

function music.draw()
    if flag then
        love.graphics.setColor(blue)
    else
        love.graphics.setColor(green)
    end
    love.graphics.rectangle("fill", 200, 0, 400, 80)
end

return music
