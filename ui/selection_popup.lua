local container = {}

container.Plots = {}
container.sizeX = 1920
container.sizeY = 1080


function container:onCreate()
    self:SetUniqueName("selection_popup")
    --CRINGE
    mainhook:GetHook("PostDraw"):Add("selection_popup", function()
        if self.curr and MAPMODE then
            love.graphics.setColor(195, 202, 208)
            love.graphics.rectangle("fill", love.mouse.getX(), love.mouse.getY(), 390, 240, 20, 20)
            love.graphics.draw(self.Plots[self.curr], love.mouse.getX()+20, love.mouse.getY()+20)
        end
    end)
end


for _, var in ipairs(util.IterateThroughFolder("assets/plots")) do
    container.Plots[var:sub(-7, -5)] = love.graphics.newImage(var)
end


function container:Paint()
    if self.curr then
        --love.graphics.setColor(195, 202, 208)
        love.graphics.rectangle("fill", love.mouse.getX(), love.mouse.getY(), 576, 384)
        love.graphics.draw(self.Plots[self.curr], love.mouse.getX(), love.mouse.getY())
    end
end

return container