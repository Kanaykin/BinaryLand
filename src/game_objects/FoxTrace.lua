require "src/base/Inheritance"

FoxTrace = inheritsFrom(nil)
FoxTrace.mFieldSize = nil
FoxTrace.mFieldArray = nil
FoxTrace.mLastGridPos = nil
FoxTrace.mIndex = 1
FoxTrace.LENGTH_TRACE = 10

--------------------------------
function FoxTrace:init(size)
    self.mFieldSize = size;

    self.mFieldArray = {};
    for i = 0, self.mFieldSize.x do
        for j = 0, self.mFieldSize.y do
            self.mFieldArray[COORD(i, j, self.mFieldSize.x)] = 0;
        end
    end
end

--------------------------------
function FoxTrace:updatePosition(gridPosition)
    if not self.mLastGridPos or self.mLastGridPos ~= gridPosition then
        self.mFieldArray[COORD(gridPosition.x, gridPosition.y, self.mFieldSize.x)] = self.mIndex;
        self.mIndex = self.mIndex + 1;
        self.mLastGridPos = gridPosition:clone();
        debug_log("FoxTrace:updatePosition index self.mIndex ", self.mIndex, " x ", gridPosition.x,
            " y ", gridPosition.y);
    end

end

--------------------------------
function FoxTrace:short_path(path, gridPosition)
    local short_path = {};
    for i, val in ipairs(path) do
        table.insert(short_path, val);
        if gridPosition == val then
            break;
        end
    end
    short_path = WavePathFinder.reversePath(short_path);
    WavePathFinder.printPath(short_path);
    return short_path;
end


--------------------------------
function FoxTrace:findTrace(gridPosition)
    local found_ind = self.mFieldArray[COORD(gridPosition.x, gridPosition.y, self.mFieldSize.x)];
    if found_ind > 0 then
        local delta = self.mIndex - found_ind - 1;
        debug_log("FoxTrace:findTrace delta ", delta);
        debug_log("FoxTrace:findTrace gridPosition.x ", gridPosition.x, " gridPosition.y ", gridPosition.y);
        if FoxTrace.LENGTH_TRACE > delta then
            local path = {self.mLastGridPos};
            WavePathFinder.findPath(path, self.mFieldArray, self.mFieldSize);
            debug_log("path found ", #path);
            return self:short_path(path, gridPosition);
        end
    end
    return nil;
end

