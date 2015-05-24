require "src/game_objects/MultiTrigger"
require "src/base/Log"

FightTrigger = inheritsFrom(MultiTrigger)
FightTrigger.mActivated = false;
FightTrigger.mNodeSecond = nil;

--------------------------------
function FightTrigger:init(field)
	local node = CCNode:create();
    node:setContentSize(cc.size(field:getCellSize(), field:getCellSize() * 3));
	field:getFieldNode():addChild(node);

	-- #FIXME: anchor point for fox scene
	node:setAnchorPoint(cc.p(0.5, 0.5));

	FightTrigger:superClass().init(self, field, node, Callback.new(field, Field.onEnemyEnterTrigger), Callback.new(field, Field.onEnemyLeaveTrigger));

    local nodeSecond = CCNode:create();
    nodeSecond:setContentSize(cc.size(field:getCellSize() * 3, field:getCellSize()));
    field:getFieldNode():addChild(nodeSecond);

    nodeSecond:setAnchorPoint(cc.p(0.5, 0.5));
    self.mNodeSecond = nodeSecond;
end

--------------------------------
function FightTrigger:contained(point)
    return Rect.new(self.mNode:getBoundingBox()):containsPoint(cc.p(point.x, point.y))
    or Rect.new(self.mNodeSecond:getBoundingBox()):containsPoint(cc.p(point.x, point.y));
end

--------------------------------
function FightTrigger:setDateTransform(selfPos, newDir)
    local res = selfPos;
    self.mNode:setPosition(cc.p(res.x, res.y));
    self.mNodeSecond:setPosition(cc.p(res.x, res.y));
end

--------------------------------
function FightTrigger:getCollisionObjects()
	info_log("FightTrigger:getCollisionObjects ", #self.mField:getEnemyObjects());
	return self.mField:getEnemyObjects();
end

--------------------------------
function FightTrigger:setActivated(activated)
	self.mActivated = activated;
end

--------------------------------
function FightTrigger:isActivated()
	return self.mActivated;
end

--------------------------------
function FightTrigger:tick(dt)
	if self.mActivated then
		--debug_log("FightTrigger:tick");
		FightTrigger:superClass().tick(self, dt);
	end
end