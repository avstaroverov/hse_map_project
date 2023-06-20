local map_container = {}
map_container.id = "Map Canvas FS"

function map_container:onCreate()
end

local function stencil()
    love.graphics.rectangle("fill", 7, 8, 1907, 1064, 40, 40)
end

function map_container:Paint()
    draw:Draw(stencil)
end

return map_container