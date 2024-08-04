-- src/entities/board.lua
local board = {}
local pieces = {}
local size = 3 -- 3x3 board

function board.init()
    -- Initialize board state
    pieces = {}
    for x = 1, size do
        pieces[x] = {}
        for y = 1, size do
            pieces[x][y] = nil -- nil means empty
        end
    end
end

function board.getBoard()
    return pieces
end

function board.addPiece(x, y, player)
    if x >= 1 and x <= size and y >= 1 and y <= size and pieces[x][y] == nil then
        pieces[x][y] = player
        return true
    end
    return false
end

function board.update(dt)
    -- Update board state, check for player actions, etc.
    -- This is where you might handle turns, check for game over, etc.
end

function board.draw()
    -- Draw the board and pieces
    love.graphics.clear(1, 1, 1) -- White background
    love.graphics.setColor(0, 0, 0) -- Black color for grid lines

    for x = 1, size do
        for y = 1, size do
            love.graphics.rectangle("line", (x-1)*100, (y-1)*100, 100, 100)
            local piece = pieces[x][y]
            if piece then
                if piece == "X" then
                    love.graphics.setColor(1, 0, 0) -- Red for X
                    love.graphics.rectangle("fill", (x-1)*100 + 10, (y-1)*100 + 10, 80, 80)
                elseif piece == "O" then
                    love.graphics.setColor(0, 0, 1) -- Blue for O
                    love.graphics.rectangle("fill", (x-1)*100 + 10, (y-1)*100 + 10, 80, 80)
                end
            end
        end
    end
end

return board
