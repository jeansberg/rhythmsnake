local audio = {}

local sources = {}
sources.die = love.audio.newSource("die.wav", "static")
sources.eatApple = love.audio.newSource("eatApple.wav", "static")
sources.bang = love.audio.newSource("bang.wav", "static")

function audio.play(source)
    love.audio.stop(sources[source])
    love.audio.play(sources[source])
end

return audio
