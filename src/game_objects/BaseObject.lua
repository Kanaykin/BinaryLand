require "src/base/Inheritance"
require "src/base/Log"

BaseObject = inheritsFrom(nil)
BaseObject.mNode = nil;
BaseObject.mField = nil;
BaseObject.mId = nil;
BaseObject.mGridPosition = nil;

--------------------------------
function BaseObject:setId(id)
    info_log("BaseObject:setId ", id);
    self.mId = id;
end

--------------------------------
function BaseObject:getId()
    return self.mId;
end

--------------------------------
function BaseObject:getField()
    return self.mField;
end

---------------------------------
function BaseObject:isMob()
    return false;
end

---------------------------------
function BaseObject:store(data)
    return true
end

--------------------------------
function BaseObject:restore(data)
end

---------------------------------
function BaseObject:onStatePause()
end

---------------------------------
function BaseObject:onStateInGame()
end

--------------------------------
function BaseObject:destroyNodeImpl(node)
	if node then
		local parent = node:getParent();
		parent:removeChild(node, true);
		node:release();
	end
end

--------------------------------
function BaseObject:destroyNode()
	if self.mNode then
		self:destroyNodeImpl(self.mNode);
		self.mNode = nil;
	end
end

--------------------------------
function BaseObject:convertToId(gridPosX, gridPosY, tag)
    return tostring(gridPosX).."_"..tostring(gridPosY).."_"..tostring(tag);
end

---------------------------------
function BaseObject:getNode()
    return self.mNode;
end

---------------------------------
function BaseObject:onStateWin()
end

---------------------------------
function BaseObject:getTag()
	if self.mNode then
		return self.mNode:getTag();
	end
	return nil;
end

--------------------------------
function BaseObject:setOrder(orderPos)
	if self.mNode then
    	local parent = self.mNode:getParent();
    	parent:removeChild(self.mNode, false);
    	parent:addChild(self.mNode, orderPos);
    end
end

---------------------------------
function BaseObject:getScreenPos()
	if self.mNode then
		local point = self.mNode:convertToWorldSpace(cc.p(0, 0)); --self.mField:fieldToScreen(Vector.new(self.mNode:getPosition()));
		return Vector.new(point.x, point.y);
	end
	
	return Vector.new(0, 0);
end

---------------------------------
function BaseObject:getPosition()
	if self.mNode then
    	return Vector.new(self.mNode:getPosition());
    end
    return Vector.new(0, 0);
end

---------------------------------
function BaseObject:setCustomProperties(properties)
end

---------------------------------
function BaseObject:getBoundingBox()
	if self.mNode then
		return self.mNode:getBoundingBox();
	end

	return 0, 0, 0, 0
end

--------------------------------
function BaseObject:init(field, node)
	self.mNode = node;
	self.mNode:retain();
	self.mField = field;

    self.mGridPosition = Vector.new(field:getGridPosition(node));

    self:setId(BaseObject:convertToId(self.mGridPosition.x, self.mGridPosition.y, self:getNode():getTag()));
end

---------------------------------
function BaseObject:getGridPosition()
	return self.mGridPosition;
end

---------------------------------
function BaseObject:destroy()
	self:destroyNode();
end

--------------------------------
function BaseObject:tick(dt)

end

--------------------------------
function BaseObject:setVisible(visible)
	if self.mNode then
		self.mNode:setVisible(visible);
	end
end

--------------------------------
function BaseObject:postInit()
end
