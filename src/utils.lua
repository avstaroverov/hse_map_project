function ParseCSVLine(path,sep) 
	local res = {}
	sep = sep or ","
	for var in love.filesystem.lines(path) do
		var = var..sep --i mean duh, im too lazy
		local out = {}
		local b = 1
		while true do
			local x, y = var:find(sep, b, true)
			if x == nil then break end
			table.insert(out, var:sub(b, x-1))
			b = y + 1
		end
		table.insert(res, out)
	end
	return res
end



function mix(x, y, a)
	return x*(1-a)+y*a
end

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function rpairs(t)
    return reversedipairsiter, t, #t + 1
end

function dump(o, nest)
    nest = (nest or "").."  "
    if type(o) == 'table' then
        for k,v in pairs(o) do
            if type(v) == 'table' then 
                print(k)
                dump(v, nest)
            else
                print(k, type(v), v)
            end
        end
    end
end

function min(t)
	local m
	for _, var in ipairs(t) do
		if type(var) == "number" then
			m = m and math.min(m, var) or var
		end
	end
	return m
end
function max(t)
	local m
	for _, var in ipairs(t) do
		if type(var) == "number" then
			m = m and math.max(m, var) or var
		end
	end
	return m
end


---@diagnostic disable: need-check-nil
-------------------------------------
-- library with usefull code stuff --
-------------------------------------

-------------------------------------------------------------
-- also i want to fucking die after i did this plz kill me --
-------------------------------------------------------------

--------------------------------------------------------------------------------
-- after you read this code you might wanna call it       8 (346) 646-80-63 --
--------------------------------------------------------------------------------



local util = {}

local function ignoreComments(line)
    --util.trim(line)
    local startcomm = string.find(line, "--", 1, true)
    line = string.sub(line, 0, startcomm - 1)
    return line
end

local function ignoreStartText(line)
    local endtext = string.find(line, "=", 1, true)
    line = string.sub(line, endtext + 2)
    return line
end

-------------------------------------------------------------------------------------------------------------------------

function util.replaceInFile(path, old, new, additionalOld)         --I'll use this one for settings, but the other ones will just... uhm... exist
    if additionalOld ~= nil then
        local line = util.findTextLine(additionalOld..old, path)
    else
        local line = util.findTextLine(old, path)
    end
end

function util.findNumLine(num, file)
    local counter = 0
	for line in love.filesystem.lines(file) do
		counter = counter + 1

		if counter == num then
            do return line end
            break
		end
	end
end

function util.findTextNum(text, path) -- this one wont work if file is way to big, consider using util.findTextLine()
    local file = io.open(path, "r")
    file1 = file:read("a")
    local first, last = string.find(file1, text, 1, true)

    return first, last
end

function util.findTextLine(text, file)
    local counter = 0
	for line in love.filesystem.lines(file) do
		counter = counter + 1

		if string.match (line, text) then
            do return line, counter end
            break
		end
	end
end

function util.writeOn(path, num, text)
    local file = io.open(path, "r+")
    file:seek("set", num)
    file:write(text)

    --[[local counter = 0
	for line in love.filesystem.lines(file) do
		counter = counter + 1

		if counter == num then
            do return line end
            break
		end
	end]]--
end

function util.trim(s)
    return s:match( "^%s*(.-)%s*$" )
end

function util.cloneTable(table, selfref)
    local selfref = selfref or {}
    local table_type = type(table)
    local copy
    if table_type == 'table' and not selfref[table] then
        copy = {}
        selfref[table] = table
        for orig_key, orig_value in next, table, nil do
                copy[util.cloneTable(orig_key, selfref)] = util.cloneTable(orig_value, selfref)
        end
        setmetatable(copy, util.cloneTable(getmetatable(table)))
    else
        copy = table
    end
    return copy
end

function util.MergeTables(first_table, second_table)
    for k,v in pairs(second_table) do 
        if type(v) == "table" then
            first_table[k] = {}
            util.MergeTables(first_table[k], v)
        else
            first_table[k] = v 
        end
    end
end

local function HiddenIteration(folder, tbl)
    local files = love.filesystem.getDirectoryItems(folder)
    for k, file in ipairs(files) do
        if love.filesystem.getInfo(folder.."/"..file)["type"] == "directory" then
            HiddenIteration(folder.."/"..file, tbl)
        end

        if love.filesystem.getInfo(folder.."/"..file)["type"] == "file" then
            table.insert(tbl, folder.."/"..file)
        end
    end

    return tbl
end
function util.IterateThroughFolder(folder, search_folder)
    if not love.filesystem.getInfo(folder) then error("util.IterateThroughFolder('"..folder.."')".."  --> No such was directory found") end

    local tbl = {}

    local files = love.filesystem.getDirectoryItems(folder)
    for k, file in ipairs(files) do
        if search_folder then
            if love.filesystem.getInfo(folder.."/"..file)["type"] == "directory" then
                table.insert(tbl, folder.."/"..file)
            end
        else
            if love.filesystem.getInfo(folder.."/"..file)["type"] == "directory" then
                HiddenIteration(folder.."/"..file, tbl)
            end

            if love.filesystem.getInfo(folder.."/"..file)["type"] == "file" then
                table.insert(tbl, folder.."/"..file)
            end
        end
    end

    return tbl
end

function util.realScreenScale()
    local width = love.graphics.getWidth()
    return width / 1920
end

function util.ScrW()
    local width = love.graphics.getWidth()
    return width
end

function util.ScrH()
    local height = love.graphics.getHeight()
    return height
end

function util.convertToRealSize(width, height)
    width = util.ScrW() / 100 * width
    height = util.ScrH() / 100 * height
    return width, height
end

function util.GetRandomPointInCircle(radius)
    math.randomseed(math.random())
    local a = math.random() * 2 * math.pi
    local innerradius = radius * math.sqrt(math.random())

    local x = innerradius * math.cos(a)
    local y = innerradius * math.sin(a)

    return x, y
end

function util.readCollisionData(path, Xoffset, Yoffset)
    local image = love.image.newImageData(path)
    local w, h = image:getDimensions()
    local data = {}
    local dataX = {}
    local dataY = {}
    local killme = 0

    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local g1, _, _, g4 = image:getPixel(x, y)
            if g4 == 1 then                                                     
                dataX[g1*255] = x + (Xoffset or 0)
                dataY[g1*255] = y + (Yoffset or 0)
            end
        end
    end

    for index, var in ipairs(dataX) do
        data[index+killme] = dataX[index]
        killme = killme + 1
        data[index+killme] = dataY[index]
    end

    return data
end


function util.normalize(x,y) 
    local l=(x*x+y*y)^.5 
    if l==0 then 
        return 0,0,0 
    else 
        return x/l,y/l,l 
    end 
end

function util.round(num)
    return (num >= 0 and math.floor(num + 0.5)) or (num <= 0 and math.floor(num))
end

function util.Gaussian()
    return  math.sqrt(-2 * math.log(love.math.random())) *
            math.cos(2 * math.pi * love.math.random())
end

function util.Dump(o, nest)
    nest = (nest or "").."  "
    if type(o) == 'table' then
        for k,v in pairs(o) do
            if type(v) == 'table' then 
                print(k)
                util.Dump(v, nest)
            else
                print(k, v)
            end
        end
    end
end

function util.Split(inputstr, sep)
    local t={}
    for str in string.gmatch(inputstr, "([^"..(sep or "%s").."]+)") do
        table.insert(t, str)
    end
    return t
end


function util.CollideLines(a, b, c, d)
        local uA = ((d[1]-c[1])*(a[2]-c[2]) - (d[2]-c[2])*(a[1]-c[1])) / ((d[2]-c[2])*(b[1]-a[1]) - (d[1]-c[1])*(b[2]-a[2]));
        local uB = ((b[1]-a[1])*(a[2]-c[2]) - (b[2]-a[2])*(a[1]-c[1])) / ((d[2]-c[2])*(b[1]-a[1]) - (d[1]-c[1])*(b[2]-a[2]));
        return uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1
end

function util.CollisionPointRectangle(x, y, x1, y1, x2, y2)
    return x > x1 and x < x2 and y > y1 and y < y2
end

function util.CollisionRectangleRectangle(x1,y1,x2,y2, x3,y3,x4,y4) 
    print(x1,y1,x2,y2, x3,y3,x4,y4)
    return x1 < x4 and
           x3 < x2 and
           y1 < y4 and
           y3 < y2
end

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function rpairs(t)
    return reversedipairsiter, t, #t + 1
end

--monkey patching yeaaaah
local t = type
function type(val)
    return getmetatable(val) and getmetatable(val).__type or t(val)
end
local lc = love.graphics.setColor
---@diagnostic disable-next-line: duplicate-set-field, redundant-parameter
function love.graphics.setColor(r, g, b, a)
    if t(r) == "string" then
        lc(tonumber(string.sub(r, 2, 3), 16), tonumber(string.sub(r, 4, 5), 16), tonumber(string.sub(r, 6, 7), 16), g or 1)
    elseif r == nil then    
        lc(1, 1, 1)
    elseif r > 1 and g > 1 and b > 1 then
---@diagnostic disable-next-line: param-type-mismatch
        lc(love.math.colorFromBytes(r, g, b))
    else
        lc(r, b, g, a)
    end
end

function util.IsoToPlanarMesh(size_x, size_y)
    local ox, oy = size_x/math.sqrt(2), size_y/math.sqrt(2)
    local mesh = love.graphics.newMesh({
        {0, oy, 0, 1},
        {oy, 0, 0, 0},
        {ox + oy, ox, 1, 0},
        {ox, ox + oy, 1, 1}
    })
    local canvas = love.graphics.newCanvas(size_x, size_y)
    mesh:setTexture(canvas)
    return mesh, canvas
end

function util.Dist(x1, y1, x2, y2)
    return math.sqrt(math.pow(x2-x1, 2)+math.pow(y2-y1, 2))/2
end

function util.Stack(stacksize)
    local t = {}
    t.f = function() end
    function t:AddStack(val)
        table.insert(self, val)
        if #self > stacksize then
            self.f(table.remove(self, 1))
        end
        return #self
    end
    function t:ClearAfter(i)
        local curr = stacksize
        while curr > i do
            self.f(table.remove(self, curr))
            curr = curr - 1
        end
    end
    function t:DoWithRemoved(f)
        self.f = f
    end
    return t
end


function util.ParseCSVLine(path,sep) 
	local res = {}
	sep = sep or ","
	for var in love.filesystem.lines(path) do
		var = var..sep --i mean duh, im too lazy
		local out = {}
		local b = 1
		while true do
			local x, y = var:find(sep, b, true)
			if x == nil then break end
			table.insert(out, var:sub(b, x-1))
			b = y + 1
		end
		table.insert(res, out)
	end
	return res
end

--[[
local vec2_m = {}
vec2_m.__newindex = function(t, k, v)
    v = tonumber(v)
    if k == "x" or k == 1 then
        t.x = v
        t[1] = v
    elseif k == "y" or k == 2 then
        t.y = v
        t[2] = v
    else
        error("Vec2 does not support other keys but [x, y, 1, 2]!")
    end
end

vec2_m.__name = "Vec2"
vec2_m.__sub = function(t1, t2)
    assert(type(t1) == "Vec2" and (type(t2) == "Vec2" or type(t2) == "number"), "Unsupported operand!")
    if type(t2) == "number" then
        t1.x = t1.x - t2
        t1.y = t1.y - t2
    else
        t1.x = t1.x - t2.x
        t1.y = t1.y - t2.y
    end
    return t1
end
vec2_m.__mul = function(t1, t2)
    assert(type(t1) == "Vec2" and (type(t2) == "Vec2" or type(t2) == "number"), "Unsupported operand!")
    if type(t2) == "number" then
        t1.x = t1.x * t2
        t1.y = t1.y * t2
    else
        t1.x = t1.x * t2.x
        t1.y = t1.y * t2.y
    end
    return t1
end
vec2_m.__mul = function(t1, t2)
    assert(type(t1) == "Vec2" and (type(t2) == "Vec2" or type(t2) == "number"), "Unsupported operand!")
    if type(t2) == "number" then
        t1.x = t1.x * t2
        t1.y = t1.y * t2
    else
        t1.x = t1.x * t2.x
        t1.y = t1.y * t2.y
    end
    return t1
end

function Vec2(x, y)


end
]]






return util