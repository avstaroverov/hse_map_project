local check_draw = false

mainhook:GetHook("MousePressed"):Add("DrawMap", function( x, y, button, istouch, presses )
    if button == 1 then
        if MODE == "Pencil" then
            draw:AddLine(x, y) 
        elseif MODE == "Hand" then

        end
        check_draw = true
    end
end)

local selection_prev
local selection_prev_c
local selection_window = ui2.CreateUI("selection_popup", ui2.GetUnique("Map C"))

mainhook:GetHook("MouseMove"):Add("MoveMap", function( x, y, dx, dy, istouch )
    if check_draw then
        
        --UBER CRINGE
        pcall(function() map.ColorCountry(selection_prev, selection_prev_c) end)
        selection_prev = nil
        selection_window.curr = nil

        if MODE == "Pencil" then
            draw:AddPoint(x, y)
        elseif MODE == "Hand" then
            draw:Translate(dx, dy)
            --map.UpdateViewport()
        end
    else
        if MODE == "Hand" then
            


            --[[
            local p = graphics.paths
            local check = true
            for i = 1, p.count do
                local path = p[i]
                if path:inside(draw:ConvertToTransform(x, y)) then
                    if not selection_prev then 
                        selection_prev = path.id
                        selection_prev_c = map.GetColor(path.id)
                        map.ColorCountry(path.id, {0.3, 0.3, 0.3, 1})
                    elseif selection_prev.id == path.id then
                    else
                        pcall(function() map.ColorCountry(selection_prev, selection_prev_c) end)
                        selection_prev = path.id
                        selection_prev_c = map.GetColor(path.id)
                        if pcall(function() map.ColorCountry(path.id, {0.3, 0.3, 0.3, 1}) end) then
                            selection_window.curr = path.id
                        end
                    end
                    check = false
                end
            end
            if check then
                pcall(function() map.ColorCountry(selection_prev, selection_prev_c) end)
                selection_prev = nil
                selection_window.curr = nil
            end
            ]]
        end
    end
end)

local y = 1960

mainhook:GetHook("KeyPressed"):Add("UpdateYear", function(key)
    if key == "right" then
        y = y + 1
        map.UpdateYear(y)
    elseif key == "left" then
        y = y - 1
        map.UpdateYear(y)
    elseif key == "a" then
        COLOR_UPDATE = {}
    end
end)

mainhook:GetHook("MouseReleased"):Add("UpdateYear", function(x, y, button, istouch, presses)
    check_draw = false
end)

mainhook:GetHook("WheelMoved"):Add("MoveMap", function(x, y)
    if MODE == "Hand" or MODE == "Pencil" then
        draw:Scale(y/100, love.mouse.getPosition())
    end
end)
