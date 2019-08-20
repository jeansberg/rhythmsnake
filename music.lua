local music = {}
local path = "song.ogg"
local song = {}
local lastBeat = -1
local thisBeat = 0
local flag = false

music.callback = {}

function music.start(callback)
    music.callback = callback
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
        music.callback()
    end
end

return music
