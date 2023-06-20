draw = {}
local translate_x, translate_y = 0, 0
draw.lines = {}

--TODO: Really messy way to handle the scale, but works as a prototype
local scale = {}
local origin_x, origin_y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
local draw_off_x, draw_off_y = 0, 0

graphics = countries.LoadMap("Log", {'#E5EB88', '#8DD4EB'}, "GDP")
--graphics = countries.LoadMap("Log", {'#00FF00', '#FF0000'}, "GDP")


function draw:Draw(stencil)
    love.graphics.push()



	
    camera:push()
    map.DrawMap(stencil)
    if stencil then
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
    end
    camera:pop()
    ui2.GetUnique("Line Container"):Draw()
    

    --[[
    love.graphics.setColor(0, 0, 0)
    for _, var in ipairs(draw.lines) do
        love.graphics.line(var)
    end
    ]]
    love.graphics.pop()


end

function draw:AddPoint(x, y)
    love.graphics.push()
    for _, var in ipairs(scale) do
        love.graphics.translate(var[2], var[3])
        love.graphics.scale(var[1])
        love.graphics.translate(-var[2], -var[3])
    end
    love.graphics.translate(translate_x, translate_y)
    local tx, ty = love.graphics.inverseTransformPoint(x, y) 
    love.graphics.pop()

    table.insert(draw.lines[#draw.lines], tx)
    table.insert(draw.lines[#draw.lines], ty)
end

function draw:AddLine(x, y)
    love.graphics.push()
    for _, var in ipairs(scale) do
        love.graphics.translate(var[2], var[3])
        love.graphics.scale(var[1])
        love.graphics.translate(-var[2], -var[3])
    end
    love.graphics.translate(translate_x, translate_y)
    local tx, ty = love.graphics.inverseTransformPoint(x, y)
    love.graphics.pop()

    table.insert(draw.lines, {tx, ty, tx, ty})
end

function draw:Translate(x, y)
    camera:increaseTranslation(-x, -y)
end
function draw:Scale(x, og_x, og_y)
    if x == 0 then return end
    if not ((camera:getScale() < 0.05 and x < 0) or (camera:getScale() > 3 and x > 0)) then
        camera:increaseScaleToPoint(x)
    end
end

function draw:ConvertToTransform(x, y)
    return camera:getWorldCoordinates(x, y)
end