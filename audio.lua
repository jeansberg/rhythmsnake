-- Responsible for creating audio sources and handling playback of music and sfx
local audio = {}
local sfx = {}
local songPhases = {}

-- Creates and sets up audio sources from files - run once at startup
function audio.init()
    sfx.die = love.audio.newSource("content/die.wav", "static")
    sfx.eatApple = love.audio.newSource("content/eatApple.wav", "static")
    sfx.bang = love.audio.newSource("content/bang.wav", "static")
    sfx.reset = love.audio.newSource("content/reset.wav", "static")

    -- Set all song phases to loop with zero volume
    songPhases.activesongPhase = love.audio.newSource("content/songPhase_active.ogg", "static")
    songPhases.activesongPhase:setLooping(true)
    songPhases.activesongPhase:setVolume(0)

    songPhases.passivesongPhase = love.audio.newSource("content/songPhase_passive.ogg", "static")
    songPhases.passivesongPhase:setLooping(true)
    songPhases.passivesongPhase:setVolume(0)

    songPhases.gameoversongPhase = love.audio.newSource("content/songPhase_gameover.ogg", "static")
    songPhases.gameoversongPhase:setLooping(true)
    songPhases.gameoversongPhase:setVolume(0)
end

-- Restarts all song phases and switches to the passive version of the song phase
function audio.start()
    for _, v in pairs(songPhases) do
        love.audio.stop(v)
        love.audio.play(v)
    end

    audio.togglesongPhase("passivesongPhase")
end

-- Plays a sound effect, after first making sure it's stopped
function audio.play(source)
    love.audio.stop(sfx[source])
    love.audio.play(sfx[source])
end

-- Makes sure only the requested source is unmuted
function audio.togglesongPhase(source)
    for _, v in pairs(songPhases) do v:setVolume(0) end
    songPhases[source]:setVolume(1)
end

-- Returns the current time of the song loop (could use any song phase here, since they start at the same time)
function audio.getsongPhaseTime() return songPhases.activesongPhase:tell() end

return audio
