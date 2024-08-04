-- src/states/menu.lua
local menu = {}
local selection = 1
local options = {"Play vs Computer", "Play Locally", "Play Online", "Exit"}
local difficulties = {"Easy", "Medium", "Hard", "Return to Main Menu"}
local difficulty = "Easy"
local state = "main"
local currentState = nil
local gameplay = require "src.states.gameplay"

local backgroundImage
local bgWidth, bgHeight

-- Button images
local buttons = {}
local hoveredButtons = {}
local difficultyButtons = {}
local difficultyHButtons = {}
local buttonWidth, buttonHeight

-- Error image
local errorImage

-- Track loading errors
local imageLoadErrors = {}

function loadButtonImage(name)
    local success, image = pcall(love.graphics.newImage, name)
    if not success then
        print("Failed to load image: " .. name .. ". Using error image.")
        image = errorImage
        table.insert(imageLoadErrors, name)
    end
    return image
end

function menu.enter()
    -- Load menu assets and initialize menu state
    selection = 1
    state = "main"

    -- Load the error image
    errorImage = love.graphics.newImage("assets/ui/error.png")

    -- Load the background image
    backgroundImage = loadButtonImage("assets/ui/mainbg.png")
    bgWidth, bgHeight = backgroundImage:getDimensions()

    -- Load button images
    buttons["Play vs Computer"] = loadButtonImage("assets/ui/ComputerBut.png")
    buttons["Play Locally"] = loadButtonImage("assets/ui/LocalBut.png")
    buttons["Play Online"] = loadButtonImage("assets/ui/OnlineBut.png")
    buttons["Exit"] = loadButtonImage("assets/ui/Exitbut.png")

    -- Load hover button images
    hoveredButtons["Play vs Computer"] = loadButtonImage("assets/ui/ComputerBut_hover.png")
    hoveredButtons["Play Locally"] = loadButtonImage("assets/ui/LocalBut_hover.png")
    hoveredButtons["Play Online"] = loadButtonImage("assets/ui/OnlineBut_hover.png")
    hoveredButtons["Exit"] = loadButtonImage("assets/ui/Exitbut_hover.png")

    --Load difficulty button images
    difficultyButtons["Easy"] = loadButtonImage("assets/ui/EasyBut.png")
    difficultyButtons["Medium"] = loadButtonImage("assets/ui/MediumBut.png")
    difficultyButtons["Hard"] = loadButtonImage("assets/ui/HardBut.png")
    difficultyButtons["Return to Main Menu"] = loadButtonImage("assets/ui/ReturnBut.png")

    --Load difficulty hover button images
    difficultyHButtons["Easy"] = loadButtonImage("assets/ui/EasyBut_hover.png")
    difficultyHButtons["Medium"] = loadButtonImage("assets/ui/MediumBut_hover.png")
    difficultyHButtons["Hard"] = loadButtonImage("assets/ui/HardBut_hover.png")
    difficultyHButtons["Return to Main Menu"] = loadButtonImage("assets/ui/ReturnBut_hover.png")

    buttonWidth, buttonHeight = 317, 72
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

    -- Scale factor for buttons
    local buttonScale = 1

    -- Adjust yStart to move buttons lower on the screen
    local yStart = love.graphics.getHeight() / 2 + 50 - (#options / 2 * (buttonHeight * buttonScale - 55))

    if state == "main" then
        for i, option in ipairs(options) do
            local y = yStart + (i - 1) * (buttonHeight * buttonScale + 20)
            local buttonX = love.graphics.getWidth() / 2 - (buttonWidth * buttonScale) / 2
            if i == selection then
                -- Draw shadow for hovered button
                love.graphics.setColor(0, 0, 0, 0.5) -- Shadow color
              --  love.graphics.rectangle("fill", buttonX + 5, y + 5, buttonWidth * buttonScale, buttonHeight * buttonScale)
                love.graphics.setColor(1, 1, 1, 1) -- Reset color

                love.graphics.draw(hoveredButtons[option], buttonX, y, 0, buttonScale, buttonScale)
            else
                love.graphics.draw(buttons[option], buttonX, y, 0, buttonScale, buttonScale)
            end
        end
    elseif state == "difficulty" then
        for i, option in ipairs(difficulties) do
            local y = yStart + (i - 1) * (buttonHeight * buttonScale + 20)
            local buttonX = love.graphics.getWidth() / 2 - (buttonWidth * buttonScale) / 2
            if i == selection then
                -- Draw shadow for hovered button
                love.graphics.setColor(0, 0, 0, 0.5) -- Shadow color
              --  love.graphics.rectangle("fill", buttonX + 5, y + 5, buttonWidth * buttonScale, buttonHeight * buttonScale)
                love.graphics.setColor(1, 1, 1, 1) -- Reset color

                love.graphics.draw(difficultyHButtons[option], buttonX, y, 0, buttonScale, buttonScale)
            else
                love.graphics.draw(difficultyButtons[option], buttonX, y, 0, buttonScale, buttonScale)
            end
        end
    end

    
    -- log loading errors in error.log
    if #imageLoadErrors > 0 then
        local file = io.open("error.log", "w")
        for i, error in ipairs(imageLoadErrors) do
            file:write(error .. "\n")
        end
        file:close()
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
    if key == "escape" then
        if state == "difficulty" then
            state = "main"
        else
            love.event.quit()
        end
    end
end

return menu
