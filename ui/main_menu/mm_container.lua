local container = {}

container.sizeX = 1920
container.sizeY = 1080

function container:onCreate()
    self:SetUniqueName("Main Menu")

    local svgData = love.filesystem.read("assets/menu/Главный экран.svg")
    self.svg = tove.newGraphics(svgData, "copy")
    self.svg:setDisplay("texture")
    self.map_mode = ui2.CreateUI("map_container")
    ui2.CreateUI("Map Mode FS")
    ui2.CreateUI("line_container")

    --force love to create canvases and shit to prevent a huge freeze
    map.DrawMap()

    self.map_mode:Disable()
end
function container:Paint()
    self.svg:draw(0, 0)
end

function container:onClick()
    self:Disable()
    self.map_mode:Enable()
    MAPMODE = true
    camera:increaseTranslation(-95, -208)
    ui2.GetUnique("Line Container"):SetPos(95, 208):SetSize(1658, 800)
end

return container