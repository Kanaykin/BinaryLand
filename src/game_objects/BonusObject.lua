require "src/game_objects/Trigger"

BonusObject = inheritsFrom(Trigger)

BonusObject.mAnimation = nil;
BonusObject.mScore = 10;
BonusObject.mType = nil;

BonusObject.COINS_TYPE = 1;
BonusObject.TIME_TYPE = 2;

--------------------------------
function BonusObject:initAnimation()
    print("HunterObject:initAnimation");

    print("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    local animation = PlistAnimation:create();

    if self.mType == BonusObject.COINS_TYPE then
        animation:init("CoinsBonus.plist", self.mNode, self.mNode:getAnchorPoint());
    elseif self.mType == BonusObject.TIME_TYPE then
        animation:init("TimeBonus.plist", self.mNode, self.mNode:getAnchorPoint());
    end

    self.mAnimation = RepeatAnimation:create();
    self.mAnimation:init(animation);
    self.mAnimation:play();
end


--------------------------------
function BonusObject:setScore(score)
    self.mScore = score;
end

--------------------------------
function BonusObject:init(field, node, score, type)
    print("BonusObject:init ")
    BonusObject:superClass().init(self, field, node, Callback.new(field, Field.onEnterBonusTrigger));

    if score ~= nil then
        self.mScore = score;
    end

    self.mType = type;
    self:initAnimation();
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);
    print("BonusObject:onEnter score ", self.mScore);

    if self.mType == BonusObject.COINS_TYPE then
        self.mField:addScore(self.mScore);
    elseif self.mType == BonusObject.TIME_TYPE then
        self.mField:addTime(self.mScore);
    end

    local pos = self:getScreenPos();
    self.mField:getMainUi():createGettingBonus(pos, self.mScore);
    self.mField:delayDelete(self);
end

