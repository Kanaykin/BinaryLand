require "src/game_objects/Trigger"
require "src/base/Log"

SnareTrigger = inheritsFrom(Trigger)
SnareTrigger.mTimeDestroy = nil;

--------------------------------
function SnareTrigger:init(field, node, enterCallback, leaveCallback)
	SnareTrigger:superClass().init(self, field, node, enterCallback, leaveCallback);

	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	local posGridX, posGridY = field:getGridPosition(self.mNode);
	info_log("SnareTrigger:init ", posGridY);
	parent:addChild(self.mNode, -posGridY * 2 + 1);
end

---------------------------------
function SnareTrigger:onEnter(player)
	SnareTrigger:superClass().onEnter(self, player);
	if self.mNode then
		--self.mNode:setVisible(false);
	end
end

---------------------------------
function SnareTrigger:tick(dt)
    SnareTrigger:superClass().tick(self, dt);
    if self.mTimeDestroy then
        self.mTimeDestroy = self.mTimeDestroy - dt;
        if self.mTimeDestroy <= 0 then
            self.mField:removeObject(self);
            self.mField:removeEnemy(self)
            self:destroy();
        end
    end
end

---------------------------------
function SnareTrigger:onEnterFightTrigger()
    self.mEnterCallback = nil;
    self.mTimeDestroy = 0.5;
end

