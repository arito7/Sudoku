Button = Class{}

function Button:init(font, text, x, y)
    self.font = font
    self.text = text
    self.x = WINDOW_WIDTH / 2 - self:getWidth() / 2
    self.y = y
    self.selected = false
end

function Button:update()
    
end

function Button:onClick()
    self.selected = not self.selected
end

function Button:getWidth()
    return self.font:getWidth(self.text)
end

function Button:getHeight()
    return self.font:getHeight()
end

function Button:render()
    if self.selected then
        love.graphics.setColor(0.1, 0.1, 0.1, 1.0)
    else
        love.graphics.setColor(0.3, 0.3, 0.3, 0.5)
    end
    love.graphics.printf(self.text, 0, self.y, WINDOW_WIDTH, 'center')
end