-- src/states/gameplay.lua
local gameplay = {}
local board = require "src.entities.board"
local ai = require "src.utilities.ai"
local mode = "local"
local difficulty = "Easy"
local currentPlayer = "X"

function gameplay.enter(gameMode, gameDifficulty)
    mode = gameMode or "local"
    difficulty = gameDifficulty or "Easy"
    currentPlayer = "X"
    board.init()
    print("Game mode: " .. mode)
    print("Difficulty: " .. difficulty)
    print("Entering gameplay state")
end

function gameplay.update(dt)
    board.update(dt)
    
    if mode == "computer" and currentPlayer == "O" then
        local move = ai.getMove(board.getBoard(), difficulty)
        board.addPiece(move.x, move.y, "O")
        currentPlayer = "X"
    end
end

function gameplay.draw()
    board.draw()
end

function gameplay.keypressed(key)
    if mode == "local" then
        handleLocalInput(key)
    elseif mode == "computer" then
        handleComputerInput(key)
    elseif mode == "online" then
        -- Handle online play inputs (when implemented)
    end
end

function handleLocalInput(key)
    local x, y = getCoordinatesFromKey(key)
    if x and y then
        if board.addPiece(x, y, currentPlayer) then
            currentPlayer = (currentPlayer == "X") and "O" or "X"
        end
    end
end

function handleComputerInput(key)
    local x, y = getCoordinatesFromKey(key)
    if x and y then
        if board.addPiece(x, y, "X") then
            currentPlayer = "O"
        end
    end
end

function getCoordinatesFromKey(key)
    -- Example implementation (you may need to adapt this to your needs)
    if key == "1" then return 1, 1 end
    if key == "2" then return 2, 1 end
    if key == "3" then return 3, 1 end
    if key == "4" then return 1, 2 end
    if key == "5" then return 2, 2 end
    if key == "6" then return 3, 2 end
    if key == "7" then return 1, 3 end
    if key == "8" then return 2, 3 end
    if key == "9" then return 3, 3 end
    return nil, nil
end

function gameplay.escape(key)
    if key == "escape" then
        -- go back to main menu.lua
        changeState(menu)
    else
        love.event.quit()
    end
end

return gameplay
