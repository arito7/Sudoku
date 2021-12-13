<<<<<<< HEAD
Cell = Class{}

-- used to color offset quadrants a different color
QUAD_OFFSET = {1, 4, 7, 9, 11, 12, 14, 15, 17, 19, 22, 25}

-- function Cell:init(index, row, col, xoffset, yoffset, solution)
function Cell:init(index, xoffset, yoffset, solution)
    -- index position for cell 
    self.index = index
    
    -- parent Board's xy offsets, required for determining this cells xy coordinates
    self.xoffset = xoffset
    self.yoffset = yoffset
    
    -- user input answer can be right or wrong
    self.solution = solution or 0
    
    -- if the current solution in the cell is valid or not
    -- used when rendering cells containing incorrect values
    self.isvalid = true
    
    -- the correct answer for the cell
    self.answer = 0

    -- keeps track of a cell that has been solved
    self.solved = false

    -- candidates entered by user in pencil mode
    self.candidates = {}
    
    self.selectedCellValue = 0

    -- bools used to determine cell highlight when rendering
    self.selected = false
    self.relatedHighlight = false
    self.weakRelationHighlight = false
end

--[[
     01 02 03  [04 05 06]  07 08 09 
     10 11 12  [13 14 15]  16 17 18 
     19 20 21  [22 23 24]  25 26 27 
    [28 29 30]  31 32 33  [34 35 36] 
    [37 38 39]  40 41 42  [43 44 45] 
    [46 47 48]  49 50 51  [52 53 54] 
     55 56 57  [58 59 60]  61 62 63 
     64 65 66  [67 68 69]  70 71 72 
     73 74 75  [76 77 78]  79 80 81
]]

function Cell:getRow()
    return math.floor((self.index - 1) / 9)
end

function Cell:getCol()
    return (self.index - 1) % 9
end

function Cell:getX()
    return self:getCol() * CELL_W + self.xoffset
end

function Cell:getY()
    return self:getRow() * CELL_H + self.yoffset
end


--[[
    @param selectedCell should be a cell object
]]
function Cell:update(dt, selectedCell)
    self.selectedCellValue = selectedCell.solution
    local xb = selectedCell:getRow()
    local yb = selectedCell:getCol()
    if self.index ~= selectedCell.index and selectedCell.solution ~= 0 then

        if self.solution == selectedCell.solution then
            self.relatedHighlight = true
        else
            self.relatedHighlight = false
        end

        if self:getRow() == selectedCell:getRow() or self:getCol() == selectedCell:getCol() then
            self.weakRelationHighlight = true
        else
            self.weakRelationHighlight = false
        end

    else
        self.relatedHighlight = false
        self.weakRelationHighlight = false
    end
end


function Cell:addCandidate(num)
    if not self._default then 
        if not inList(num, self.candidates) then
            self.candidates[num] = num
        else
            self.candidates[num] = 0
        end
    end
end

--[[
    Removes candidates from this cell depending on the
    passsed cell
]]
function Cell:removeCandidate(cell)
    if not self._default and cell.solution ~= 0 then
        xb = math.floor(cell:getRow() / 3) * 3
        yb = math.floor(cell:getCol() / 3) * 3
        -- if param cell solution is in self.candidates and param cell is not this cell
        if inList(cell.solution, self.candidates) and self:getRow() .. self:getCol() ~= cell:getRow() .. cell:getCol() then
            if cell:getCol() == self:getCol() or cell:getRow() == self:getRow() or 
                inList(self:getRow(), {xb, xb + 1, xb + 2}) and inList(self:getCol(), {yb, yb + 1, yb + 2}) then
                for k, c in pairs(self.candidates) do
                    if c == cell.solution then
                        c = 0
                    end
                end
            end
        end
    end
end


--[[
    Set this cell as a default provided cell
    Meant to be used in Board class when setting up a board.
]]
function Cell:setAsDefault()
    self.answer = self.solution
    self._default = true
    self.solved = true
end

--[[
    Set this cell as an empty cell that needs to be solved by
    user.
    Meant to be used in Board class when setting up a board.
]]
function Cell:maskCell()
    self.solution = 0
    self._default = false
    self.solved = false
end


function Cell:input(num, isValid, pencilMode)
    -- insert only if the cell is not a default provided cell
    if not self._default and not self.solved then
        if pencilMode then
            self.solution = 0
            self.isvalid = true
            self:addCandidate(num)
        else 
            self.solution = num
            self.isvalid = isValid
            self.candidates = {}
            if self.solution == self.answer then
                self.solved = true
                self.isvalid = true
            end
        end
    end
end

-- cell render will use i [its index position in the dictionary]
-- to draw its position so it is not dependent on its variables
-- this way it can withstand position changes within the dictionary when shuffling
-- and still draw correctly.
function Cell:render()
    -- set offset colors
    if inList(math.floor((self.index - 1) / 3), QUAD_OFFSET) then
        love.graphics.setColor(gColors['offsetcell'])        
    else
        love.graphics.setColor(gColors['cell'])
    end

    -- highlight the cell if the cell is selected
    if self.selected then
        love.graphics.setColor(gColors['selectedcell'])  
        love.graphics.rectangle('fill',self:getX(), self:getY(), CELL_W, CELL_H)
    -- weak relations are cells that are in the same row and col
    elseif self.weakRelationHighlight then
        love.graphics.setColor(gColors['selected_weak_relation'])
        love.graphics.rectangle('fill',self:getX(), self:getY(), CELL_W, CELL_H)
    end

    -- draw the cell
    love.graphics.rectangle('fill', self:getX() + 1, self:getY() + 1, CELL_W - 2, CELL_H - 2)    

    -- draw number for cells where solution value is not 0
    if self.solution ~= 0 then
        if self._default then
            -- color for default values given in puzzle
            love.graphics.setColor(gColors['defaultcell'])
        else
            -- color for user inputted values
            love.graphics.setColor(gColors['userinputcell'])
        end
        
        if self.selected then
            -- color for selected cell
            love.graphics.setColor(gColors['dark_green'])
        elseif self.relatedHighlight then
            love.graphics.setColor(gColors['dark_green']) 
        elseif self.weakRelationHighlight then
            love.graphics.setColor(gColors['highlighted'])
        end

        if not self.isvalid then
            love.graphics.setColor(gColors['invalidcell'])
        end
        
        love.graphics.setFont(gFonts['cellFont'])
        love.graphics.printf(self.solution, self:getX(), self:getY() + CELL_H / 2 - gFonts['cellFont']:getHeight() / 2, CELL_W, 'center')
    end

    -- draw candidates in subscript
    for k, candidate in pairs(self.candidates) do
        if candidate ~= 0 then
            love.graphics.setFont(gFonts['subscriptFont'])
            love.graphics.setColor(gColors['highlighted'])
            if candidate == self.selectedCellValue then
                love.graphics.setColor(gColors['dark_green'])
            end
            -- 00 01 02   01 02 03     k - 1 / 3 gives row
            -- 10 11 12   04 05 06     k - 1 % 3 gives col 
            -- 20 21 22   07 08 09
            -- self.x, self.x + (CELL_W / 3) * (k - 1 % 3), self.x + (CELL_W / 3) * 2 
            -- self.y, self.y + (CELL_H / 3), self.y + (CELL_H / 3) * 2
            love.graphics.printf(candidate, self:getX() + CELL_W / 3 * ((k - 1) % 3), self:getY() + (CELL_H / 3) * math.floor((k - 1) / 3), CELL_W / 3, 'center')
        end
    end
    
end

=======
Cell = Class{}

-- used to color offset quadrants a different color
QUAD_OFFSET = {1, 4, 7, 9, 11, 12, 14, 15, 17, 19, 22, 25}

-- function Cell:init(index, row, col, xoffset, yoffset, solution)
function Cell:init(index, xoffset, yoffset, solution)
    -- index position for cell 
    self.index = index
    
    -- parent Board's xy offsets, required for determining this cells xy coordinates
    self.xoffset = xoffset
    self.yoffset = yoffset
    
    -- user input answer can be right or wrong
    self.solution = solution or 0
    
    -- if the current solution in the cell is valid or not
    -- used when rendering cells containing incorrect values
    self.isvalid = true
    
    -- the correct answer for the cell
    self.answer = 0

    -- keeps track of a cell that has been solved
    self.solved = false

    -- candidates entered by user in pencil mode
    self.candidates = {}
    
    self.selectedCellValue = 0

    -- bools used to determine cell highlight when rendering
    self.selected = false
    self.relatedHighlight = false
    self.weakRelationHighlight = false
end

--[[
     01 02 03  [04 05 06]  07 08 09 
     10 11 12  [13 14 15]  16 17 18 
     19 20 21  [22 23 24]  25 26 27 
    [28 29 30]  31 32 33  [34 35 36] 
    [37 38 39]  40 41 42  [43 44 45] 
    [46 47 48]  49 50 51  [52 53 54] 
     55 56 57  [58 59 60]  61 62 63 
     64 65 66  [67 68 69]  70 71 72 
     73 74 75  [76 77 78]  79 80 81
]]

function Cell:getRow()
    return math.floor((self.index - 1) / 9)
end

function Cell:getCol()
    return (self.index - 1) % 9
end

function Cell:getX()
    return self:getCol() * CELL_W + self.xoffset
end

function Cell:getY()
    return self:getRow() * CELL_H + self.yoffset
end


--[[
    @param selectedCell should be a cell object
]]
function Cell:update(dt, selectedCell)
    self.selectedCellValue = selectedCell.solution
    local xb = selectedCell:getRow()
    local yb = selectedCell:getCol()
    if self.index ~= selectedCell.index and selectedCell.solution ~= 0 then

        if self.solution == selectedCell.solution then
            self.relatedHighlight = true
        else
            self.relatedHighlight = false
        end

        if self:getRow() == selectedCell:getRow() or self:getCol() == selectedCell:getCol() then
            self.weakRelationHighlight = true
        else
            self.weakRelationHighlight = false
        end

    else
        self.relatedHighlight = false
        self.weakRelationHighlight = false
    end
end


function Cell:addCandidate(num)
    if not self._default then 
        if not inList(num, self.candidates) then
            self.candidates[num] = num
        else
            self.candidates[num] = 0
        end
    end
end

--[[
    Removes candidates from this cell depending on the
    passsed cell
]]
function Cell:removeCandidate(cell)
    if not self._default and cell.solution ~= 0 then
        xb = math.floor(cell:getRow() / 3) * 3
        yb = math.floor(cell:getCol() / 3) * 3
        -- if param cell solution is in self.candidates and param cell is not this cell
        if inList(cell.solution, self.candidates) and self:getRow() .. self:getCol() ~= cell:getRow() .. cell:getCol() then
            if cell:getCol() == self:getCol() or cell:getRow() == self:getRow() or 
                inList(self:getRow(), {xb, xb + 1, xb + 2}) and inList(self:getCol(), {yb, yb + 1, yb + 2}) then
                for k, c in pairs(self.candidates) do
                    if c == cell.solution then
                        c = 0
                    end
                end
            end
        end
    end
end


--[[
    Set this cell as a default provided cell
    Meant to be used in Board class when setting up a board.
]]
function Cell:setAsDefault()
    self.answer = self.solution
    self._default = true
    self.solved = true
end

--[[
    Set this cell as an empty cell that needs to be solved by
    user.
    Meant to be used in Board class when setting up a board.
]]
function Cell:maskCell()
    self.solution = 0
    self._default = false
    self.solved = false
end


function Cell:input(num, isValid, pencilMode)
    -- insert only if the cell is not a default provided cell
    if not self._default and not self.solved then
        if pencilMode then
            self.solution = 0
            self.isvalid = true
            self:addCandidate(num)
        else 
            self.solution = num
            self.isvalid = isValid
            self.candidates = {}
            if self.solution == self.answer then
                self.solved = true
                self.isvalid = true
            end
        end
    end
end

-- cell render will use i [its index position in the dictionary]
-- to draw its position so it is not dependent on its variables
-- this way it can withstand position changes within the dictionary when shuffling
-- and still draw correctly.
function Cell:render()
    -- set offset colors
    if inList(math.floor((self.index - 1) / 3), QUAD_OFFSET) then
        love.graphics.setColor(gColors['offsetcell'])        
    else
        love.graphics.setColor(gColors['cell'])
    end

    -- highlight the cell if the cell is selected
    if self.selected then
        love.graphics.setColor(gColors['selectedcell'])  
        love.graphics.rectangle('fill',self:getX(), self:getY(), CELL_W, CELL_H)
    -- weak relations are cells that are in the same row and col
    elseif self.weakRelationHighlight then
        love.graphics.setColor(gColors['selected_weak_relation'])
        love.graphics.rectangle('fill',self:getX(), self:getY(), CELL_W, CELL_H)
    end

    -- draw the cell
    love.graphics.rectangle('fill', self:getX() + 1, self:getY() + 1, CELL_W - 2, CELL_H - 2)    

    -- draw number for cells where solution value is not 0
    if self.solution ~= 0 then
        if self._default then
            -- color for default values given in puzzle
            love.graphics.setColor(gColors['defaultcell'])
        else
            -- color for user inputted values
            love.graphics.setColor(gColors['userinputcell'])
        end
        
        if self.selected then
            -- color for selected cell
            love.graphics.setColor(gColors['dark_green'])
        elseif self.relatedHighlight then
            love.graphics.setColor(gColors['dark_green']) 
        elseif self.weakRelationHighlight then
            love.graphics.setColor(gColors['highlighted'])
        end

        if not self.isvalid then
            love.graphics.setColor(gColors['invalidcell'])
        end
        
        love.graphics.setFont(gFonts['cellFont'])
        love.graphics.printf(self.solution, self:getX(), self:getY() + CELL_H / 2 - gFonts['cellFont']:getHeight() / 2, CELL_W, 'center')
    end

    -- draw candidates in subscript
    for k, candidate in pairs(self.candidates) do
        if candidate ~= 0 then
            love.graphics.setFont(gFonts['subscriptFont'])
            love.graphics.setColor(gColors['highlighted'])
            if candidate == self.selectedCellValue then
                love.graphics.setColor(gColors['dark_green'])
            end
            -- 00 01 02   01 02 03     k - 1 / 3 gives row
            -- 10 11 12   04 05 06     k - 1 % 3 gives col 
            -- 20 21 22   07 08 09
            -- self.x, self.x + (CELL_W / 3) * (k - 1 % 3), self.x + (CELL_W / 3) * 2 
            -- self.y, self.y + (CELL_H / 3), self.y + (CELL_H / 3) * 2
            love.graphics.printf(candidate, self:getX() + CELL_W / 3 * ((k - 1) % 3), self:getY() + (CELL_H / 3) * math.floor((k - 1) / 3), CELL_W / 3, 'center')
        end
    end
    
end

>>>>>>> 59c795889d2695624fa5d750edd5ea2632e86e7f
