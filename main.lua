--loading screen
if love.graphics.isActive() then
    local image = love.graphics.newImage("assets/menu/loading.png")
    love.graphics.origin()
	love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.draw(image, 0, 0)
    love.graphics.print("THIS IS A PLACEHOLDER IMAGE I FOUND ONLINE", 1920/2-(love.graphics.getFont():getWidth("THIS IS A PLACEHOLDER IMAGE I FOUND ONLINE")/2), 800)
    love.graphics.present()
end



helium = require("dependencies.helium")
tove = require("dependencies.tove")
json = require("dependencies.json")
nativefs = require("dependencies.nativefs")
--https = require("dependencies.https")

hook = require("src.hooks")

util = require("src.utils")
--ui = require("src.hell")
ui2 = require("src.ui")

require("src.countries")
require("src.draw")
require("src.io")

MAPMODE = false
MODE = "Hand"

COLOR_UPDATE = {}

camera = require("dependencies.brady")(1920, 1080, {offsetX = -4000, offsetY = -2080})



--print(require("data.translator")("assets/countries/countries.svg", "data/translator.csv"))
--error()
map = require("src.map_engine.2D.map")

local mm = ui2.CreateUI("mm_container")
function love.draw()
    
    
    love.graphics.reset()



    ui2:Draw()


    love.graphics.setBackgroundColor(1, 1, 1, 1)

    love.graphics.setColor(0,0,0)
    local stats = love.graphics.getStats()

    local str = string.format("Estimated amount of texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
    local ram = string.format("Current Lua RAM: %.2f", collectgarbage("count") / 1024 / 1024)
    local dc = string.format("Current Draw Calls: " .. stats.drawcalls)
    local cs = string.format("Current Canvas Switches: " .. stats.canvasswitches)
    local ss = string.format("Current Shader Switches: " .. stats.shaderswitches)
    local dcb = string.format("Current Drawcalls Batched: " .. stats.drawcallsbatched)
    local dt = string.format("Current Delta Time: " .. love.timer.getDelta())
    local sc = string.format("Current Scale: " .. camera.scale)
    love.graphics.print(str, 10, 10)
    love.graphics.print(ram, 10, 30)
    love.graphics.print(dc, 10, 50)
    love.graphics.print(cs, 10,  70)
    love.graphics.print(ss, 10, 90)
    love.graphics.print(dcb, 10, 110)
    love.graphics.print(sc, 10, 130)

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 150)
    love.graphics.print("Current Mode: "..tostring(MODE), 10, 170)
    love.graphics.print("Current Year: "..tostring(YEAR or 1), 10, 190)
 
    love.graphics.setColor(1,1,1)
    --ui.scene:draw()

    mainhook:GetHook("PostDraw"):Run()
end
--125

--run a shader that has every country stored as a texture in an array which checks if pixels are the same to make selection suppa fasto