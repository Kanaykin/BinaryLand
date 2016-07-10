require "src/game_objects/Trigger"

SwampGround = inheritsFrom(Trigger)

---------------------------------
function SwampGround:onEnter(player)
	info_log("SwampGround:onEnter ", FoxObject.mVelocity);
	SwampGround:superClass().onEnter(self, player);
	self:updateOrder();

	--player:setVelocity(FoxObject.mVelocity / 2.0);
end

--------------------------------
function SwampGround:updateOrder()
	debug_log("SwampGround:updateOrder ")
	local gridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
	local prevOrderPos = -gridPosition.y * 5;
	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	parent:addChild(self.mNode, prevOrderPos);
end

---------------------------------
function SwampGround:onLeave()
	info_log("SwampGround:onLeave ", FoxObject.mVelocity);
	self.mContainedObj:setVelocity(FoxObject.mVelocity);
	SwampGround:superClass().onLeave(self);
end

--------------------------------
function SwampGround:tick(dt)
	if self.mContainedObj then
		self.mContainedObj:setVelocity(FoxObject.mVelocity / 2.0);
	end
	SwampGround:superClass().tick(self, dt);
end