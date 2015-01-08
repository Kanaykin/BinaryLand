require "src/game_objects/Trigger"

BonusObject = inheritsFrom(Trigger)

--------------------------------
function BonusObject:init(field, node)
    print("BonusObject:init ")
    BonusObject:superClass().init(self, field, node, Callback.new(field, Field.onEnterBonusTrigger));
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);

    self.mField:removeObject(self);
    self:destroy();
end

