local container = {}
local hub = {}
local click

container.IgnoreScissors = true
container.Clickable = false

container.sizeX = 0
container.sizeY = 0

local buffer = 10

container.assets = {
    close = love.graphics.newImage("assets/menu/close.png")
}

function container:onCreate()
    self.points = {}
    table.insert(hub, self)
    
    --Honestly, no idea why I use buttons even though I don't use any of their activities lol
    self.removeButton = self:CreateUI("preset_button")
    self.removeButton:Disable()
    self.removeButton.Clickable = false
    
    self.transferButton = self:CreateUI("preset_button")
    self.transferButton:Disable()
    self.transferButton.Clickable = false
end

function container:Paint()
    camera:push()
    love.graphics.line((self.points))
    if self.clicked then
        love.graphics.rectangle("line", self.cposX, self.cposY, self.sizeX, self.sizeY)
        love.graphics.draw(self.assets.close, self.cposX+self.sizeX+8, self.cposY)
        love.graphics.draw(self.assets.close, self.cposX+self.sizeX+8, self.cposY+16)
    end
    camera:pop()
end

function container:AddPoint(x, y)
    --TODO: Change it to line-point collision
    local tx, ty = draw:ConvertToTransform(x, y)

    local oldposx = self.cposX or tx
    local oldposy = self.cposY or ty
    self.cposX = math.min(tx, self.cposX or tx)
    self.cposY = math.min(ty, self.cposY or ty)

    if tx == self.cposX then
        self.sizeX = self.sizeX+(oldposx-tx)
    else
        self.sizeX = math.max(tx-self.cposX, self.sizeX)
    end
    if ty == self.cposY then
        self.sizeY = self.sizeY+(oldposy-ty)
    else
        self.sizeY = math.max(ty-self.cposY, self.sizeY)
    end
    
    table.insert(self.points, tx)
    table.insert(self.points, ty)
end

function container:onClick()
    MODE = "Selected"
    self.clicked = true
    click = self
    self.removeButton:Enable()
end
function container:onNoPress()
    MODE = "Hand"
    self.clicked = false
    click = nil
    self.removeButton:Disable()
end


local clickproxy = {}
mainhook:GetHook("MousePressed"):Add("LineClick", function(x, y)
    x, y = draw:ConvertToTransform(x, y)

    if click then
        if x > click.cposX+click.sizeX+8 and x < click.cposX + click.sizeX+20 and y > click.cposY and y < click.cposY + 12 then
            clickproxy[click] = true
            return
        end
        if x > click.cposX+click.sizeX+8 and x < click.cposX + click.sizeX+20 and y > click.cposY+16 and y < click.cposY + 28 then
            clickproxy[click] = true
            return
        end
    end

    for _, var in ipairs(hub) do
        if not var.disable then
            local r = false
            for i=3, #var.points, 2 do
                if var.points[i+2] then
                    local lx1, ly1 = var.points[i], var.points[i+1]
                    local lx2, ly2 = var.points[i+2], var.points[i+3]
                    local d = util.Dist(x, y, lx1, ly1) + util.Dist(x, y, lx2, ly2)
                    local len = util.Dist(lx1, ly1, lx2, ly2)
                    if (d >= len-buffer) and (d <= len+buffer) then
                        var:onPress(x, y)
                        clickproxy[var] = true
                        r = true
                        break
                    end
                end
            end
            if not r and click then
                var:onNoPress()
            end
            clickproxy[var] = r
        end
    end
end)
mainhook:GetHook("MouseReleased"):Add("LineClick", function(x, y)
    x, y = draw:ConvertToTransform(x, y)

    if click and clickproxy[click] then
        if x > click.cposX+click.sizeX+8 and x < click.cposX + click.sizeX+20 and y > click.cposY and y < click.cposY + 12 then
            MODE = "Hand"
            click:Remove()
            return
        end
        if x > click.cposX+click.sizeX+8 and x < click.cposX + click.sizeX+20 and y > click.cposY+16 and y < click.cposY + 28 then
            MODE = "Transform"
            mainhook:GetHook("MouseMove"):Add("Line Transform", function(_, _, dx, dy)
                click.cposX = click.cposX + dx
                click.cposY = click.cposY + dy
            end)
            mainhook:GetHook("MouseReleased"):Add("Line Transform", function()
                mainhook:GetHook("MouseMove"):Remove("Line Transform")
                mainhook:GetHook("MouseReleased"):Remove("Line Transform")
            end)
            return
        end
    end

    for _, var in ipairs(hub) do
        if not var.disable and clickproxy[var] then  
            local r = false          
            for i=3, #var.points, 2 do
                if var.points[i+2] then
                    local lx1, ly1 = var.points[i], var.points[i+1]
                    local lx2, ly2 = var.points[i+2], var.points[i+3]
                    local d = util.Dist(x, y, lx1, ly1) + util.Dist(x, y, lx2, ly2)
                    local len = util.Dist(lx1, ly1, lx2, ly2)
                    if (d >= len-buffer) and (d <= len+buffer) then
                        var:onClick(x, y)
                        break
                    end
                end
            end
            var:onRelease(x, y)
            clickproxy[var] = false
        end
    end
end)


return container