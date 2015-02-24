require "src/game_objects/Trigger"

BonusObject = inheritsFrom(Trigger)

BonusObject.mAnimation = nil;
BonusObject.mScore = 10;

--------------------------------
function BonusObject:initAnimation()
    print("HunterObject:initAnimation");

    print("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    local animation = PlistAnimation:create();
    animation:init("CoinsBonus.plist", self.mNode, self.mNode:getAnchorPoint());

    self.mAnimation = RepeatAnimation:create();
    self.mAnimation:init(animation);
    self.mAnimation:play();
end


--------------------------------
function BonusObject:setScore(score)
    self.mScore = score;
end

--------------------------------
function BonusObject:init(field, node, score)
    print("BonusObject:init ")
    BonusObject:superClass().init(self, field, node, Callback.new(field, Field.onEnterBonusTrigger));

    if score ~= nil then
        self.mScore = score;
    end
    self:initAnimation();
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);
    print("BonusObject:onEnter score ", self.mScore);
    self.mField:addScore(self.mScore);
    local pos = self:getScreenPos();
    self.mField:getMainUi():createGettingBonus(pos, self.mScore);
    self.mField:delayDelete(self);
end

