local map = {}
local scales = require("src.map_engine.scales")

local shader_code = love.filesystem.read("src/map_engine/2D/colored_cringe.glsl")
local shader

local countries_list = {}

local color_lib = {}
local color_lib_proxy = {}

local map_canvas = love.graphics.newCanvas()

local loaded_data
local loaded_scale
local loaded_norm

local current_slice = 1

local function loadmap()
    local t = {{}}
    local default = love.graphics.newImage("assets/map/loading.png")
    for x = 1, 32 do
        for y = 1, 16 do
            local imgdata = love.image.newImageData("assets/map/2x/"..x.."_"..y..".png")
            imgdata:mapPixel(function(x, y, r, g, b, a)
                return b, b, b, a
            end)
            local r8imgdata = love.image.newImageData(imgdata:getWidth(), imgdata:getHeight(), "r8")
            r8imgdata:paste(imgdata, 0, 0, 0, 0, imgdata:getWidth(), imgdata:getHeight())
            local texture = love.graphics.newImage(r8imgdata)
            imgdata:release()
            r8imgdata:release()

            table.insert(t[1], {
                texture = texture, 
                mapposX = x,
                mapposY = y,
                camposX1 = x*2000-2000, 
                camposY1 = y*1935-1935, 
                camposX2 = x*2000, 
                camposY2 = y*1935, 
                isObservable = false, 
                toLoad = false, 
                toUnload = false
            })
        end
    end
    function t:Update()
        for _, var in ipairs(self[1]) do
            if var.toLoad then
                -- R8 eats like 3-4 times less memory than RGBA lol, god bless there are less than 255 countries
                local imgdata = love.image.newImageData("assets/map/2x/"..var.mapposX.."_"..var.mapposY..".png")
                --imgdata:mapPixel(function(x, y, r, g, b, a)
                --    return b, b, b, a
                --end)
                local r8imgdata = love.image.newImageData(imgdata:getWidth(), imgdata:getHeight(), "r8")
                r8imgdata:paste(imgdata, 0, 0, 0, 0, imgdata:getWidth(), imgdata:getHeight())
                var.texture = love.graphics.newImage(r8imgdata)
                var.toLoad = false
                imgdata:release()
                break
            end
            if var.toUnload then
                var.texture:release()
                var.texture = default
                var.toUnload = false
                break
            end
        end
    end
    function t:Paint()
        for _, var in ipairs(self[1]) do
            love.graphics.draw(var.texture, var.camposX1, var.camposY1)
        end
    end
    return t
end

function map.LoadMap(norm, scale, data)
    local l = require("data.world bank.loader")
    loaded_data = l("data/world bank/API_NY.GDP.MKTP.CD_DS2_en_csv_v2_4770391.csv")
    loaded_data = json.decode(love.filesystem.read("gdp/gdp.json"))
    for _, var in ipairs(loaded_data) do
        for x = 1960, 2021 do
            table.insert(var, var[tostring(x)])
        end
    end

    loaded_scale = scale
    loaded_norm = norm

    
    for var in love.filesystem.lines("assets/countries/ne_10m.svg") do
        if var:find('fill="#FF0000"') then
            local pos = var:find('id="')
            if not pos then
                print(var)
            end
            local id = var:sub(pos+4, pos+6)
            countries_list[id] = true
        end
    end
    

    local index, colors = scales[loaded_norm](loaded_data, scale, countries_list,1)

    local codex = util.ParseCSVLine("src/map_engine/2D/codex.csv")
    for _, var in ipairs(codex) do
        color_lib[tonumber(var[2])] = index[var[1]] or {0, 0, 0, 1}
        color_lib_proxy[var[1]] = tonumber(var[2])
        color_lib_proxy[tonumber(var[2])] = var[1]
    end

    --print("Counter: "..counter)

    shader = love.graphics.newShader(shader_code)
    print(color_lib[1])
    shader:send("color_table", unpack(color_lib))
    -- practical limit I guess
    --local graphics = tove.newGraphics(svgData, 16184)
    --graphics:setDisplay("mesh", "adaptive", 16184)
    map_ent = loadmap()
    return map_ent
end

function map.UpdateYear(year)
    YEAR = year
    year = year - 1959
    current_slice = year + 4
    print(year)
    local index, colors = scales[loaded_norm](loaded_data, loaded_scale,countries_list, year)
    for _, var in ipairs(color_lib_proxy) do
        if index[var] then
            color_lib[_] = index[var]
        end
    end

    map.UpdateLookupTable()
end

local DEBUG_CANVAS = love.graphics.newCanvas()
--mainhook:GetHook("MouseMove"):Add("debug", function(x, y, dx, dy)
--    local r, g, b, a = DEBUG_CANVAS:newImageData():getPixel(x-1, y-1)
--end)
function map.DrawMap(stencil)
    love.graphics.push("all")
    love.graphics.setCanvas(map_canvas)
    love.graphics.clear()
    map_ent:Paint()
    love.graphics.setCanvas()
    love.graphics.reset()
    if stencil then
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
    end
    love.graphics.setShader(shader)
    --love.graphics.setCanvas(DEBUG_CANVAS)
    --love.graphics.clear()
    love.graphics.draw(map_canvas, 0, 0)
    --love.graphics.setCanvas()
    --love.graphics.draw(DEBUG_CANVAS, 0, 0)

    love.graphics.setShader()
    love.graphics.pop()
end

function map.ColorCountry(code, color)
    assert(color_lib_proxy[code], "Incorrect country code!: "..code)
    assert(#color == 4, "Expected 4 colors (RGBA). Received: "..#color)
    color_lib[color_lib_proxy[code]] = color

    map.UpdateLookupTable()
end
function map.GetColor(code)
    return color_lib[color_lib_proxy[code]]
end
function map.GetData(code)
    return loaded_data[code][current_slice+4]
end

function map.UpdateViewport()
    --[[
    local x1, y1 = camera:getWorldCoordinates(0, 0)
    local x2, y2 = camera:getWorldCoordinates(1920, 1080)
    for _, var in ipairs(map_ent[1]) do
        if util.CollisionRectangleRectangle(var.camposX1, var.camposY1, var.camposX2, var.camposY2, x1, y1, x2, y2) then
            if not var.isObservable then
                var.isObservable = true
                var.toLoad = true
            end
        else
            if var.isObservable then
                var.isObservable = false
                var.toUnload = true
            end
        end
    end
    map_ent:Update()
    ]]
end

function map.UpdateLookupTable()
    shader:send("color_table", unpack(color_lib))
end
return map