Rect = {}
Rect.__index = Rect

function Rect.new(val1, val2, width, height)
    if type(val1) == "table" then
        return setmetatable({ x = val1.x or 0, y = val1.y or 0, width = val1.width or 0, height = val1.height or 0 }, Rect)
    end
    return setmetatable({ x = val1 or 0, y = val2 or 0, width = width or 0, height = height or 0 }, Rect)
end

function Rect:containsPoint(point)
    --print("Rect:containsPoint point x ", point.x, " y ", point.y);
    return point.x >= self.x and point.y >= self.y
        and point.x <= self.x + self.width and point.y <= self.y + self.height;
end

function Rect:intersectsRect(rect)
    return not(     (self.x + self.width) < rect.x or
             (rect.x + rect.width) <      self.x or
                  (self.y + self.height) < rect.y or
             (rect.y + rect.height) <      self.y);
end