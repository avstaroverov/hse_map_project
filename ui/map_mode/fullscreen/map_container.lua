local container = {}
container.id = "Map Mode FS"
function container:onCreate()
    self:SetUniqueName("Map Mode FS")

    local svgData = love.filesystem.read("assets/menu/Полный экран карты.svg")
    self.svg = tove.newGraphics(svgData, "copy")
    self.svg:setDisplay("texture")

    self.map = ui2.CreateUI("Map Canvas FS", self)    

    self.back_button = ui2.CreateUI("preset_button", self)
    self.back_button:SetCustomReaction(function()
        self:Disable()
        ui2.GetUnique("Map Mode"):Enable()
    end)
    self.back_button:SetPos(1849, 31)
    self.back_button:SetSize(39, 42)

    self.pencil_button = ui2.CreateUI("preset_button", self)
    self.pencil_button:SetCustomReaction(function()
        MODE = "Pencil"
    end)
    self.pencil_button:SetPos(979, 970)
    self.pencil_button:SetSize(39, 39)

    self.hand_button = ui2.CreateUI("preset_button", self)
    self.hand_button:SetCustomReaction(function()
        MODE = "Hand"
    end)
    self.hand_button:SetPos(920, 972)
    self.hand_button:SetSize(39, 39)


    self:Disable()
end

function container:Paint()
    self.svg:draw(0, 0)
end

return container