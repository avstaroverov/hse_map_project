local container = {}

function container:onCreate()
    self:SetUniqueName("Map Mode")

    local svgData = love.filesystem.read("assets/menu/Работа с картой.svg")
    self.svg = tove.newGraphics(svgData, "copy")
    self.svg:setDisplay("texture")

    self.map = ui2.CreateUI("map", self)
    

    self.back_button = ui2.CreateUI("preset_button", self)
    self.back_button:SetCustomReaction(function()
        self:Disable()
        ui2.GetUnique("Main Menu"):Enable()
        MAPMODE = true
    end)
    self.back_button:SetPos(67, 86)
    self.back_button:SetSize(56, 49)


    self.hand_button = ui2.CreateUI("preset_button", self)
    self.hand_button:SetCustomReaction(function()
        MODE = "Hand"
    end)
    self.hand_button:SetPos(1776, 464)
    self.hand_button:SetSize(39, 39)


    self.pencil_button = ui2.CreateUI("preset_button", self)
    self.pencil_button:SetCustomReaction(function()
        MODE = "Pencil"
    end)
    self.pencil_button:SetPos(1776, 515)
    self.pencil_button:SetSize(39, 39)


    self.pencil_button = ui2.CreateUI("preset_button", self)
    self.pencil_button:SetCustomReaction(function()
        MODE = "Sprite"
    end)
    self.pencil_button:SetPos(1776, 566)
    self.pencil_button:SetSize(39, 39)


    self.fs_button = ui2.CreateUI("preset_button", self)
    self.fs_button:SetCustomReaction(function()
        self:Disable()
        ui2.GetUnique("Map Mode FS"):Enable()
        ui2.GetUnique("Line Container"):SetPos(7, 8):SetSize(1907, 1064)
    end)
    self.fs_button:SetPos(1773, 226)
    self.fs_button:SetSize(42, 42)

    
    self.reverse_button = ui2.CreateUI("preset_button", self)
    self.reverse_button:SetCustomReaction(function()
        ui2.GetUnique("Line Canvas"):Back()
    end)
    self.reverse_button:SetPos(1775, 328)
    self.reverse_button:SetSize(40, 32)

    
    self.forward_button = ui2.CreateUI("preset_button", self)
    self.forward_button:SetCustomReaction(function()
        ui2.GetUnique("Line Canvas"):Forward()
    end)
    self.forward_button:SetPos(1775, 372)
    self.forward_button:SetSize(40, 32)



    self:Disable()
end


function container:Paint()
    self.svg:draw(0, 0)
end

return container