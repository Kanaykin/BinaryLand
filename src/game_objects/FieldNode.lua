require "src/scenes/BaseScene"
require "src/base/Log"

FieldNode = inheritsFrom(BaseScene)
FieldNode.mNodes = nil;
FieldNode.mSize = nil;
FieldNode.mChildren = nil;
FieldNode.mLayer = nil;

--------------------------------
function FieldNode:addChild(node)
	self.mLayer:addChild(node);
end

--------------------------------
function FieldNode:getContentSize()
	return self.mSize;
end

--------------------------------
function FieldNode:getChildren()
	return self.mChildren;
end

--------------------------------
function FieldNode:getScrollPos()
	if self.mScrollView.getContentOffset then
		local point = self.mScrollView:getContentOffset();
		return Vector.new(point.x, point.y);
	end
    return Vector.new(0, 0);
end

--------------------------------
function FieldNode:setScrollPos(pos)
	debug_log("FieldNode:setScrollPos ", pos.y);
	if self.mScrollView.setContentOffset then
		self.mScrollView:setContentOffset(cc.p(0, -pos.y));
	end
end

--------------------------------
function FieldNode:getNodes()
	return self.mNodes;
end

--------------------------------
function FieldNode:getScrollView()
    return self.mScrollView;
end

--------------------------------
function FieldNode:init(nodes, layer, field)
	self.mNodes = nodes;
	self.mChildren = CCArray:create();
	self.mScrollView = layer;

	local height = 0;
	local width = 0;
	for i, node in ipairs(nodes) do
		local children = node:getChildren();
        local count = #children;
		for i = 1, count do
			local child = tolua.cast(children[i], "cc.Node");
            local x = child:getPositionX();
            local y = child:getPositionY();
			y = y + height;
			child:setPosition(x, y);
			self.mChildren:addObject(child);
		end

		local layerSize = node:getContentSize();
		
		height = height + layerSize.height;
		width = math.max(width, layerSize.width);

		--[[if children then
			self.mChildren:addObjectsFromArray(children);
		end]]
	end

	self.mSize = cc.size(width, height);
	local newLayer = cc.Layer:create();
	newLayer:setContentSize(self.mSize);
	info_log(" !!!!! size layer ", self.mSize.width, self.mSize.height);
	self.mLayer = newLayer;

	layer:addChild(newLayer);
	if #nodes ~= 0 then
		local posX, posY = nodes[1]:getPosition();
		local anchor = nodes[1]:getAnchorPoint();
		local size = nodes[1]:getContentSize();
		posX, posY = posX - anchor.x * size.width, posY - anchor.y * size.height;
		info_log(" !!!!! ", size.width, size.height);
		newLayer:setPosition(posX, posY);
		--newLayer:setAnchorPoint(nodes[1]:getAnchorPoint());
	end

	--self:setScrollPos(Vector.new(0, 800));

    local bricks_array = {};
	-- move to new layers
	local count = self.mChildren:count();
	for i = 1, count do
		local child = tolua.cast(self.mChildren:objectAtIndex(i - 1), "cc.Node");
		child:getParent():removeChild(child, false);
		local posGridX, posGridY = field:getGridPosition(child);

        local  tag = child:getTag();
        if tag == FactoryObject.BRICK_TAG then
            local index = -posGridY * 2;
            --debug_log("brick !!!! index ", index);
            if bricks_array[index] == nil then
                bricks_array[index] = {}
            end
            bricks_array[index][#bricks_array[index] + 1] = child;
        else
            newLayer:addChild(child, -posGridY * 2);
        end
		
		--child:setVertexZ(-posGridY);
	end

	for index, node in pairs(bricks_array) do
        for i = 1, #bricks_array[index] do
            local posGridX, posGridY = field:getGridPosition(bricks_array[index][i]);
            if posGridX % 2 == 1 then
                newLayer:addChild(bricks_array[index][i], index);
            end
        end
        for i = 1, #bricks_array[index] do
            local posGridX, posGridY = field:getGridPosition(bricks_array[index][i]);
            if posGridX % 2 == 0 then
                newLayer:addChild(bricks_array[index][i], index);
            end
        end
    end
end
