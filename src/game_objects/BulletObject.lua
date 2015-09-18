require "src/game_objects/MobObject"

BulletObject = inheritsFrom(MobObject)

--------------------------------
function BulletObject:init(field, position)
	local node = CCSprite:create("Coin.png");
	node:setContentSize(cc.size(field:getCellSize(), field:getCellSize()));
	
	node:setPosition(position.x, position.y);

	field:getFieldNode():addChild(node);

	BulletObject:superClass().init(self, field, node);

	self.mVelocity = 400;
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
	info_log("MobObject.onPlayerEnterImpl ", player.mNode:getTag());
	BulletObject:superClass().onPlayerEnterImpl(self, player, pos);

	self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()));
end