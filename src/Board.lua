Board = Class{}

function Board:init(xoffset, yoffset, difficulty)
    -- top left corner of the board
    self.xoffset = xoffset
    self.yoffset = yoffset
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
    if self:isComplete() then
        print('Puzzle Solved')
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
    -- this will be the index assigned to each cell
    i = 0
    -- an empty board for the random generator to work with
    for x = 0, 8, 1 do
        for y = 0, 8, 1 do
            table.insert(self.cells, Cell(i, x, y, self.xoffset, self.yoffset, 0))    
            i = i + 1 
        end
    end
    -- creates a full random board
    self:_generateRandomBoard(1)
    
    for k, cell in pairs(self.cells) do
        cell:setAsDefault()
    end

    c = 0
    while true do
        r = math.random(1, 81)
        if self.cells[r].solution ~= 0 then
            self.cells[r]:maskCell()
            c = c + 1    
        end
        if c  == difficulty then
            break
        end
    end
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
        if self:isValid(cell.row, cell.col, r) then
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
    isvalid = self:isValid(cell.row, cell.col, num)
    cell:input(num, isvalid, self.pencilMode)
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
    
    xb = math.floor(row / 3) * 3
    yb = math.floor(col / 3) * 3
    for k, cell in pairs(self.cells) do
        -- check if solution is same and the cell is not the same as parameter cell
        -- converting the row col to string for easy comparison of row,col combination
        if cell.solution == num and row .. col ~= cell.row .. cell.col then
            if cell.col == col or cell.row == row then
                return false
            end
            if inList(cell.row, {xb, xb + 1, xb + 2}) and inList(cell.col, {yb, yb + 1, yb + 2}) then
                return false
            end
        end
    end
    return true
end

