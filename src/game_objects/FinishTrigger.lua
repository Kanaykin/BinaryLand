require "src/game_objects/Trigger"

FinishTrigger = inheritsFrom(Trigger)

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


