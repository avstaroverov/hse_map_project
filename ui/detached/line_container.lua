local container = {}

function container:onCreate()
    self:SetUniqueName("Line Container")
    ui2.CreateUI("line_canvas", self)
end

return container