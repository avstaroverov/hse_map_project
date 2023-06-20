local hook = {}

local cwd = ... .. "."
local base_default = require(cwd.."base").default
local base_ordered = require(cwd.."base").ordered

function hook:New()
    local h = {}
    local hook_lib = {}
    function h:NewHook(identifier)
        local n = {}
        n.hub = {}
        setmetatable(n, {__index = base_default, __type = "DefaultHook"})
        hook_lib[identifier] = n
        return n
    end
    function h:NewOrderedHook(identifier, size)
        local n = {}
        n.hub = {}
        for x = 1, size do
            n.hub[x] = {}
        end
        setmetatable(n, {__index = base_ordered, __type = "OrderedHook"})
        hook_lib[identifier] = n
        return n
    end
    function h:RemoveHook(identifier)
        table.remove(hook_lib, identifier)
    end
    function h:GetHook(identifier)
        return hook_lib[identifier]
    end
    function h:GetHookLib()
        return hook_lib
    end
    return h
end


mainhook = hook:New()
require(cwd.."io")


return hook