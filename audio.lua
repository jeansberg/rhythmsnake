local audio = {}
local sfx = {}
local songs = {}

function audio.init()
    sfx.die = love.audio.newSource("content/die.wav", "static")
    sfx.eatApple = love.audio.newSource("content/eatApple.wav", "static")
    sfx.bang = love.audio.newSource("content/bang.wav", "static")
    sfx.reset = love.audio.newSource("content/reset.wav", "static")

    songs.activeSong = love.audio.newSource("content/song_active.ogg", "static")
    songs.activeSong:setLooping(true)
    songs.activeSong:setVolume(0)

    songs.passiveSong = love.audio.newSource("content/song_passive.ogg",
                                             "static")
    songs.passiveSong:setLooping(true)
    songs.passiveSong:setVolume(0)

    songs.gameoverSong = love.audio.newSource("content/song_gameover.ogg",
                                              "static")
    songs.gameoverSong:setLooping(true)
    songs.gameoverSong:setVolume(0)
end

function audio.start()
    for _, v in pairs(songs) do
        love.audio.stop(v)
        love.audio.play(v)
    end

    audio.toggleSong("passiveSong")
end

function audio.play(source)
    love.audio.stop(sfx[source])
    love.audio.play(sfx[source])
end

function audio.toggleSong(source)
    for k, v in pairs(songs) do v:setVolume(0) end
    print(source)
    songs[source]:setVolume(1)
end

function audio.getSongTime() return songs.activeSong:tell() end

return audio
