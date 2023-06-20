local tool_translator = function(path_data, path_dict, type)
    local dict = ParseCSVLine(path_dict, ";")
    local data = ""


    for var in love.filesystem.lines(path_data) do
		local s, e = var:find('data%-code="%a%a"')
		if s and e then
			local newcode = var:sub(s+11, e-1)
			for _, var in ipairs(dict) do
				if var[3] == newcode then
					newcode = var[2]
					break
				end
			end
			local l = var:gsub('data%-code="%a%a" fill="#ffffff', 'id="'..newcode..'" fill="#000000')
			data = data..l.."\n"
		end
    end

	return data
end
return tool_translator