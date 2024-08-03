-- main.lua
local menu = require "src.states.menu"
local currentState = menu

function love.load()
    menu.enter()
end

function love.update(dt)
    if currentState then
        currentState.update(dt)
    end
end

function love.draw()
    if currentState then
        currentState.draw()
    end
end

function love.keypressed(key)
    if currentState then
        currentState.keypressed(key)
    end
end
