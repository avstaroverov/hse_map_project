local container = {}

local hub = {}

function container:onCreate()
    self:SetUniqueName("Line Canvas")
    self.history = util.Stack(5)

    local clickproxy = {}
    mainhook:GetHook("MousePressed"):Add("CamClick", function(x, y)
        x, y = draw:ConvertToTransform(x, y)
        for _, var in ipairs(self.children) do
            if not var.disable then
                if x > var.posX and x < var.posX + var.sizeX and y > var.posY and y < var.posY + var.sizeY then
                    var:onPress(x, y)
                    clickproxy[var] = true
                else
                    clickproxy[var] = false
                end
            end
        end
    end)
    mainhook:GetHook("MouseReleased"):Add("CamClick", function(x, y)
        x, y = draw:ConvertToTransform(x, y)
        for _, var in ipairs(self.children) do
            if not var.disable and clickproxy[var] then
                if x > var.posX and x < var.posX + var.sizeX and y > var.posY and y < var.posY + var.sizeY then
                    var:onClick(x, y)
                else
                    var:onFailedClick(x, y)
                end
                var:onRelease(x, y)
                clickproxy[var] = false
            end
        end
    end)
end


function container:Paint()
end

function container:onPress(x, y)
    if MODE == "Pencil" then
        self.active = ui2.CreateUI("line", self)
        self.offset = self.history:AddStack(self.active)
        self.history:ClearAfter(self.offset)
        self.active:AddPoint(x, y)
        self.active:AddPoint(x, y) --add twice because lg.line takes min 2 points and MouseMove would only fire at least after 1 frame
        mainhook:GetHook("MouseMove"):Add(self.active, function(x, y)
            self.active:AddPoint(x, y)
        end)
        mainhook:GetHook("MouseReleased"):Add(self.active, function(x, y)
            self.active:AddPoint(x, y)
            mainhook:GetHook("MouseMove"):Remove(self.active)
            mainhook:GetHook("MouseReleased"):Remove(self.active)
            self.active = nil
        end)
        table.insert(hub, {"line", self.active})
    elseif MODE == "Sprite" then
        local sprite = ui2.CreateUI("sprite", self, "cross")
        local dx, dy = camera:getWorldCoordinates(x-24, y-24)
        sprite.drawx = dx
        sprite.drawy = dy
        sprite:SetSize(48, 48)
        MODE = "Hand"
        table.insert(hub, {"sprite", sprite})
    end
end
function container:onRelease(x, y)
    if self.active then
        self.active:AddPoint(x, y)
        mainhook:GetHook("MouseMove"):Remove(self.active)
        mainhook:GetHook("MouseReleased"):Remove(self.active)
        self.active = nil
    end
end

function container:Back()
    if self.offset > 1 then
        self.history[self.offset]:Disable()
        self.offset = self.offset - 1
    end
end
function container:Forward()
    if self.offset < 5 then
        self.offset = self.offset + 1
        self.history[self.offset]:Enable()
    end
end





return container