package.path = package.path .. os.getenv("BINARY_LAND_PATH")

require "src/base/Inheritance"
cc = {
	p = function (x_in, y_in)
		return {x = x_in, y = y_in}
	end,
	size = function (width_in, height_in)
		return {width = width_in, height = height_in}
	end,
	rect = function (x_in, y_in, width_in, height_in)
		return {x = x_in, y = y_in, width = width_in, height = height_in}
	end
}

function release_print(...)
    print(...);
end

------------------------------------
tolua = {
	cast = function(obj)
		return obj;
	end
}

------------------------------------
NodeMock = inheritsFrom(nil)
NodeMock.mParent = nil;
NodeMock.mPosition = cc.p(0, 0);

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

function NodeMock:getTexture()
	return self.mTexture;
end

function NodeMock:getAnchorPoint()
	return cc.p(0, 0);
end

function NodeMock:setAnchorPoint(point)
end

function NodeMock:getContentSize()
	return cc.size(1, 1);
end

function NodeMock:setPosition(pos)
	self.mPosition = pos;
end

function NodeMock:getPosition()
	return self.mPosition.x, self.mPosition.y;
end

function NodeMock:getBoundingBox()
	cc.rect(0,0,0,0);
end

CCNode = {
	create = function ()
		local node = NodeMock:create()
		return node;
	end
}

------------------------------------
TextureMock = inheritsFrom(nil)

function TextureMock:getName()
	return "temp";
end

------------------------------------
--[[FieldMock = inheritsFrom(nil)
FieldMock.mFieldNode = nil;

function FieldMock:getFieldNode()
	return self.mFieldNode;
end

function FieldMock:getGridPosition(node)
	return 0, 0;
end

function FieldMock:getCellSize()
	return 1;
end]]

------------------------------------
GameMock = inheritsFrom(nil)

function GameMock:getScale()
	return 1;
end
