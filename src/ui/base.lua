---@type ui_piece 
local base = {}

base.posX = 0
base.posY = 0
base.absposX = 0
base.absposY = 0
base.sizeX = love.graphics.getWidth()
base.sizeY = love.graphics.getHeight()
base.scale = 1
base.disable = false
base.paddingX = 0
base.paddingY = 0
base.Clickable = true

local proxy --i'm genius

function base:__init(p)
    proxy = p
end
function base:__precreate() 
    self.children = {}
end
function base:Init()
end

---
function base:SetPos(x, y)
    self.posX = x
    self.posY = y

    self:UpdateAbsolutePos()

    return self
end
function base:SetDPos(dx, dy)
    self.posX = self.posX + dx
    self.posY = self.posY + dy

    self:UpdateAbsolutePos()
    return self
end
function base:GetPos()
    return self.posX, self.posY
end

function base:SetUniqueName(str)
    assert(not proxy[str], "Duplicating Unique Name!: "..str)
    proxy[str] = self
    return self
end

function base:UpdateAbsolutePos()
    local offx, offy = self.father:GetAbsolutePos()
    self.absposX = self.posX + offx
    self.absposY = self.posY + offy
    for _, var in ipairs(self.children) do
        var:UpdateAbsolutePos()
    end
    return self
end
function base:GetAbsolutePos()
    return self.absposX, self.absposY
end

function base:SetSizeX(x)
    self.sizeX = x
    return self
end
function base:SetSizeY(y)
    self.sizeY = y
    return self
end
function base:SetSize(x, y)
    self.sizeX = x
    self.sizeY = y
    return self
end

function base:GetSizeX()
    return self.sizeX
end
function base:GetSizeY()
    return self.sizeY
end
function base:GetWidth()
    return self.sizeX
end
function base:GetHeight()
    return self.sizeY
end
function base:GetSize()
    return self.sizeX, self.sizeY
end


function base:SetX(x)
    self.posX = x
    
    self:UpdateAbsolutePos()
    return self
end
function base:SetDX(x)
    self.posX = self.posX + x

    self:UpdateAbsolutePos()
    return self
end
function base:GetX()
    return self.posX
end

function base:SetPadding(x, y)
    self.paddingX = x
    self.paddingY = y
    return self
end
function base:SetPaddingX(x)
    self.paddingX = x
    return self
end
function base:SetPaddingY(y)
    self.paddingY = y
    return self
end

function base:SetY(y)
    self.posY = y

    self:UpdateAbsolutePos()
    return self
end
function base:SetDY(y)
    self.posY = self.posY + y

    self:UpdateAbsolutePos()
    return self
end
function base:GetY()
    return self.posY
end

function base:SetScale(s)
    self.scale = s
    return self
end
function base:GetScale()
    return self.scale
end

function base:AddChild(child)
    table.insert(self.children, child)
    child.father = self
    return self
end
function base:SetFather(father)
    table.insert(father.children, self)
    self.father = father
    return self
end
function base:GetFather()
    return self.father
end

function base:Enable()
    self.disable = false
    for _, var in ipairs(self.children) do
        var:Enable()
    end
    return self
end
function base:Disable()
    self.disable = true
    for _, var in ipairs(self.children) do
        var:Disable()
    end
    return self
end
function base:Toggle()
    self.disable = not self.disable
    return self
end

function base:Draw()
    if not self.disable then
        love.graphics.push("all")
        love.graphics.translate(self.posX, self.posY)
        love.graphics.scale(self.scale)
        if not self.IgnoreScissors then
            love.graphics.intersectScissor(self.absposX, self.absposY, self.sizeX, self.sizeY)
        end
        self:Paint()
        if DEBUG_WIREFRAME then
            love.graphics.line(0, 0, self.sizeX, 0, self.sizeX, self.sizeY, 0, self.sizeY, 0, 0)
            love.graphics.line(0, 0, self.sizeX, self.sizeY)
            love.graphics.line(self.sizeX, 0, 0, self.sizeY)
        end
        for _, var in ipairs(self.children) do
            --love.graphics.intersectScissor(self.paddingX, self.paddingY, self.sizeX-self.paddingX, self.sizeY-self.paddingY)
            var:Draw()
        end
        love.graphics.pop()
    end
end
function base:Paint()
end


function base:Remove()
    for _, var in ipairs(self.children) do
        var:Remove()
    end
    for _, var in ipairs(self.father.children) do
        if var == self then
            table.remove(self.father.children, _)
            break 
        end
    end
    self = nil
end

function base:onCreate()
end
function base:onPress()
end
function base:onClick()
end
function base:onFailedClick()
end
function base:onRelease()
end
function base:onRemove()
end


return base