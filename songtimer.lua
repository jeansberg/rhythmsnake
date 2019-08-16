local songtimer = {}

local timer = require("timer")
local period = {}
songtimer.fn = {}
local bpmtimer = {}

function songtimer.start(period, fn)
    period = period
    songtimer.fn = fn
    bpmtimer = timer.newTimer(period, true)
end

function songtimer.update(dt)
    if bpmtimer:update(dt) then 
        songtimer.fn()
    end
end

return songtimer