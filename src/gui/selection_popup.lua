local elem = helium(function(param, view)
	return function()
		love.graphics.setColor(0.3, 0.3, 0.3)
		love.graphics.rectangle('fill', 0, 0, view.w, view.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(param.name)
		love.graphics.print(param.value, 0, 30)
	end
end)
return elem