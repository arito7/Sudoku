<<<<<<< HEAD
PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- pencil mode button that comes below the puzzle
    pencilModeBtn = Button(gFonts['titleFont'], 'Pencil Mode', 0, CELL_H * 9 + BOARD_TOP_OFFSET + 16)
    timer = 0
end

function PlayState:enter(difficulty)
    gBoard = Board((WINDOW_WIDTH - CELL_W * 9) / 2, BOARD_TOP_OFFSET, difficulty)
end

function PlayState:update(dt)
    
    -- time passed
    timer = timer + dt 
    
    -- keyboard navigation for the board
    -- get the current selected cell
    currentIndex = gBoard:getCurrentSelection()
    updated = false

    -- select a new cell
    if love.keyboard.wasPressed('up') and currentIndex > 9 then
        gBoard.cells[currentIndex - 9].selected = true
        updated = true
    elseif love.keyboard.wasPressed('right') and currentIndex < 81 then
        gBoard.cells[currentIndex + 1].selected = true
        updated = true
    elseif love.keyboard.wasPressed('left') and currentIndex > 1 then 
        gBoard.cells[currentIndex - 1].selected = true
        updated = true
    elseif love.keyboard.wasPressed('down') and currentIndex < 73 then
        gBoard.cells[currentIndex + 9].selected = true
        updated = true
    elseif love.keyboard.wasPressed('0') or love.keyboard.wasPressed('kp0') then
        gBoard:insertSolution(0, currentIndex)
    elseif love.keyboard.wasPressed('9') or love.keyboard.wasPressed('kp9') then
        gBoard:insertSolution(9, currentIndex)
    elseif love.keyboard.wasPressed('8') or love.keyboard.wasPressed('kp8') then
        gBoard:insertSolution(8, currentIndex)
    elseif love.keyboard.wasPressed('7') or love.keyboard.wasPressed('kp7') then
        gBoard:insertSolution(7, currentIndex)
    elseif love.keyboard.wasPressed('6') or love.keyboard.wasPressed('kp6') then
        gBoard:insertSolution(6, currentIndex)
    elseif love.keyboard.wasPressed('5') or love.keyboard.wasPressed('kp5') then
        gBoard:insertSolution(5, currentIndex)
    elseif love.keyboard.wasPressed('4') or love.keyboard.wasPressed('kp4') then
        gBoard:insertSolution(4, currentIndex)
    elseif love.keyboard.wasPressed('3') or love.keyboard.wasPressed('kp3') then
        gBoard:insertSolution(3, currentIndex)
    elseif love.keyboard.wasPressed('2') or love.keyboard.wasPressed('kp2') then
        gBoard:insertSolution(2, currentIndex)
    elseif love.keyboard.wasPressed('1') or love.keyboard.wasPressed('kp1') then
        gBoard:insertSolution(1, currentIndex)
    elseif love.keyboard.wasPressed('kpenter') then
        pencilModeBtn:onClick()
        gBoard:toggleMode()
    elseif love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if gBoard:isComplete() then
        print('Puzzle Solved')
        gStateMachine:change('complete', timer)
    end

    if updated then
        -- if another cell was selected unselect this cell
        gBoard.cells[currentIndex].selected = false
    end  

    gBoard:update(dt)

end


function PlayState:render()
    -- print title
    love.graphics.setColor(gColors['highlighted'])
    love.graphics.setFont(gFonts['titleFont'])
    love.graphics.printf('Sudoku', 0, BOARD_TOP_OFFSET / 2 - 14, WINDOW_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.setColor(gColors['highlighted'])
    
    love.graphics.printf(string.format('time: %02d:%02d',math.floor(timer / 60),math.floor(timer % 60)), 0, BOARD_TOP_OFFSET - gFonts['mediumFont']:getHeight() - 5, WINDOW_WIDTH - 5, 'right')
    -- draw pencil mode button
    pencilModeBtn:render()
    -- draw all cells
    gBoard:render()
=======
PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- pencil mode button that comes below the puzzle
    pencilModeBtn = Button(gFonts['titleFont'], 'Pencil Mode', 0, CELL_H * 9 + BOARD_TOP_OFFSET + 16)
    timer = 0
end

function PlayState:enter(difficulty)
    gBoard = Board((WINDOW_WIDTH - CELL_W * 9) / 2, BOARD_TOP_OFFSET, difficulty)
end

function PlayState:update(dt)
    
    -- time passed
    timer = timer + dt 
    
    -- keyboard navigation for the board
    -- get the current selected cell
    currentIndex = gBoard:getCurrentSelection()
    updated = false

    -- select a new cell
    if love.keyboard.wasPressed('up') and currentIndex > 9 then
        gBoard.cells[currentIndex - 9].selected = true
        updated = true
    elseif love.keyboard.wasPressed('right') and currentIndex < 81 then
        gBoard.cells[currentIndex + 1].selected = true
        updated = true
    elseif love.keyboard.wasPressed('left') and currentIndex > 1 then 
        gBoard.cells[currentIndex - 1].selected = true
        updated = true
    elseif love.keyboard.wasPressed('down') and currentIndex < 73 then
        gBoard.cells[currentIndex + 9].selected = true
        updated = true
    elseif love.keyboard.wasPressed('0') or love.keyboard.wasPressed('kp0') then
        gBoard:insertSolution(0, currentIndex)
    elseif love.keyboard.wasPressed('9') or love.keyboard.wasPressed('kp9') then
        gBoard:insertSolution(9, currentIndex)
    elseif love.keyboard.wasPressed('8') or love.keyboard.wasPressed('kp8') then
        gBoard:insertSolution(8, currentIndex)
    elseif love.keyboard.wasPressed('7') or love.keyboard.wasPressed('kp7') then
        gBoard:insertSolution(7, currentIndex)
    elseif love.keyboard.wasPressed('6') or love.keyboard.wasPressed('kp6') then
        gBoard:insertSolution(6, currentIndex)
    elseif love.keyboard.wasPressed('5') or love.keyboard.wasPressed('kp5') then
        gBoard:insertSolution(5, currentIndex)
    elseif love.keyboard.wasPressed('4') or love.keyboard.wasPressed('kp4') then
        gBoard:insertSolution(4, currentIndex)
    elseif love.keyboard.wasPressed('3') or love.keyboard.wasPressed('kp3') then
        gBoard:insertSolution(3, currentIndex)
    elseif love.keyboard.wasPressed('2') or love.keyboard.wasPressed('kp2') then
        gBoard:insertSolution(2, currentIndex)
    elseif love.keyboard.wasPressed('1') or love.keyboard.wasPressed('kp1') then
        gBoard:insertSolution(1, currentIndex)
    elseif love.keyboard.wasPressed('kpenter') then
        pencilModeBtn:onClick()
        gBoard:toggleMode()
    elseif love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if gBoard:isComplete() then
        print('Puzzle Solved')
        gStateMachine:change('complete', timer)
    end

    if updated then
        -- if another cell was selected unselect this cell
        gBoard.cells[currentIndex].selected = false
    end  

    gBoard:update(dt)

end


function PlayState:render()
    -- print title
    love.graphics.setColor(gColors['highlighted'])
    love.graphics.setFont(gFonts['titleFont'])
    love.graphics.printf('Sudoku', 0, BOARD_TOP_OFFSET / 2 - 14, WINDOW_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.setColor(gColors['highlighted'])
    
    love.graphics.printf(string.format('time: %02d:%02d',math.floor(timer / 60),math.floor(timer % 60)), 0, BOARD_TOP_OFFSET - gFonts['mediumFont']:getHeight() - 5, WINDOW_WIDTH - 5, 'right')
    -- draw pencil mode button
    pencilModeBtn:render()
    -- draw all cells
    gBoard:render()
>>>>>>> 59c795889d2695624fa5d750edd5ea2632e86e7f
end