require "src/game_objects/Trigger"

FinishTrigger = inheritsFrom(Trigger)
FinishTrigger.mAnimation = nil;

--------------------------------
function FinishTrigger:init(field, node, enterCallback, leaveCallback)
	FinishTrigger:superClass().init(self, field, node, enterCallback, leaveCallback);
end

---------------------------------
function FinishTrigger:onStateWin()
debug_log("FinishTrigger:onStateWin ");
	FinishTrigger:superClass().onStateWin(self);
	if self.mContainedObj then

        local dest = self.mField:gridPosToReal(self.mGridPosition);
        dest.x= dest.x + self.mField.mCellSize / 2;
        dest.y= dest.y + self.mField.mCellSize / 2;

		self.mContainedObj:enterTrap(dest, PlayerObject.PLAYER_STATE.PS_WIN_STATE);
	end
end

---------------------------------
function FinishTrigger:initAnimation()
	local animation = PlistAnimation:create();
	animation:init("FinishTriggerBacklightAnim.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.15);

	local repeatAnimation = RepeatAnimation:create();
	repeatAnimation:init(animation, false);

	self.mAnimation = repeatAnimation;
	self.mAnimation:play();
end

---------------------------------
function FinishTrigger:showBacklight()
	self:initAnimation();
	self.mNode:setVisible(true);
end

---------------------------------
function FinishTrigger:hideBacklight()
	self.mNode:setVisible(false);
end
