require "src/game_objects/Trigger"

TutorialTrigger = inheritsFrom(Trigger)
TutorialTrigger.mNeedMove = nil

--------------------------------
function TutorialTrigger:init(field, node, needMove)
	TutorialTrigger:superClass().init(self, field, node);
	self.mNeedMove = needMove
end

---------------------------------
function TutorialTrigger:onEnter(player)
	TutorialTrigger:superClass().onEnter(self, player);
	if self.mContainedObj and self.mNeedMove then
		local pos = Vector.new(self.mField:getGridPosition(self.mNode));
		debug_log("TutorialTrigger:onEnter x ", pos.x, " y ", pos.y);
		player.mStateInTrap = -1
		player:moveTo(pos);
		--self.mContainedObj:enterTrap(Vector.new(self.mNode:getPosition()), PlayerObject.PLAYER_STATE.PS_WIN_STATE);
	end
end
