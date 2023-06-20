local useSlider = require("dependencies.helium.shell.slider")


return helium(function(param, view)
    local slider, handle = useSlider({
		min = 1960,
		max = 2021,
		value = 1,
		divider = 1,
	}, view.w-20, view.h,
	function(val)
		map.UpdateYear(val)
        print(val)
	end,nil,nil,nil,nil,nil, 10)

    return function()
		love.graphics.setColor(0.668, 0.668, 0.668)
		love.graphics.rectangle('fill', 10, 6, view.w-20, view.h-12, 5, 5)
		if handle.down or handle.over then
			love.graphics.setColor(0.768, 0.85, 0.768)
		else
			love.graphics.setColor(0.768, 0.768, 0.768)
		end
		love.graphics.rectangle('fill', 10, 6, (view.w-20)*slider.value/1, view.h-12, 5, 5)
		if handle.down or handle.over then
			love.graphics.setColor(0.95, 0.95, 0.95)
		else
			love.graphics.setColor(0.7, 0.7, 0.7)
		end
		local dim = math.min(view.w, view.h)
		love.graphics.rectangle('fill', handle.x-dim/4, handle.y, dim/2, dim)
		if handle.down then
			love.graphics.setColor(0.9, 0.9, 0.9)
			love.graphics.rectangle('fill', (handle.x-dim/4)+3, handle.y+3, (dim/2)-6, dim-6)
		end
	end
end)