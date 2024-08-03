-- src/states/menu.lua
local menu = {}
local selection = 1
local options = {"Play vs Computer", "Play Locally", "Play Online", "Exit"}
local difficulties = {"Easy", "Medium", "Hard"}
local difficulty = "Easy"
local state = "main"
local currentState = nil
local gameplay = require "src.states.gameplay"

local backgroundImage
local bgWidth, bgHeight

-- Button images
local buttons = {}
local hoveredButtons = {}
local buttonWidth, buttonHeight

function loadButtonImage(name)
    local image = love.graphics.newImage(name)
    if not image then
        error("Failed to load image: " .. name)
    end
    return image
end

function menu.enter()
    -- Load menu assets and initialize menu state
    selection = 1
    state = "main"
    backgroundImage = loadButtonImage("assets/ui/mainbg.png")
    bgWidth, bgHeight = backgroundImage:getDimensions()

    -- Load button images
    buttons["Play vs Computer"] = loadButtonImage("assets/ui/ComputerBut.png")
    buttons["Play Locally"] = loadButtonImage("assets/ui/LocalBut.png")
    buttons["Play Online"] = loadButtonImage("assets/ui/OnlineBut.png")
    buttons["Exit"] = loadButtonImage("assets/ui/Exitbut.png")

    -- Load hover button images
    --hoveredButtons["Play vs Computer"] = loadButtonImage("assets/ui/ComputerBut_hover.png")
    --hoveredButtons["Play Locally"] = loadButtonImage("assets/ui/LocalBut_hover.png")
    --hoveredButtons["Play Online"] = loadButtonImage("assets/ui/OnlineBut_hover.png")
    --hoveredButtons["Exit"] = loadButtonImage("assets/ui/ExitX_hover.png")

    buttonWidth, buttonHeight = 200,45
end

function menu.update(dt)
    -- Handle input for menu navigation
    if love.keyboard.isDown("down") then
        selection = math.min(selection + 1, #options)
        love.timer.sleep(0.2) -- Simple debounce
    elseif love.keyboard.isDown("up") then
        selection = math.max(selection - 1, 1)
        love.timer.sleep(0.2) -- Simple debounce
    elseif love.keyboard.isDown("return") then
        menu.selectOption()
    end
end

function menu.draw()
    -- Calculate scaling and centering
    local scaleX = love.graphics.getWidth() / bgWidth
    local scaleY = love.graphics.getHeight() / bgHeight
    local scale = math.min(scaleX, scaleY)
    local offsetX = (love.graphics.getWidth() - bgWidth * scale) / 2
    local offsetY = (love.graphics.getHeight() - bgHeight * scale) / 2

    love.graphics.draw(backgroundImage, offsetX, offsetY, 0, scale, scale)

    -- Define container dimensions
    local containerWidth = love.graphics.getWidth() * 0.3
    local containerHeight = love.graphics.getHeight() * 0.2
    local containerX = (love.graphics.getWidth() - containerWidth) / 1
    local containerY = (love.graphics.getHeight() - containerHeight) / 1 + 50

    -- Calculate button scale to fit in the container
    local buttonScale = containerWidth / buttonWidth
    local buttonSpacing = 20
    local totalButtonHeight = (#options * buttonHeight * buttonScale) + ((#options - 1) * buttonSpacing)

    -- Adjust yStart to center buttons within the container
    local yStart = containerY + (containerHeight - totalButtonHeight) / 2

    if state == "main" then
        for i, option in ipairs(options) do
            local y = yStart + (i - 1) * (buttonHeight * buttonScale + buttonSpacing)
            local buttonX = containerX + (containerWidth - buttonWidth * buttonScale) / 2
            if i == selection then
                -- Draw shadow for hovered button
                love.graphics.setColor(0, 0, 0, 0.5) -- Shadow color
                love.graphics.rectangle("fill", buttonX + 5, y + 5, buttonWidth * buttonScale, buttonHeight * buttonScale)
                love.graphics.setColor(1, 1, 1, 1) -- Reset color

                --love.graphics.draw(hoveredButtons[option], buttonX, y, 0, buttonScale, buttonScale)
            else
                love.graphics.draw(buttons[option], buttonX, y, 0, buttonScale, buttonScale)
            end
        end
    elseif state == "difficulty" then
        love.graphics.printf("Select Difficulty", 0, containerY / 4, containerWidth, "center")

        for i, diff in ipairs(difficulties) do
            local color = (i == selection) and {1, 1, 0} or {1, 1, 1} -- Highlight selection
            love.graphics.setColor(color)
            love.graphics.printf(diff, 0, yStart + (i - 1) * (buttonHeight * buttonScale + buttonSpacing), containerWidth, "center")
        end
    end
end


function menu.selectOption()
    if state == "main" then
        if options[selection] == "Play vs Computer" then
            state = "difficulty"
        elseif options[selection] == "Play Locally" then
            print("Starting local game")
            currentState = gameplay
            currentState.enter("local")
        elseif options[selection] == "Play Online" then
            print("Preparing for online play")
            currentState = gameplay
            currentState.enter("online")
        elseif options[selection] == "Exit" then
            love.event.quit()
        end
    elseif state == "difficulty" then
        difficulty = difficulties[selection]
        print("Difficulty selected: " .. difficulty)
        currentState = gameplay
        currentState.enter("computer", difficulty)
    end
end

function menu.keypressed(key)
    -- Handle menu input for navigation and selection
end

return menu
