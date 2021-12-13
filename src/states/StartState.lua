<<<<<<< HEAD
-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1
local menuOptions = {'Easy', 'Medium', 'Hard', 'Extreme', 'Quit'}

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        if love.keyboard.wasPressed('up') then
            -- if current selection is not the first one
            if highlighted ~= 1 then
                highlighted = highlighted - 1
            end 
        else
            -- if down is pressed and
            -- current selection is not the last one
            if highlighted < table.getn(menuOptions) then
                highlighted = highlighted + 1
            end
        end
        gSounds['paddle-hit']:play()
    end

    -- confirm whichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
        gSounds['confirm']:play()

        if inList(highlighted, {1,2,3,4}) then
            -- passing highlighted to play, which sets the difficulty
            gStateMachine:change('play', DIFFICULTY[highlighted])
        elseif highlighted == table.getn(menuOptions) then
            love.event.quit()
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['titleFont'])
    love.graphics.printf("SUDOKU", 0, WINDOW_HEIGHT / 6,
        WINDOW_WIDTH, 'center')
    
    for k, v in pairs(menuOptions) do
        -- change color depending on if the key = highlighted
        if k == highlighted then
            love.graphics.setColor(gColors['highlighted'])
        else
            love.graphics.setColor(gColors['nothighlighted'])
        end
        love.graphics.printf(v, 0, WINDOW_HEIGHT / 3 + k * gFonts['titleFont']:getHeight() * 2, WINDOW_WIDTH, 'center')
    end
end

=======
-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1
local menuOptions = {'Easy', 'Medium', 'Hard', 'Extreme', 'Quit'}

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        if love.keyboard.wasPressed('up') then
            -- if current selection is not the first one
            if highlighted ~= 1 then
                highlighted = highlighted - 1
            end 
        else
            -- if down is pressed and
            -- current selection is not the last one
            if highlighted < table.getn(menuOptions) then
                highlighted = highlighted + 1
            end
        end
        gSounds['paddle-hit']:play()
    end

    -- confirm whichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter') then
        gSounds['confirm']:play()

        if inList(highlighted, {1,2,3,4}) then
            -- passing highlighted to play, which sets the difficulty
            gStateMachine:change('play', DIFFICULTY[highlighted])
        elseif highlighted == table.getn(menuOptions) then
            love.event.quit()
        end
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['titleFont'])
    love.graphics.printf("SUDOKU", 0, WINDOW_HEIGHT / 6,
        WINDOW_WIDTH, 'center')
    
    for k, v in pairs(menuOptions) do
        -- change color depending on if the key = highlighted
        if k == highlighted then
            love.graphics.setColor(gColors['highlighted'])
        else
            love.graphics.setColor(gColors['nothighlighted'])
        end
        love.graphics.printf(v, 0, WINDOW_HEIGHT / 3 + k * gFonts['titleFont']:getHeight() * 2, WINDOW_WIDTH, 'center')
    end
end

>>>>>>> 59c795889d2695624fa5d750edd5ea2632e86e7f
