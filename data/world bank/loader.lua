local f
function ParseCSVLine(line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

f = ParseCSVLine("data/translator.csv", ";")


local function iter(t, i)
    while true do
        if t[i] then
            if tonumber(t[i]) then
                return tonumber(t[i])
            else
                i = i + 1
            end
        else
            return 0
        end
    end
end


local loader = function(path_data)
    local out = {}
    local counter = 1
    for var in love.filesystem.lines(path_data) do
        if counter >= 5 then
            local data = ParseCSVLine(var)
            for _, val in ipairs(data) do
                data[_] = tonumber(val) or val
            end
            for _, val in rpairs(data) do
                if val == "" then
                    data[_] = data[_+1] or 0
                end
            end
            
            data.code = data[2]
            out[data.code] = data
            table.insert(out, data)
        end
        counter = counter + 1
    end
    return out
end















return loader
