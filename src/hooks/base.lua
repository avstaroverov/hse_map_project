local lib = {}
do
    local base = {}
    function base:Add(identifier, func)
        assert(not self.hub[identifier], "Duplicating hook identifier!")
        table.insert(self.hub, func)
        self.hub[identifier] = #self.hub
    end
    function base:Call(identifier, ...)
        self.hub[self.hub[identifier]](...)
    end
    function base:Run(...)
        for _, var in ipairs(self.hub) do
            var(...)
        end
    end
    function base:Remove(identifier)
        table.remove(self.hub, self.hub[identifier])
        self.hub[identifier] = nil
    end
    function base:GetHub()
        return self.hub
    end
    lib.default = base
end
----------------------------------------------------
do
    local base = {}
    function base:Add(identifier, z, func)
        assert(not self.hub[identifier], "Duplicating hook identifier!")
        table.insert(self.hub[z], func)
        self.hub[identifier] = {#self.hub[z], z}
    end
    function base:Call(identifier, ...)
        self.hub[self.hub[identifier]](...)
    end
    function base:Run(...)
        for _, var in ipairs(self.hub) do
            for _, value in ipairs(var) do
                value(...)
            end
        end
    end
    function base:Remove(identifier)
        local var = table.remove(self.hub, identifier)
        table.remove(self.hub[var[2]], var[1])
    end
    function base:GetHub()
        return self.hub
    end
    lib.ordered = base
end

return lib