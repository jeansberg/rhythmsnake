-- Responsible for creating audio sources and handling playback of music and sfx
local audio = {}
local sfx = {}
local songPhases = {}

-- Creates and sets up audio sources from files - run once at startup
function audio.init()
    sfx.die = love.audio.newSource("content/die.wav", "static")
    sfx.raiseMultiplier = love.audio.newSource("content/raiseMultiplier.wav",
                                               "static")
    sfx.crunch = love.audio.newSource("content/crunch.wav", "static")
    sfx.bang = love.audio.newSource("content/bang.wav", "static")
    sfx.reset = love.audio.newSource("content/reset.wav", "static")

    -- Set all song phases to loop with zero volume
    songPhases.active = love.audio
                            .newSource("content/song_active.ogg", "static")
    songPhases.active:setLooping(true)
    songPhases.active:setVolume(0)

    songPhases.passive = love.audio.newSource("content/song_passive.ogg",
                                              "static")
    songPhases.passive:setLooping(true)
    songPhases.passive:setVolume(0)

    songPhases.gameover = love.audio.newSource("content/song_gameover.ogg",
                                               "static")
    songPhases.gameover:setLooping(true)
    songPhases.gameover:setVolume(0)
end

-- Restarts all song phases and switches to the passive version of the song phase
function audio.start()
    for _, v in pairs(songPhases) do
        love.audio.stop(v)
        love.audio.play(v)
    end

    audio.toggleSongPhase("passive")
end

-- Plays a sound effect, after first making sure it's stopped
function audio.play(source, pitch)
    love.audio.stop(sfx[source])
    print(pitch)
    if pitch ~= nil then sfx[source]:setPitch(math.min(1 + pitch / 5.0, 2)) end
    love.audio.play(sfx[source])
end

-- Makes sure only the requested source is unmuted
function audio.toggleSongPhase(source)
    for _, v in pairs(songPhases) do v:setVolume(0) end
    songPhases[source]:setVolume(1)
end

-- Returns the current time of the song loop (could use any song phase here, since they start at the same time)
function audio.getSongTime() return songPhases.active:tell() end

return audio
