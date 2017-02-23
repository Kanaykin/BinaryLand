require "src/game_objects/MobObject"

FireTornadoObject = inheritsFrom(TornadoObject)

--------------------------------
function FireTornadoObject:onPlayerEnterImpl(player, pos)
	info_log("FireTornadoObject.onPlayerEnterImpl ", player:getId(), " ", self.mPlayerContained);
	FireTornadoObject:superClass().onPlayerEnterImpl(self, player, pos);

	local players = self.mField:getPlayerObjects();
    for i, p in pairs(players) do
    	if not p:isInTrap() then
    		p:resetMovingParams();
    	end
    end
    if self.mField:getState() == Field.IN_GAME then
    	self.mField:onStateLose();
    end
end