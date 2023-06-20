local map_container = {}

function map_container:onCreate()
    self:SetUniqueName("Map C")
end

local function stencil()
    love.graphics.rectangle("fill", 99, 212, 1650, 792, 34, 34)
end

function map_container:Paint()
    draw:Draw(stencil)
end

return map_container