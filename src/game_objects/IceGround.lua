require "src/game_objects/Trigger"

IceGround = inheritsFrom(Trigger)

function round(n)
  return math.floor((math.floor(n*2) + 1)/2)
end

--------------------------------
function IceGround:init(field, node, enterCallback, leaveCallback)
	IceGround:superClass().init(self, field, node, enterCallback, leaveCallback);
	self:updateOrder();
end

---------------------------------
function IceGround:otherObjectInTrap(playerIn, gridPos)
    local other = nil
    local players = self.mField:getPlayerObjects();
    for i, player in pairs(players) do
        if player ~= playerIn then
            other = player;
        end
    end

	info_log("IceGround:otherObjectInTrap gridPos x ", gridPos.x);
	info_log("IceGround:otherObjectInTrap gridPos y ", gridPos.y);

	info_log("IceGround:otherObjectInTrap x ", other:getGridPosition().x);
	info_log("IceGround:otherObjectInTrap y ", other:getGridPosition().y);
    if other and other:isInTrap() and gridPos == other:getGridPosition()  then
        return true;
    end
    return false;
end

---------------------------------
function IceGround:onEnter(player)
	if player:isInTrap() then
		return;
	end
	-- info_log("IceGround:onEnter 0.94 ", round(0.94));
	-- info_log("IceGround:onEnter -0.94 ", round(-0.94));
	-- info_log("IceGround:onEnter 0.12 ", round(0.12));
	-- info_log("IceGround:onEnter -0.12 ", round(-0.12));
	info_log("IceGround:onEnter id ", player:getId());
	IceGround:superClass().onEnter(self, player);
	--self:updateOrder();
	--local delta = player.mDelta;
	info_log("IceGround:onEnter delta ", player:getLastButtonPressed());
	if player.mDelta or (player:getLastButtonPressed() and DIRECTIONS[player:getLastButtonPressed()]) then
		local newDir = player.mDelta and player.mDelta:normalized() or DIRECTIONS[player:getLastButtonPressed()]:clone() * player.mReverse;
		newDir.x = round(newDir.x);
		newDir.y = round(newDir.y);
		info_log("IceGround:onEnter delta.x ", newDir.x, " delta.y ", newDir.y);

		local gridPos = Vector.new(self.mField:getGridPosition(self.mNode));
		info_log("IceGround:onEnter gridPos.x ", gridPos.x, " gridPos.y ", gridPos.y);

		if self.mField:isFreePointForPlayer(gridPos + newDir) and not self:otherObjectInTrap(player, gridPos + newDir) then
			gridPos = gridPos + newDir
		end
		info_log("IceGround:onEnter2 gridPos.x ", gridPos.x, " gridPos.y ", gridPos.y);
		--player:playAnimation(nil);
		--player:moveTo(gridPos);
		player:enterIceGround(self.mField:gridPosToReal(gridPos));
	end
end

--------------------------------
function IceGround:updateOrder()
	debug_log("IceGround:updateOrder ")
	local gridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
	local prevOrderPos = -gridPosition.y * 5;
	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	parent:addChild(self.mNode, prevOrderPos);
end

---------------------------------
function IceGround:onLeave()
	info_log("IceGround:onLeave ");
	IceGround:superClass().onLeave(self);
end