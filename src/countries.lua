countries = {}

local dataAliases = {
    GDP = "data/gdp.csv"
}

local function HexToRgb(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16), tonumber(string.sub(hex, 4, 5), 16), tonumber(string.sub(hex, 6, 7), 16), value or 1}
end
  

local function linear(data, colors)
    local temp = {}

    local data_norm = {}
    local ratio = 0
    for _, var in ipairs(data) do
        ratio = math.max(ratio, var[2])
    end
    for _, var in ipairs(data) do
        temp[var[1]] = var[2]
        data_norm[var[1]] = var[2]/ratio
    end

    local scale_start = HexToRgb(colors[1])
    local scale_end = HexToRgb(colors[2])

    local scale_diff_r = scale_end[1] - scale_start[1]
    local scale_diff_g = scale_end[2] - scale_start[2]
    local scale_diff_b = scale_end[3] - scale_start[3]

    local out = {}
    for _, var in pairs(data_norm) do
        out[_] = {var*scale_diff_r + scale_start[1], var*scale_diff_g + scale_start[2], var*scale_diff_b + scale_start[3]}
    end

    return out
end

function countries.LoadMap(norm, scale, data)
    --[[
    local loaded_data = linear(ParseCSVLine(dataAliases[data], ";"), scale)
    --local l = require("data.world bank.loader")
    --local loaded_data = linear(l("data/world bank/API_SP.POP.TOTL_DS2_en_csv_v2_4770387.csv"), scale)
    local svgData = love.filesystem.read("assets/countries/countries.svg")
    for i, var in pairs(loaded_data) do
        svgData = svgData:gsub('id="'..i..'" fill="#000000', 'id="'..i..'" fill="'..string.format("#%02X%02X%02X", var[1],var[2],var[3]))
    end
    local graphics = tove.newGraphics(svgData, 8000)
    graphics:setDisplay("mesh", "adaptive", 4096)
    return graphics
    ]]

    return require("src.map_engine.2D.map").LoadMap(norm, scale, data)
end

function countries.ColorCountry(code, color)
    love.graphics.setCanvas(countries.canvas)
    
    

    love.graphics.setCanvas()
end