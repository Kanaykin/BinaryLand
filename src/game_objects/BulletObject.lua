require "src/game_objects/MobObject"

BulletObject = inheritsFrom(MobObject)
BulletObject.ANCHOR_BY_DIR = {}

--------------------------------
function BulletObject:init(field, position, goalPos)
	local node = CCSprite:create("Bullet.png");
	node:setPosition(position.x, position.y);

	debug_log("BulletObject:getAnchorByDir goalPos y ", goalPos.y, " x ", goalPos.x);
	debug_log("BulletObject:getAnchorByDir  y ", field:getGridPosition(node));
	local anchor = self:getAnchorByDir((goalPos - Vector.new(field:getGridPosition(node))):normalize());

	node:setAnchorPoint(anchor);
	node:setContentSize(cc.size(field:getCellSize(), field:getCellSize()));

	field:getFieldNode():addChild(node);

	BulletObject:superClass().init(self, field, node);

	self.mVelocity = 400;
end

--------------------------------
function BulletObject:getAnchorByDir(dir)
	debug_log("BulletObject:getAnchorByDir dir y ", dir.y, " x ", dir.x);
    if dir then
        if dir.y >= 0.9 then
            return cc.p(0.2, 0.0);
        elseif dir.y <= -0.9 then
            return cc.p(0.2, 0.5);
        elseif dir.x >= 0.9 then
            return cc.p(0.2, 0.0);
        elseif dir.x <= -0.9 then
            return cc.p(0.7, 0.2);
        end
    end
    return cc.p(0.7, 0.2);
end

--------------------------------
function BulletObject:initAnimation()
end

--------------------------------
function BulletObject:onMoveFinished()
	BulletObject:superClass().onMoveFinished(self);
	self.mField:delayDelete(self);
end

--------------------------------
function BulletObject:onPlayerEnterImpl(player, pos)
	info_log("BulletObject.onPlayerEnterImpl ", player.mNode:getTag());
	BulletObject:superClass().onPlayerEnterImpl(self, player, pos);

	if not player:isInTrap() then
		self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()));
		self.mField:delayDelete(self);
	end
end