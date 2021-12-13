<<<<<<< HEAD
Board = Class{}

function Board:init(xoffset, yoffset, difficulty)
    -- top left corner of the board
    self.xoffset = xoffset
    self.yoffset = yoffset

    -- the number of cells to mask
    self.difficulty = difficulty or DIFFICULTY[1]
    -- bool to keep track of whether pencil mode is on or not
    self.pencilMode = false
    
    self.cells = {}

    self:generateRandomBoard(self.difficulty)
end


function Board:update(dt)
    local index = self:getCurrentSelection()
    selectedCell = self.cells[index]
    for k, cell in pairs(self.cells) do
        cell:update(dt, selectedCell)
    end
end

function Board:render()
    for k, cell in pairs(self.cells) do
        cell:render()
    end
end


--[[
    Parent function for _generateRandomBoard()
    because _generateRandomBoard is recursive and requires a parameter
]]
function Board:generateRandomBoard(difficulty)
    -- clearing cells before creating an empty board
    self.cells = {}
    -- an empty board for the random generator to work with
    for i = 1, 81, 1 do
        table.insert(self.cells, Cell(i, self.xoffset, self.yoffset, 0))    
    end
    -- creates a full random board
    self:_generateRandomBoard(1)

    -- set all cells as default for new board    
    for k, cell in pairs(self.cells) do
        cell:setAsDefault()
    end

    self:shuffle(difficulty)
end


--[[ 
    A recursive function that generates a random valid sudoku board
    @param i must be 1 for the very first call because tables in lua start at index 1 
    should only be called from generateRandomBoard()
]]
function Board:_generateRandomBoard(i)
    -- base case, there is no index 82 so this is the end of the board
    if i == 82 then
        return true
    end

    -- cell corresponding to parameter i
    cell = self.cells[i]

    -- nums has to be local or else the next iteration will 
    -- refer to the same list
    -- stores the used random candidates
    local nums = {}

    while true do
        -- random has to be local or else the next iteration will 
        -- refer to the same number when it returns
        local r = math.random(1,9)
        if inList(r, nums) then 
            goto continue 
        end
        if self:isValid(cell:getRow(), cell:getCol(), r) then
            cell.solution = r
            if self:_generateRandomBoard(i + 1) then
                return true
            else
                self.cells[i + 1].solution = 0
            end
        end    
        table.insert(nums, r)
        if table.getn(nums) == 9 then
            return false
        end
        ::continue::
    end
end    


function Board:shuffle(difficulty)
    local used = {}
    local i = 0
    -- mask cells depending on difficulty
    while true do
        local randomi = math.random(1,40)
        if not inList(randomi, used) then
            self.cells[41 - randomi].solution = 0
            self.cells[41 - randomi]:maskCell()
            self.cells[41 + randomi].solution = 0
            self.cells[41 + randomi]:maskCell()
            table.insert(used, randomi)
            i = i + 1
        end
        if i == difficulty then
            break
        end
    end
    
    -- swap rows and columns
    rolls = {{1, 3}, {4, 6}, {7, 9}}
    for k, set in pairs(rolls) do       
        index1 = math.random(set[1], set[2])
        index2 = index1
        while index1 == index2 do
            index2 = math.random(set[1], set[2])
        end
        print(index1, index2)
        self:swapRows(index1, index2)
        self:swapColumns(index1, index2)
    end

end


--[[
    Swaps 2 rows
]]
function Board:swapRows(row1, row2)
    local index1 = (row1 - 1) * 9
    local index2 = (row2 - 1) * 9
    for i = 1, 9, 1 do
        i1 = index1 + i
        i2 = index2 + i
        temp = self.cells[i1]
        self.cells[i1] = self.cells[i2]
        self.cells[i2] = temp
        self.cells[i1].index = i1
        self.cells[i2].index = i2 
    end    
end


--[[
    Swaps 2 columns
]]
function Board:swapColumns(col1, col2)
    for i = 0, 8, 1 do
        local i1 = col1 + 9 * i
        local i2 = col2 + 9 * i
        temp = self.cells[i1]
        self.cells[i1] = self.cells[i2]
        self.cells[i2] = temp
        -- switch the indexes because cell render uses 
        -- the index to determine its position
        self.cells[i1].index = i1
        self.cells[i2].index = i2
    end
end


--[[
    should be called from outside to change between pencil mode and input mode
]]
function Board:toggleMode()
    self.pencilMode = not self.pencilMode
end


--[[
    Check if a board is solved.
    Meant to be called from update to determine when a user 
    has solved the puzzle.
]]
function Board:isComplete()
    for k, cell in pairs(self.cells) do
        if not cell.solved then
            return false
        end
    end
    return true
end


--[[
    returns the currently highlighted cell
    there can only be one cell highlighted at a time
]]
function Board:getCurrentSelection()
    for k, cell in pairs(self.cells) do
        if cell.selected then
            return k
        end
    end
    return 40
end


--[[
    Used to input a number into a cell
    Will only pass valid values
    Cell cannot confirm whether an input is valid
    because cell is not aware of other cells,
    therefore we verify the validity here before passing it off
    to the cell.
    Cell uses the validity value to render a invalid/valid input.
]]
function Board:insertSolution(num, index)
    cell = self.cells[index]
    isValid = self:isValid(cell:getRow(), cell:getCol(), num)
    cell:input(num, isValid, self.pencilMode)
    if isValid then
        for k, v in pairs(self.cells) do
            v:removeCandidate(cell)
        end
    end
end


--[[
    Checks if a number is a valid input at given coordinates
]]
function Board:isValid(row, col, num)
    -- don't consider zero a wrong input because
    -- zero is a blank cell
    if num == 0 then
        return true
    end
    
    local xb = math.floor(row / 3) * 3
    local yb = math.floor(col / 3) * 3
    for k, cell in pairs(self.cells) do
        -- check if solution is same and the cell is not the same as parameter cell
        -- converting the row col to string for easy comparison of row,col combination
        if cell.solution == num and row .. col ~= cell:getRow() .. cell:getCol() then
            if cell:getCol() == col or cell:getRow() == row then
                return false
            end
            if inList(cell:getRow(), {xb, xb + 1, xb + 2}) and inList(cell:getCol(), {yb, yb + 1, yb + 2}) then
                return false
            end
        end
    end
    return true
end

=======
Board = Class{}

function Board:init(xoffset, yoffset, difficulty)
    -- top left corner of the board
    self.xoffset = xoffset
    self.yoffset = yoffset

    -- the number of cells to mask
    self.difficulty = difficulty or DIFFICULTY[1]
    -- bool to keep track of whether pencil mode is on or not
    self.pencilMode = false
    
    self.cells = {}

    self:generateRandomBoard(self.difficulty)
end


function Board:update(dt)
    local index = self:getCurrentSelection()
    selectedCell = self.cells[index]
    for k, cell in pairs(self.cells) do
        cell:update(dt, selectedCell)
    end
end

function Board:render()
    for k, cell in pairs(self.cells) do
        cell:render()
    end
end


--[[
    Parent function for _generateRandomBoard()
    because _generateRandomBoard is recursive and requires a parameter
]]
function Board:generateRandomBoard(difficulty)
    -- clearing cells before creating an empty board
    self.cells = {}
    -- an empty board for the random generator to work with
    for i = 1, 81, 1 do
        table.insert(self.cells, Cell(i, self.xoffset, self.yoffset, 0))    
    end
    -- creates a full random board
    self:_generateRandomBoard(1)

    -- set all cells as default for new board    
    for k, cell in pairs(self.cells) do
        cell:setAsDefault()
    end

    self:shuffle(difficulty)
end


--[[ 
    A recursive function that generates a random valid sudoku board
    @param i must be 1 for the very first call because tables in lua start at index 1 
    should only be called from generateRandomBoard()
]]
function Board:_generateRandomBoard(i)
    -- base case, there is no index 82 so this is the end of the board
    if i == 82 then
        return true
    end

    -- cell corresponding to parameter i
    cell = self.cells[i]

    -- nums has to be local or else the next iteration will 
    -- refer to the same list
    -- stores the used random candidates
    local nums = {}

    while true do
        -- random has to be local or else the next iteration will 
        -- refer to the same number when it returns
        local r = math.random(1,9)
        if inList(r, nums) then 
            goto continue 
        end
        if self:isValid(cell:getRow(), cell:getCol(), r) then
            cell.solution = r
            if self:_generateRandomBoard(i + 1) then
                return true
            else
                self.cells[i + 1].solution = 0
            end
        end    
        table.insert(nums, r)
        if table.getn(nums) == 9 then
            return false
        end
        ::continue::
    end
end    


function Board:shuffle(difficulty)
    local used = {}
    local i = 0
    -- mask cells depending on difficulty
    while true do
        local randomi = math.random(1,40)
        if not inList(randomi, used) then
            self.cells[41 - randomi].solution = 0
            self.cells[41 - randomi]:maskCell()
            self.cells[41 + randomi].solution = 0
            self.cells[41 + randomi]:maskCell()
            table.insert(used, randomi)
            i = i + 1
        end
        if i == difficulty then
            break
        end
    end
    
    -- swap rows and columns
    rolls = {{1, 3}, {4, 6}, {7, 9}}
    for k, set in pairs(rolls) do       
        index1 = math.random(set[1], set[2])
        index2 = index1
        while index1 == index2 do
            index2 = math.random(set[1], set[2])
        end
        print(index1, index2)
        self:swapRows(index1, index2)
        self:swapColumns(index1, index2)
    end

end


--[[
    Swaps 2 rows
]]
function Board:swapRows(row1, row2)
    local index1 = (row1 - 1) * 9
    local index2 = (row2 - 1) * 9
    for i = 1, 9, 1 do
        i1 = index1 + i
        i2 = index2 + i
        temp = self.cells[i1]
        self.cells[i1] = self.cells[i2]
        self.cells[i2] = temp
        self.cells[i1].index = i1
        self.cells[i2].index = i2 
    end    
end


--[[
    Swaps 2 columns
]]
function Board:swapColumns(col1, col2)
    for i = 0, 8, 1 do
        local i1 = col1 + 9 * i
        local i2 = col2 + 9 * i
        temp = self.cells[i1]
        self.cells[i1] = self.cells[i2]
        self.cells[i2] = temp
        -- switch the indexes because cell render uses 
        -- the index to determine its position
        self.cells[i1].index = i1
        self.cells[i2].index = i2
    end
end


--[[
    should be called from outside to change between pencil mode and input mode
]]
function Board:toggleMode()
    self.pencilMode = not self.pencilMode
end


--[[
    Check if a board is solved.
    Meant to be called from update to determine when a user 
    has solved the puzzle.
]]
function Board:isComplete()
    for k, cell in pairs(self.cells) do
        if not cell.solved then
            return false
        end
    end
    return true
end


--[[
    returns the currently highlighted cell
    there can only be one cell highlighted at a time
]]
function Board:getCurrentSelection()
    for k, cell in pairs(self.cells) do
        if cell.selected then
            return k
        end
    end
    return 40
end


--[[
    Used to input a number into a cell
    Will only pass valid values
    Cell cannot confirm whether an input is valid
    because cell is not aware of other cells,
    therefore we verify the validity here before passing it off
    to the cell.
    Cell uses the validity value to render a invalid/valid input.
]]
function Board:insertSolution(num, index)
    cell = self.cells[index]
    isValid = self:isValid(cell:getRow(), cell:getCol(), num)
    cell:input(num, isValid, self.pencilMode)
    if isValid then
        for k, v in pairs(self.cells) do
            v:removeCandidate(cell)
        end
    end
end


--[[
    Checks if a number is a valid input at given coordinates
]]
function Board:isValid(row, col, num)
    -- don't consider zero a wrong input because
    -- zero is a blank cell
    if num == 0 then
        return true
    end
    
    local xb = math.floor(row / 3) * 3
    local yb = math.floor(col / 3) * 3
    for k, cell in pairs(self.cells) do
        -- check if solution is same and the cell is not the same as parameter cell
        -- converting the row col to string for easy comparison of row,col combination
        if cell.solution == num and row .. col ~= cell:getRow() .. cell:getCol() then
            if cell:getCol() == col or cell:getRow() == row then
                return false
            end
            if inList(cell:getRow(), {xb, xb + 1, xb + 2}) and inList(cell:getCol(), {yb, yb + 1, yb + 2}) then
                return false
            end
        end
    end
    return true
end

>>>>>>> 59c795889d2695624fa5d750edd5ea2632e86e7f
