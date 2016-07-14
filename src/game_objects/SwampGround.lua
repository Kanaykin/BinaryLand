require "src/game_objects/Trigger"

SwampGround = inheritsFrom(Trigger)

--------------------------------
function SwampGround:init(field, node, enterCallback, leaveCallback)
	SwampGround:superClass().init(self, field, node, enterCallback, leaveCallback);
	self:updateOrder();
end

---------------------------------
function SwampGround:onEnter(player)
	info_log("SwampGround:onEnter ", player:getTag());
	SwampGround:superClass().onEnter(self, player);
	--self:updateOrder();
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
	local obj = self.mContainedObj;
	if obj then
		obj:setVelocity(FoxObject.mVelocity / 2.0);
	end
	SwampGround:superClass().tick(self, dt);
end