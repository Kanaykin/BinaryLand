require "src/game_objects/Trigger"

LavaGround = inheritsFrom(Trigger)

--------------------------------
function LavaGround:init(field, node, enterCallback, leaveCallback)
	LavaGround:superClass().init(self, field, node, enterCallback, leaveCallback);
	self:updateOrder();
	self.mNode:setVisible(false);
end

---------------------------------
function LavaGround:onEnter(player)
	info_log("LavaGround:onEnter ", player:getTag());
	LavaGround:superClass().onEnter(self, player);
	self:getField():getGame():getSoundManager():playEffect(gSounds.ENTER_LAVA_SOUND);
	--self:updateOrder();
	local players = self.mField:getPlayerObjects();
    for i, p in pairs(players) do
    	if not p:isInTrap() then
    		p:resetMovingParams();
    	end
    end
    player:enterLavaGround();
    self.mField:onStateLose();
end

--------------------------------
function LavaGround:updateOrder()
	debug_log("LavaGround:updateOrder ")
	local gridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
	local prevOrderPos = -gridPosition.y * 5;
	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	parent:addChild(self.mNode, prevOrderPos);
end

---------------------------------
function LavaGround:onLeave()
	info_log("LavaGround:onLeave ", FoxObject.mVelocity);

	LavaGround:superClass().onLeave(self);
end

--------------------------------
function LavaGround:tick(dt)
	LavaGround:superClass().tick(self, dt);
end
