local scene = helium.scene.new(true)
local ui = {}
ui.scene = scene
ui.lib = {}
ui.lib.selection_window = require("src.gui.selection_popup")
ui.lib.year_slider = require("src.gui.year_slider")

scene:activate()
local mode = helium(function(param, view)
    helium.core.input('clicked', function()
		MODE = param.text
	end)

	return function()
		love.graphics.setColor(0.3, 0.3, 0.3)
		love.graphics.rectangle('fill', 0, 0, view.w, view.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(param.text)
	end
end)
local element1 = mode({text = 'Pencil'}, 50, 50)
local element2 = mode({text = 'Hand'}, 50, 50)
element1:draw(10, 150)
element2:draw(70, 150)


local scale = helium(function(param, view)
    helium.core.input('clicked', function()
		draw:Scale(param.text)
	end)

	return function()
		love.graphics.setColor(0.3, 0.3, 0.3)
		love.graphics.rectangle('fill', 0, 0, view.w, view.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(param.text)
	end
end)
local element1 = scale({text = 0.1}, 50, 50)
local element2 = scale({text = -0.1}, 50, 50)
element1:draw(10, 220)
element2:draw(70, 220)


local year_slider = ui.lib.year_slider(200, 20)
year_slider:draw(10, 300)

function ui.Get(name)
	return ui.lib[name]
end


return ui
