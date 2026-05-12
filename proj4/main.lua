local gridWidth = 0
local gridHeight = 0
local minesNumber = 0
local size = 0
local minesToSweep = 0

local grid = {}
local mines = {}

local cellOffset = 32
local cellSize = 50
local margin = 50

local firstClick = false

local gameOver = false
local won = false

local colors = {
    [1] = {0.1, 0.1, 1},    -- Blue
    [2] = {0, 0.6, 0},      -- Green
    [3] = {1, 0, 0},        -- Red
    [4] = {0, 0, 0.5},      -- Dark Blue
    [5] = {0.5, 0, 0},      -- Dark Red
    [6] = {0, 0.5, 0.5},    -- Teal
    [7] = {0, 0, 0},        -- Black
    [8] = {0.5, 0.5, 0.5},   -- Grey
    [9] = {0.2, 0, 0}
}

local gameState = "menu"
local difficulties = {
    { name = "Easy",   width = 8,  height = 8,  mines = 10 },
    { name = "Medium", width = 16, height = 16, mines = 40 },
    { name = "Hard",   width = 20, height = 20, mines = 99 }
}

function hasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function createStart(num)
    local empty = {}
    empty[1] = num
    empty[2] = num - 1
    empty[3] = num + 1
    empty[4] = num - gridWidth
    empty[5] = num - gridWidth - 1
    empty[6] = num - gridWidth + 1
    empty[7] = num + gridWidth
    empty[8] = num + gridWidth - 1
    empty[9] = num + gridWidth + 1
    return empty
end

function createMines(firstX, firstY)
    local firstClickNotMine = (firstX - 1) * gridWidth + firstY
    local startWithoutMines = createStart(firstClickNotMine)
    for x = 1, minesNumber do
        local r = love.math.random(1, size)
        while hasValue(mines, r) or hasValue(startWithoutMines, r) do
            r = love.math.random(1, size)
        end
        mines[x] = r
    end

    for x = 1, gridWidth do
        for y = 1, gridHeight do
            grid[x][y].isMine = isMine(x, y)
            grid[x][y].neighbourCount = calculateMinesNeighors(x, y)
        end
    end
end

function isMine(x, y)
    return hasValue(mines, (x - 1) * gridWidth + y)
end

function calculateMinesNeighors(x, y)
    if isMine(x, y) then
        return 0
    end

    local neighborMines = 0

    -- nearest
    if x > 1 and isMine(x - 1, y) then
        neighborMines = neighborMines + 1
    end
    if x < gridWidth and isMine(x + 1, y) then
        neighborMines = neighborMines + 1
    end
    if y > 1 and isMine(x, y - 1) then
        neighborMines = neighborMines + 1
    end
    if y < gridWidth and isMine(x, y + 1) then
        neighborMines = neighborMines + 1
    end

    -- diagonal
    if x > 1 and y > 1 and isMine(x - 1, y - 1) then
        neighborMines = neighborMines + 1
    end
    if x > 1 and y < gridHeight and isMine(x - 1, y + 1) then
        neighborMines = neighborMines + 1
    end
    if x < gridWidth and y > 1 and isMine(x + 1, y - 1) then
        neighborMines = neighborMines + 1
    end
    if x < gridWidth and y < gridHeight and isMine(x + 1, y + 1) then
        neighborMines = neighborMines + 1
    end

    return neighborMines
end

function createEmptyBoard()
    for x = 1, gridWidth do
        grid[x] = {}
        for y = 1, gridHeight do
            grid[x][y] = {
                isMine = false,
                isRevealed = false,
                neighbourCount = 0,
                isFlagged = false
            }
        end
    end
end

function showMines()
    for x = 1, gridWidth do
        for y = 1, gridHeight do
            if grid[x][y].isMine then
                grid[x][y].isRevealed = true
            end
        end
    end
end

function revealCell(x, y)
    local cell = grid[x][y]

    if cell.isRevealed or cell.isFlagged then return end

    cell.isRevealed = true

    if cell.isMine then
        gameOver = true
        showMines()
        return
    end

    if cell.neighbourCount == 0 then
        for dx = -1, 1 do
            for dy = -1, 1 do
                local nx, ny = x + dx, y + dy
                if grid[nx] and grid[nx][ny] then
                    revealCell(nx, ny)
                end
            end
        end
    end
end

function checkWin()
    for x = 1, gridWidth do
        for y = 1, gridHeight do
            if grid[x][y].isMine ~= grid[x][y].isFlagged then
                return false
            end
        end
    end
    return true
end

function love.mousepressed(x, y, button, istouch, presses)
    local gridX = math.floor((x - margin) / cellSize) + 1
    local gridY = math.floor((y - margin) / cellSize) + 1

    if gridX >= 1 and gridX <= gridWidth and gridY >= 1 and gridY <= gridHeight then
        if button == 1 then
            if not firstClick then
                firstClick = true
                createMines(gridX, gridY)
            end
            revealCell(gridX, gridY)
        elseif button == 2 then
            grid[gridX][gridY].isFlagged = not grid[gridX][gridY].isFlagged
            if grid[gridX][gridY].isFlagged then
                minesToSweep = minesToSweep - 1
            else
                minesToSweep = minesToSweep + 1
            end
            if minesToSweep == 0 then
                won = checkWin()
            end
        end
    end
end

function startNewGame(diff)
    gridWidth = diff.width
    gridHeight = diff.height
    size = gridWidth * gridHeight
    minesNumber = diff.mines
    gameState = "play"
    grid = {}
    mines = {}
    firstClick = false
    won = false

    minesToSweep = minesNumber


    createEmptyBoard()     
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "1" then
            startNewGame(difficulties[1])
        elseif key == "2" then
            startNewGame(difficulties[2])
        elseif key == "3" then
            startNewGame(difficulties[3])
        end
    end

    if key == "escape" then
        if gameState == "play" then
            gameState = "menu"
            gameOver = false
        else
            love.event.quit(0)
        end
    end
end

function love.load()
    love.window.setTitle("Minesweeper")
    love.window.setFullscreen(true)
    local myFont = love.graphics.newFont("Press_Start_2P/PressStart2P-Regular.ttf", 20)
    love.graphics.setFont(myFont)
end

function drawGame()
    love.graphics.clear(0.15, 0.15, 0.18)
    --love.graphics.print("Minesweeper", love.window.getWidth / 2, 10)
    for x = 1, gridWidth do
        for y = 1, gridHeight do
            local coordX = margin + (x - 1) * cellSize
            local coordY = margin + (y - 1) * cellSize

            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", coordX, coordY, cellSize, cellSize)

            love.graphics.setColor(1, 1, 1)
            love.graphics.line(coordX, coordY, coordX + cellSize, coordY)
            love.graphics.line(coordX, coordY, coordX, coordY + cellSize)
            
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.line(coordX + cellSize, coordY, coordX + cellSize, coordY + cellSize)
            love.graphics.line(coordX, coordY + cellSize, coordX + cellSize, coordY + cellSize)
            
            love.graphics.setColor(1, 1, 1)

            local printCoordX = margin + (x - 1) * cellSize + cellSize / 2 - 7
            local printCoordY = margin + (y - 1) * cellSize + cellSize / 2 - 7
            local cell = grid[x][y]

            if cell.isRevealed then
                love.graphics.setColor(0.7, 0.7, 0.7)
                love.graphics.rectangle("fill", coordX, coordY, cellSize, cellSize)
                love.graphics.setColor(1, 1, 1)
                if cell.isMine then
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.rectangle("fill", coordX, coordY, cellSize, cellSize)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.print("M", printCoordX, printCoordY)
                elseif cell.neighbourCount > 0 then
                    local c = colors[cell.neighbourCount]
                    love.graphics.setColor(c[1], c[2], c[3])
                    love.graphics.print(cell.neighbourCount, printCoordX, printCoordY)
                    love.graphics.setColor(1, 1, 1)
                end
            end
            if cell.isFlagged then
                local c = colors[9]
                love.graphics.setColor(c[1], c[2], c[3])
                love.graphics.print("f", printCoordX, printCoordY)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
end

function drawMenu()
    love.graphics.clear(0.1, 0.1, 0.1)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("MineSweeper", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Press a number to start:", 0, 150, love.graphics.getWidth(), "center")

    for i, diff in ipairs(difficulties) do
        local yPos = 200 + (i * 40)
        local label = "[" .. i .. "] " .. diff.name .. " (" .. diff.width .. "x" .. diff.height .. ")"
        love.graphics.printf(label, 0, yPos, love.graphics.getWidth(), "center")
    end
end

function drawWinOverlay()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)

    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("You Won!", 0, screenH / 2 - 50, screenW, "center")
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press [Esc] for Menu", 0, screenH / 2 + 10, screenW, "center")
end

function drawGameOverOverlay()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)

    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("KABOOM!", 0, screenH / 2 - 50, screenW, "center")
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press [Esc] for Menu", 0, screenH / 2 + 10, screenW, "center")
end

function love.draw()
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "play" then
        drawGame()
        if gameOver then
            drawGameOverOverlay()
        end
        if won then
            drawWinOverlay()
        end
    end
end
