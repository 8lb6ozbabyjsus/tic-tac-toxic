-- src/entities/piece.lua
local piece = {}

function piece.new(x, y, player)
    local self = {}
    self.x = x
    self.y = y
    self.player = player
    return self
end

function piece.draw()
    -- Draw individual piece
end

return piece
