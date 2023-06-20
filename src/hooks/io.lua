local updatehook = mainhook:NewHook("Updatehook")
local mousemove = mainhook:NewHook("MouseMove")
local mousepressed = mainhook:NewHook("MousePressed")
local mousereleased = mainhook:NewHook("MouseReleased")
local keypressed = mainhook:NewHook("KeyPressed")
local keyreleased = mainhook:NewHook("KeyReleased")
local wheelmoved = mainhook:NewHook("WheelMoved")
local postdraw = mainhook:NewHook("PostDraw")

function love.mousemoved(x, y, dx, dy, istouch)
    mousemove:Run(x, y, dx, dy, istouch)
end
function love.mousepressed(x, y, button, istouch, presses)
    mousepressed:Run(x, y, button, istouch, presses)
end
function love.mousereleased(x, y, button, istouch, presses)
    mousereleased:Run(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
    keypressed:Run(key, scancode, isrepeat)
end
function love.keyreleased(key, scancode, isrepeat)
    keyreleased:Run(key, scancode, isrepeat)
end

function love.wheelmoved(x, y)
    wheelmoved:Run(x, y)
end