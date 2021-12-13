require 'src/Dependencies'

-- images we load into memory from files to later draw onto screen
-- local background = love.graphics.newImage('background.png')
-- local ground = love.graphics.newImage('ground.png')

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Clean Sudoku')

    math.randomseed(os.time())

    gColors = {
        ['highlighted'] = {1.0, 1.0, 1.0},
        ['nothighlighted'] = {1.0, 1.0, 1.0, 0.5},
        ['offsetcell'] = {0.2, 0.2, 0.2, 1.0},
        ['cell'] = {0.3, 0.3, 0.3, 1.0},
        ['invalidcell'] = {0.8, 0.2, 0.2, 0.9},
        ['defaultcell'] = {0.7,0.7,0.7},
        ['selectedcell'] = {0.7, 0.7, 0.7, 0.7},
        ['selected_relation'] = {0.60, 0.7, 0.60, 0.6},
        ['selected_weak_relation'] = {0.65, 0.7, 0.65, 0.3},
        ['userinputcell'] = {0.8,0.8,0.8},
        ['dark_green'] = {0.5, 0.9, 0.5, 1}
    }

    gFonts = {
        ['titleFont'] = love.graphics.newFont('fonts/flappy.ttf', 28),
        ['mediumFont'] = love.graphics.newFont('fonts/flappy.ttf', 20),
        ['cellFont'] = love.graphics.newFont('fonts/Exo2-SemiBold.ttf', 28),
        ['subscriptFont'] = love.graphics.newFont('fonts/Exo2-Regular.ttf', 13)
    }

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['complete'] = function() return CompleteState() end,
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

-- function love.mousepressed(x, y, button, istouch, presses)
--     if x > pencilModeBtn.x and x < pencilModeBtn.x + pencilModeBtn:getWidth() and y > pencilModeBtn.y and y < pencilModeBtn.y + pencilModeBtn:getHeight() then
--         pencilModeBtn:onClick()
--         gBoard:toggleMode()
--     end
-- end

-- function love.mousemoved(x, y, dx, dy, istouch)
--     for k, cell in pairs(gBoard.cells) do
--         if x > cell.x and x < cell.x + CELL_W and y > cell.y and y < cell.y + CELL_H then
--             cell.selected = true
--         else
--             cell.selected = false
--         end
--     end
-- end

function love.draw()
     -- draw the background starting at top left 
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
	
    gStateMachine:render()

    displayFPS()
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['titleFont'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end