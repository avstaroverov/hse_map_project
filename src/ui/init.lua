---@enum ui_piece



local cwd = ...

local ui = {}

local hub = {}

local ui_lib = {}

local unique_names = {}

local base = {__index = require(cwd..".base")}


local main = require(cwd..".blank")
setmetatable(main, base)
main:__precreate()
main:onCreate()



---Creates the UI Piece from the "name" and ties it to the "father". Additional arguments are passed to :onCreate()
---@param name string
---@param father ui_piece
---@return ui_piece
function ui.CreateUI(name, father, ...)
    assert(ui_lib[name], "Incorrect UI name: "..name)

    local ent = {}
    setmetatable(ent, {__index = ui_lib[name]})
    table.insert(hub, ent)
    ent:__precreate();
    if not ent.Detached then
        ent:SetFather(father or main)
    end
    ent:onCreate(...)

    return ent
end

---Compiles the UI piece to be later created, does not add it to the main library (can't be created via CreateUI)
---<br>Simply store the function and run when needed with specified father if neccessary
---@param code table
---@return fun(father: ui_piece, ...)
function ui.Compile(code)
    assert(type(code)=="table", "Expected table, got: "..type(code))
    return function(father, ...)
        local ent = {}
        setmetatable(ent, {__index = code})
        table.insert(hub, ent)
        ent:__precreate();
        if not ent.Detached then
            ent:SetFather(father or main)
        end
        ent:onCreate(...)
    end
end

require(cwd..".base").CreateUI = function(self, name, ...)
    return ui.CreateUI(name, self, ...)
end

---Returns an UI Piece with an unique id that was set using :SetUniqueName(). 
---@param id any
---@return ui_piece 
function ui.GetUnique(id)
    return unique_names[id]
end

---Draws the default UI Piece. Every UI Piece that is not connected to others is connected to it.
function ui.Draw()
    main:Draw()
end

local clickproxy = {}
mainhook:GetHook("MousePressed"):Add("UIclick", function(x, y)
    for _, var in ipairs(hub) do
        if var.Clickable and not var.disable then
            if x > var.absposX and x < var.absposX + var.sizeX and y > var.absposY and y < var.absposY + var.sizeY then
                var:onPress(x, y)
                clickproxy[var] = true
            else
                clickproxy[var] = false
            end
        end
    end
end)
mainhook:GetHook("MouseReleased"):Add("UIclick", function(x, y)
    for _, var in ipairs(hub) do
        if var.Clickable and not var.disable and clickproxy[var] then
            if x > var.absposX and x < var.absposX + var.sizeX and y > var.absposY and y < var.absposY + var.sizeY then
                var:onClick(x, y)
            else
                var:onFailedClick(x, y)
            end
            var:onRelease(x, y)
            clickproxy[var] = false
        end
    end
end)


print("LOADING UI ELEMENTS:")
for _, var in ipairs(util.IterateThroughFolder(cwd:gsub("%.", "%/").."/presets")) do
    local piece = require(var:sub(0, -5))
    ui_lib[piece.id or var:match('[^/]+$'):sub(0, -5)] = piece
    print("    PRESET: ", var:match('[^/]+$'):sub(0, -5))
end
for _, var in ipairs(util.IterateThroughFolder("ui")) do
    local piece = require(var:sub(0, -5))
    ui_lib[piece.id or var:match('[^/]+$'):sub(0, -5)] = piece
    print("    USER DEFINED: ", var:match('[^/]+$'):sub(0, -5))
end
print("FINISHED!")

for _, var in pairs(ui_lib) do
    setmetatable(var, base)
    var:__init(unique_names)
    var:Init(ui)
end

return ui