-- src/utilities/ai.lua
local ai = {}

function ai.getMove(board, difficulty)
    if difficulty == "easy" then
        return ai.easyMove(board)
    elseif difficulty == "medium" then
        return ai.mediumMove(board)
    elseif difficulty == "hard" then
        return ai.hardMove(board)
    end
end

function ai.easyMove(board)
    local availableMoves = {}

    for x = 1, #board do
        for y = 1, #board[x] do
            if board[x][y] == nil then
                table.insert(availableMoves, {x = x, y = y})
            end
        end
    end

    local randomIndex = math.random(1, #availableMoves)
    return availableMoves[randomIndex]
end

function ai.mediumMove(board)
    local bestMove = ai.findBestMove(board)
    return bestMove
end

function ai.findBestMove(board)
    local bestMove = nil
    local bestScore = -math.huge

    for x = 1, #board do
        for y = 1, #board[x] do
            if board[x][y] == nil then
                board[x][y] = "O" -- Assume AI is "O"
                local score = ai.minimax(board, 0, false)
                board[x][y] = nil

                if score > bestScore then
                    bestScore = score
                    bestMove = {x = x, y = y}
                end
            end
        end
    end

    return bestMove
end

function ai.minimax(board, depth, isMaximizing)
    local result = ai.checkWin(board)
    if result == "O" then return 10 - depth end
    if result == "X" then return depth - 10 end
    if ai.isBoardFull(board) then return 0 end

    if isMaximizing then
        local bestScore = -math.huge
        for x = 1, #board do
            for y = 1, #board[x] do
                if board[x][y] == nil then
                    board[x][y] = "O"
                    local score = ai.minimax(board, depth + 1, false)
                    board[x][y] = nil
                    bestScore = math.max(score, bestScore)
                end
            end
        end
        return bestScore
    else
        local bestScore = math.huge
        for x = 1, #board do
            for y = 1, #board[x] do
                if board[x][y] == nil then
                    board[x][y] = "X"
                    local score = ai.minimax(board, depth + 1, true)
                    board[x][y] = nil
                    bestScore = math.min(score, bestScore)
                end
            end
        end
        return bestScore
    end
end

function ai.checkWin(board)
    -- Check rows, columns, and diagonals for a winner
    for i = 1, #board do
        if board[i][1] and board[i][1] == board[i][2] and board[i][1] == board[i][3] then
            return board[i][1]
        end
        if board[1][i] and board[1][i] == board[2][i] and board[1][i] == board[3][i] then
            return board[1][i]
        end
    end
    if board[1][1] and board[1][1] == board[2][2] and board[1][1] == board[3][3] then
        return board[1][1]
    end
    if board[1][3] and board[1][3] == board[2][2] and board[1][3] == board[3][1] then
        return board[1][3]
    end
    return nil
end

function ai.isBoardFull(board)
    for x = 1, #board do
        for y = 1, #board[x] do
            if board[x][y] == nil then
                return false
            end
        end
    end
    return true
end

return ai
