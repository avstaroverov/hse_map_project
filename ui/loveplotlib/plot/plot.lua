local plot = {}

function plot:onCreate()
    self.children.axes = {}
    local axis_h = ui.CreateUI("plot_axes_horizontal")
    self.children.axes.horizontal = axis_h
    self:AddChild(axis_h)
    local axis_v = ui.CreateUI("plot_axes_vertical")
    self.children.axes.vertical = axis_v
    self:AddChild(axis_v)
end

function plot:GetAxis(orientation)
    return (assert(orientation=="horizontal" and self.children.axes.horizontal or orientation=="vertical" and self.children.axes.vertical, "Incorrect axis!"))
end

function plot:Paint()
    local xoff = self.children.axes.vertical:GetWidth()  
    local yoff = self.children.axes.horizontal:GetHeight()  

    self.children.axes.horizontal:SetWidth(self:GetWidth()-self:GetPaddingX()*2-xoff)
    self.children.axes.horizontal:SetPos(xoff, self:GetHeight()-yoff)
    self.children.axes.vertical:SetHeight(self:GetHeight()-self:GetPaddingY()*2-yoff)
    self.children.axes.vertical:SetPos(0, 0)


end

function plot:Update(s)
    for _, var in ipairs(self.children) do
        if not (var == s) then
            var:Update()
        end
    end
    self:Paint()
    self.father:Update(self)
end

local function preproccess_data(data)
    local p_start_x
	for _, var in ipairs(data) do
		if type(var) == "number" then
			p_start_x = p_start_x and math.min(p_start_x, var[1]) or var[1]
		end
	end
    assert(p_start_x, "Incorrect [X] axis!")
    local p_end_x
	for _, var in ipairs(data) do
		if type(var) == "number" then
			p_end_x = p_end_x and math.max(p_end_x, var[1]) or var[1]
		end
	end
    assert(p_end_x, "Incorrect [X] axis!")

    local p_start_y
	for _, var in ipairs(data) do
		if type(var) == "number" then
			p_start_y = p_start_y and math.min(p_start_y, var[2]) or var[2]
		end
	end
    assert(p_start_y, "Incorrect [Y] axis!")
    local p_end_y
	for _, var in ipairs(data) do
		if type(var) == "number" then
			p_end_y = p_end_y and math.max(p_end_y, var[2]) or var[2]
		end
	end
    assert(p_end_y, "Incorrect [Y] axis!")



    return

end
function plot:SetData(data)
    self.data = data

    self.p_start_x, self.p_start_y, self.p_end_x, self.p_end_y = 

    self.children.axes.horizontal:SetData(data)
    self.children.axes.vertical:SetData(data)
end

return plot