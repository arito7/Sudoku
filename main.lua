require 'src/Dependencies'

-- images we load into memory from files to later draw onto screen
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Clean Sudoku')

    titleFont = love.graphics.newFont('flappy.ttf', 28)
    cellFont = love.graphics.newFont('Exo2-SemiBold.ttf', 28)
    subscriptFont = love.graphics.newFont('Exo2-Regular.ttf', 13)

    pencilModeBtn = Button(titleFont, 'Pencil Mode', 0, CELL_H * 9 + BOARD_TOP_OFFSET + 16)
    
    gBoard = Board((WINDOW_WIDTH - CELL_W * 9) / 2, BOARD_TOP_OFFSET)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update()
    
end

function love.mousepressed(x, y, button, istouch, presses)
    if x > pencilModeBtn.x and x < pencilModeBtn.x + pencilModeBtn:getWidth() and y > pencilModeBtn.y and y < pencilModeBtn.y + pencilModeBtn:getHeight() then
        pencilModeBtn:onClick()
        gBoard:toggleMode()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    for k, cell in pairs(gBoard.cells) do
        if x > cell.x and x < cell.x + CELL_W and y > cell.y and y < cell.y + CELL_H then
            cell.selected = true
        else
            cell.selected = false
        end
    end
end

-- keyboard navigation for the board
function love.keypressed(key, scancode, isrepeat)
    -- get the current selected cell
    currentIndex = gBoard:getCurrentSelection()
    updated = false
    -- select a new cell
    if key == 'right' and currentIndex < 81 then
        gBoard.cells[currentIndex + 1].selected = true
        updated = true
    elseif key == 'left' and currentIndex > 1 then 
        gBoard.cells[currentIndex - 1].selected = true
        updated = true
    elseif key == 'down' and currentIndex < 73 then
        gBoard.cells[currentIndex + 9].selected = true
        updated = true
    elseif key == 'up' and currentIndex > 9 then
        gBoard.cells[currentIndex - 9].selected = true
        updated = true
    elseif key == '0' or key == 'kp0' then
        gBoard:insertSolution(0, currentIndex)
    elseif key == '9' or key == 'kp9' then
        gBoard:insertSolution(9, currentIndex)
    elseif key == '8' or key == 'kp8' then
        gBoard:insertSolution(8, currentIndex)
    elseif key == '7' or key == 'kp7' then
        gBoard:insertSolution(7, currentIndex)
    elseif key == '6' or key == 'kp6' then
        gBoard:insertSolution(6, currentIndex)
    elseif key == '5' or key == 'kp5' then
        gBoard:insertSolution(5, currentIndex)
    elseif key == '4' or key == 'kp4' then
        gBoard:insertSolution(4, currentIndex)
    elseif key == '3' or key == 'kp3' then
        gBoard:insertSolution(3, currentIndex)
    elseif key == '2' or key == 'kp2' then
        gBoard:insertSolution(2, currentIndex)
    elseif key == '1' or key == 'kp1' then
        gBoard:insertSolution(1, currentIndex)
    elseif key == 'kpenter' then
        pencilModeBtn:onClick()
        gBoard:toggleMode()
    end

    if updated then
        -- if another cell was selected unselect this cell
        gBoard.cells[currentIndex].selected = false
    end  
end

function love.draw()

    -- draw the background starting at top left 
    love.graphics.setBackgroundColor(0.85, 0.85, 0.85)
	
    -- print title
    love.graphics.setColor(0.1, 0.1, 0.1, 1.0)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Sudoku', 0, BOARD_TOP_OFFSET / 2 - 14, WINDOW_WIDTH, 'center')

    -- draw pencil mode button
    pencilModeBtn:render()
    -- draw all cells
    gBoard:render()


    -- draw the ground on top of the background, toward the bottom of the screen
    -- love.graphics.draw(ground, 0, WINDOW_HEIGHT - 16)
end
