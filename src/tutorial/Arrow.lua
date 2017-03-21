require "src/base/Inheritance"
require "src/game_objects/MovableObject"

Arrow =  inheritsFrom(BaseObject)
Arrow.SPRITE_TAG = 10;

--------------------------------
function Arrow:init(gameScene, field)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("Arrow", reader, false);
	self.mNode = node;

	field:getFieldNode():addChild(node);
	--gameScene:addChild(node);
	Arrow:superClass().init(self, field, node);

	local sprite = self.mNode:getChildByTag(Arrow.SPRITE_TAG);
	local sprite = tolua.cast(sprite, "ccui.Scale9Sprite");
	GuiHelper.updateScale9SpriteByScale(sprite, self.mField:getGame():getScale());
end

--------------------------------
function Arrow:setPositions(posFrom, posTo)
	-- set node position
	self.mNode:setPosition(cc.p(posFrom.x, posFrom.y));
	--self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));

	-- compute length
	local posFromGrid = Vector.new(self.mField:positionToGrid(posFrom));
	local posToGrid = Vector.new(self.mField:positionToGrid(posTo));
	local vecDelta = posToGrid - posFromGrid;
	info_log("[Arrow:setPositions] vecDelta.x ", vecDelta.x, " vecDelta.y ", vecDelta.y);

	local vec = posTo - posFrom;
	local sprite = self.mNode:getChildByTag(Arrow.SPRITE_TAG);
	local sprite = tolua.cast(sprite, "ccui.Scale9Sprite");
	info_log("[Arrow:setPositions] sprite ", sprite);
	local oldPreferredSize = sprite:getPreferredSize();
	sprite:setPreferredSize(cc.size(oldPreferredSize.width, math.max(vec.x, vec.y)));
	--sprite:updateWithSprite(sprite:getSprite(), cc.rect(0,0, 18, vec.x), true, cc.rect(0,0, 0, 0));

	-- compute rotation
	local angle = math.atan2(vecDelta.x, vecDelta.y);
	if vecDelta:lenSq() <= 0.01 then
		angle = math.atan2(vec.x, vec.y);
	end
	self.mNode:setRotation(math.deg(angle));
end
