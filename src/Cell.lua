Cell = Class{}


QUAD_OFFSET = {1, 4, 7, 9, 11, 12, 14, 15, 17, 19, 22, 25}
function Cell:init(index, row, col, xoffset, yoffset, solution)
    self.index = index
    -- index position for cell 
    self.row = row
    self.col = col
    -- x y coordinate of top left
    self.x = self.col * CELL_W + xoffset
    self.y = self.row * CELL_H + yoffset
    self.selected = false
    self.isvalid = true
    self.solution = solution or 0
    if solution ~= 0 then
        self._default = true
    end
    self.candidates = {0,0,0,0,0,0,0,0,0}
end

function Cell:update(dt)
end

function Cell:addCandidate(num)
    if not inList(num, self.candidates) then
        self.candidates[num] = num
    else
        self.candidates[num] = 0
    end
end

function Cell:input(num, isValid, pencilMode)
    -- insert only if the cell is not a default provided cell
    if not self._default then
        if pencilMode then
            self:addCandidate(num)
        else 
            self.solution = num
            self.isvalid = isValid
            self.candidates = {0,0,0,0,0,0,0,0,0}
        end
    end
end

function Cell:render()
    
    -- 00 01 02   [03 04 05]  06 07 08      00 01 02  03 04 05  06 07 08
    -- 10 11 12   [13 14 15]  16 17 18      09 10 11  12 13 14  15 16 17     
    -- 20 21 22   [23 24 25]  26 27 28      18 19 20  21 22 23  24 25 26 
    
    -- [30 31 32]  33 34 35  [36 37 38]     27 28 29  30 31 32  33 34 35  
    -- [40 41 42]  43 44 45  [46 47 48]     36 37 38  39 40 41  42 43 44 
    -- [50 51 52]  53 54 55  [56 57 58]     45 46 47  48 49 50  51 52 53 
    
    -- 60 61 62   [63 64 65]  66 67 68      54 55 56  57 58 59  60 61 62
    -- 70 71 72   [73 74 75]  76 77 78      63 64 65  66 67 68  69 70 71
    -- 80 81 82   [83 84 85]  86 87 88      72 73 74  75 76 77  78 79 80

    -- set offset colors
    if inList(math.floor(self.index / 3), QUAD_OFFSET) then
        love.graphics.setColor(gColors['offsetcell'])        
    else
        love.graphics.setColor(gColors['cell'])
    end

    -- set color for invalid cells
    if not self.isvalid then
        love.graphics.setColor(gColors['invalidcell'])
    end

    -- draw the cell
    love.graphics.rectangle('fill', self.x+1, self.y+1, CELL_W-2, CELL_H-2)    

    -- draw number for cells where solution value is not 0
    if self.solution ~= 0 then
        if self._default then
            -- color for default values given in puzzle
            love.graphics.setColor(gColors['defaultcell'])
        else
            -- color for user inputted values
            love.graphics.setColor(gColors['userinputcell'])
        end
        love.graphics.setFont(gFonts['cellFont'])
        love.graphics.printf(self.solution, self.x, self.y + CELL_H / 2 - gFonts['cellFont']:getHeight() / 2, CELL_W, 'center')
    end

    for k, v in pairs(self.candidates) do
        if v ~= 0 then
            love.graphics.setColor(gColors['highlighted'])
            love.graphics.setFont(gFonts['subscriptFont'])
            -- 00 01 02   01 02 03     k - 1 / 3 gives row
            -- 10 11 12   04 05 06     k - 1 % 3 gives col 
            -- 20 21 22   07 08 09
            -- self.x, self.x + (CELL_W / 3) * (k - 1 % 3), self.x + (CELL_W / 3) * 2 
            -- self.y, self.y + (CELL_H / 3), self.y + (CELL_H / 3) * 2
            love.graphics.printf(v, self.x + CELL_W / 3 * ((k - 1) % 3), self.y + (CELL_H / 3) * math.floor((k - 1) / 3), CELL_W / 3, 'center')
        end
    end
    
    -- highlight the cell if the cell is selected
    if self.selected then
        love.graphics.setColor(gColors['selectedcell'])
        love.graphics.rectangle('fill', self.x, self.y, CELL_W, CELL_H)  
    end
end

