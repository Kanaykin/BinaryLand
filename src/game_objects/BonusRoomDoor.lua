require "src/game_objects/Trigger"
require "src/base/Log"

BonusRoomDoor = inheritsFrom(Trigger)
BonusRoomDoor.mVisited = nil;

---------------------------------
function BonusRoomDoor:onEnter(player)
    info_log("BonusRoomDoor:onEnter self.mVisited ", self.mVisited);
    if not self.mVisited then
        self.mVisited = true;
        BonusRoomDoor:superClass().onEnter(self, player);
    end
end

---------------------------------
function BonusRoomDoor:store(data)
    info_log("BonusRoomDoor:store self.mVisited ", self.mVisited);
    BonusRoomDoor:superClass().store(self, data);
    data.visited = self.mVisited;
end

---------------------------------
function BonusRoomDoor:restore(data)
    info_log("BonusRoomDoor:restore data.visited", data.visited);
    BonusRoomDoor:superClass().restore(self, data);
    self.mVisited = data.visited;
    if self.mVisited then
        self.mField:removeBonusRoomDoor(self);
    end
end
