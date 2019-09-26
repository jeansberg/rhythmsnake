local colors = {}

colors.pink = {1, 0.443, 0.807}
colors.blue = {0.003, 0.803, 0.996}
colors.green = {0.019, 1, 0.631}
colors.purple = {0.725, 0.403, 1}
colors.yellow = {1, 0.984, 0.588}
colors.gray = {0.2, 0.2, 0.2}
colors.black = {0, 0, 0}
colors.white = {1, 1, 1}

function colors.darken(color) return {color[1] / 2.0, color[2] / 2.0, color[3] / 2.0} end

function colors.fade(color, alpha) return {color[1], color[2], color[3], alpha} end

return colors
