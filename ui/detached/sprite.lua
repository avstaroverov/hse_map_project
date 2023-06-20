local ent = {}
local hub = {}
local click

ent.IgnoreScissors = true
ent.CameraBased = true
ent.Clickable = false

ent.sizeX = 0
ent.sizeY = 0

ent.assets = {
    close = love.graphics.newImage("assets/menu/close.png"),

    cross = love.graphics.newImage("assets/sprites/cross.png")
}

local function remove(self)
    self.father:Remove()
end

function ent:onCreate(texture)
    self.Texture = self.assets[texture]
    --self:SetSize(self.Texture:getDimensions())
    self.removeButton = self:CreateUI("preset_button")
    self.removeButton:Disable()
    self.removeButton:SetCustomReaction(remove)
    self.removeButton.Clickable = false
    table.insert(hub, self)
end

function ent:Paint()
    camera:push()
    love.graphics.draw(self.Texture, self.drawx, self.drawy)
    if self.clicked then
        love.graphics.rectangle("line", self.drawx-2, self.drawy-2, self.sizeX+4, self.sizeY+4)
        love.graphics.draw(self.assets.close, self.drawx+self.sizeX+8, self.drawy)
    end
    camera:pop()
end

function ent:onClick()
    MODE = "Selected"
    self.clicked = true
    click = self
    self.removeButton:Enable()
end
function ent:onNoPress()
    MODE = "Hand"
    self.clicked = false
    click = nil
    self.removeButton:Disable()
end



local clickproxy = {}
mainhook:GetHook("MousePressed"):Add("SpriteClick", function(x, y)
    x, y = draw:ConvertToTransform(x, y)

    if click then
        if x > click.drawx+click.sizeX+8 and x < click.drawx + click.sizeX+20 and y > click.drawy and y < click.drawy + 12 then
            clickproxy[click] = true
            return
        end
    end

    for _, var in ipairs(hub) do
        if not var.disable then
            if x > var.drawx and x < var.drawx + var.sizeX and y > var.drawy and y < var.drawy + var.sizeY then
                var:onPress(x, y)
                clickproxy[var] = true
            else
                clickproxy[var] = false
                var:onNoPress(x, y)
            end
        end
    end
end)
mainhook:GetHook("MouseReleased"):Add("SpriteClick", function(x, y)
    x, y = draw:ConvertToTransform(x, y)

    if click and clickproxy[click] then
        if x > click.drawx+click.sizeX+8 and x < click.drawx + click.sizeX+20 and y > click.drawy and y < click.drawy + 12 then
            MODE = "Hand"
            click:Remove()
            return
        end
    end

    for _, var in ipairs(hub) do
        if not var.disable and clickproxy[var] then
            if x > var.drawx and x < var.drawx + var.sizeX and y > var.drawy and y < var.drawy + var.sizeY then
                var:onClick(x, y)
            else
                var:onFailedClick(x, y)
            end
            var:onRelease(x, y)
            clickproxy[var] = false
        end
    end
end)



return ent