package.path = package.path .. os.getenv("BINARY_LAND_PATH")

require "src/base/Inheritance"
cc = {
	p = function (x_in, y_in)
		return {x = x_in, y = y_in}
	end,
	size = function (width_in, height_in)
		return {width = width_in, height = height_in}
	end
}

function release_print(...)
    print(...);
end

------------------------------------
NodeMock = inheritsFrom(nil)

function NodeMock:retain()
end

function NodeMock:getTag()
	return "1";
end

function NodeMock:setContentSize()
end

function NodeMock:getParent()
	return self.mParent;
end

function NodeMock:removeChild()
end

function NodeMock:addChild()
end

------------------------------------
FieldMock = inheritsFrom(nil)

function FieldMock:getGridPosition(node)
	return 0, 0;
end

function FieldMock:getCellSize()
	return 1;
end

------------------------------------
GameMock = inheritsFrom(nil)

function GameMock:getScale()
	return 1;
end
