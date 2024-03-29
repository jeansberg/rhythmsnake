local messageManager = {}
local colors = require("colors")
local messages = {}

function addMessage(type, text, x, y, color)
    local message = {
        type = type,
        text = text,
        x = x,
        y = y,
        color = color,
        timer = 1
    }
    table.insert(messages, message)
end

function messageManager.update(dt)
    for i = #messages, 1, -1 do
        local m = messages[i]
        m.y = m.y - m.y * dt * 0.1
        m.timer = m.timer - dt
        m.color = colors.fade(m.color, m.timer)
        if m.timer <= 0 then table.remove(messages, i) end
    end
end

function messageManager.draw()
    for _, v in pairs(messages) do
        love.graphics.setColor(v.color)
        love.graphics.print(v.text, v.x, v.y)
    end
end

function clearPrevious()
    for i = #messages, 1, -1 do
        local m = messages[i]
        if m.type == "hit" or m.type == "miss" then
            table.remove(messages, i)
        end
    end
end
function messageManager.start() messages = {} end

function messageManager.missBeat()
    clearPrevious()
    addMessage("miss", "Miss!", 410, 620, colors.pink)
end

function messageManager.hitBeat(quality)
    clearPrevious()
    addMessage("hit", quality .. "!", 420, 620, colors.white)
end

function messageManager.eatApple(x, y)
    addMessage("eat", "+1", x, y, colors.green)
end

return messageManager
