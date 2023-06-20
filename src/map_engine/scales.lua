local scales = {}

local function HexToRgb(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16), tonumber(string.sub(hex, 4, 5), 16), tonumber(string.sub(hex, 6, 7), 16), value or 1}
end

function scales.Linear(data, colors, countries, slice)
    local data_norm = {}
    local ratio = 0
    for _, var in ipairs(data) do
        if countries[var["Country Code"]] then
            ratio = math.max(ratio, var[slice+4] or 0)
        end
    end
    for _, var in ipairs(data) do
        data_norm[var["Country Code"]] = (var[slice+4] or 0)/ratio
    end

    local scale_start = HexToRgb(colors[1])
    local scale_end = HexToRgb(colors[2])

    local scale_diff_r = scale_end[1] - scale_start[1]
    local scale_diff_g = scale_end[2] - scale_start[2]
    local scale_diff_b = scale_end[3] - scale_start[3]

    local index = {}
    local proxy = {}
    for _, var in pairs(data_norm) do
        table.insert(proxy, {(var*scale_diff_r + scale_start[1])/256, (var*scale_diff_g + scale_start[2])/256, (var*scale_diff_b + scale_start[3])/256, 1})
        index[_] = proxy[#proxy]
    end

    return index, proxy
end

function scales.Log(data, colors, countries, slice)
    local data_norm = {}
    local ratio = 0
    for _, var in ipairs(data) do
        if countries[var["Country Code"]] then
            ratio = math.max(ratio, var[slice+4] or 0)
        end
    end
    for _, var in ipairs(data) do
        data_norm[var["Country Code"]] = math.log((var[slice+4] or 0))/math.log(ratio)
    end

    local scale_start = HexToRgb(colors[1])
    local scale_end = HexToRgb(colors[2])

    local scale_diff_r = scale_end[1] - scale_start[1]
    local scale_diff_g = scale_end[2] - scale_start[2]
    local scale_diff_b = scale_end[3] - scale_start[3]

    local index = {}
    local proxy = {}
    for _, var in pairs(data_norm) do
        table.insert(proxy, {(var*scale_diff_r + scale_start[1])/256, (var*scale_diff_g + scale_start[2])/256, (var*scale_diff_b + scale_start[3])/256, 1})
        index[_] = proxy[#proxy]
    end

    return index, proxy
end

return scales
