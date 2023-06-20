local container = {}

container.color = {0.3, 0.3, 0.3, 1}

function container:onCreate()
    self.canvas = love.graphics.newCanvas(self.sizeX, self.sizeY)
end
function container:Paint()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", 0, 0, self.sizeX, self.sizeY)
end

function container:Plot(data)
    local plot = ui.CreateUI("plot_plot")
    self:AddChild(plot)
    self:Update()
    return plot
end


return container