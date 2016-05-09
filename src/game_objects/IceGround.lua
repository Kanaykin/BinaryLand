require "src/game_objects/Trigger"

IceGround = inheritsFrom(Trigger)

---------------------------------
function IceGround:onEnter(player)
	info_log("IceGround:onEnter ");
	IceGround:superClass().onEnter(self, player);
	--local delta = player.mDelta;
	info_log("IceGround:onEnter delta ", player:getLastButtonPressed());
	if player.mDelta or (player:getLastButtonPressed() and DIRECTIONS[player:getLastButtonPressed()]) then
		local newDir = player.mDelta and player.mDelta:normalized() or DIRECTIONS[player:getLastButtonPressed()]:clone() * player.mReverse;
		info_log("IceGround:onEnter delta.x ", newDir.x, " delta.y ", newDir.y);

		local gridPos = Vector.new(self.mField:getGridPosition(self.mNode));
		info_log("IceGround:onEnter gridPos.x ", gridPos.x, " gridPos.y ", gridPos.y);

		if self.mField:isFreePointForPlayer(gridPos + newDir) then
			gridPos = gridPos + newDir
		end
		info_log("IceGround:onEnter2 gridPos.x ", gridPos.x, " gridPos.y ", gridPos.y);
		--player:playAnimation(nil);
		--player:moveTo(gridPos);
		player:enterTrap(self.mField:gridPosToReal(gridPos));
		player.mMoveFinishCallback = nil
	end
end

---------------------------------
function IceGround:onLeave()
	info_log("IceGround:onLeave ");
	IceGround:superClass().onLeave(self);
end