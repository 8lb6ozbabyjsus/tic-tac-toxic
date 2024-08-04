-- conf.lua
function love.conf(t)
    t.window.width = 1440  -- You can set these to your desired window size
    t.window.height = 1024
    t.window.fullscreen = true  -- Enable fullscreen
    t.window.resizable = true  -- Allow the window to be resizable
    t.window.vsync = 1  -- Enable vertical sync
end
