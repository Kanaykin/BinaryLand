require "src/base/Inheritance"
require "src/game_objects/MovableObject"

Arrow =  inheritsFrom(BaseObject)
Arrow.SPRITE_TAG = 10;
Arrow.is_vertical = false;

--------------------------------
function Arrow:init(gameScene, field, playerPos, finishPos)
	local ccpproxy = cc.CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("Arrow", reader, false);
	self.mNode = node;

	field:getFieldNode():addChild(node);
	--gameScene:addChild(node);
	Arrow:superClass().init(self, field, node);

	local sprite = self.mNode:getChildByTag(Arrow.SPRITE_TAG);
	local sprite = tolua.cast(sprite, "ccui.Scale9Sprite");
	GuiHelper.updateScale9SpriteByScale(sprite, self.mField:getGame():getScale());

	self:setTransform(playerPos, finishPos, true);
end

--------------------------------
function Arrow:updateLength(posFrom, posTo)
	local old_pos = Vector.new(self.mNode:getPosition());
	if self.is_vertical then
		self.mNode:setPosition(cc.p(old_pos.x, posFrom.y));
	else
		self.mNode:setPosition(cc.p(posFrom.x, old_pos.y));
	end

	-- compute length
	local vec = posTo - posFrom;
	local sprite = self.mNode:getChildByTag(Arrow.SPRITE_TAG);
	local sprite = tolua.cast(sprite, "ccui.Scale9Sprite");
	--info_log("[Arrow:setPositions] sprite ", sprite);
	local oldPreferredSize = sprite:getPreferredSize();

	sprite:setPreferredSize(cc.size(oldPreferredSize.width, math.max(math.abs(vec.x), math.abs(vec.y))));
end

--------------------------------
function Arrow:setTransform(posFrom, posTo, needRotate)
	-- set node position
	self.mNode:setPosition(cc.p(posFrom.x, posFrom.y));
	--self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));

	-- compute length
	local vec = posTo - posFrom;
	local sprite = self.mNode:getChildByTag(Arrow.SPRITE_TAG);
	local sprite = tolua.cast(sprite, "ccui.Scale9Sprite");
	--info_log("[Arrow:setPositions] sprite ", sprite);
	local oldPreferredSize = sprite:getPreferredSize();
	sprite:setPreferredSize(cc.size(oldPreferredSize.width, math.max(math.abs(vec.x), math.abs(vec.y))));

	if math.abs(vec.x) < math.abs(vec.y) then
		self.is_vertical = true
	end
	--sprite:updateWithSprite(sprite:getSprite(), cc.rect(0,0, 18, vec.x), true, cc.rect(0,0, 0, 0));

	if needRotate then
		local posFromGrid = Vector.new(self.mField:positionToGrid(posFrom));
		local posToGrid = Vector.new(self.mField:positionToGrid(posTo));
		local vecDelta = posToGrid - posFromGrid;
		--info_log("[Arrow:setPositions] vecDelta.x ", vecDelta.x, " vecDelta.y ", vecDelta.y);

		-- compute rotation
		local angle = math.atan2(vecDelta.x, vecDelta.y);
		if vecDelta:lenSq() <= 0.01 then
			angle = math.atan2(vec.x, vec.y);
		end
		self.mNode:setRotation(math.deg(angle));
	end
end
