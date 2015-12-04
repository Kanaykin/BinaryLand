require "src/game_objects/Trigger"
require "src/base/Log"

BonusObject = inheritsFrom(Trigger)

BonusObject.mAnimation = nil;
BonusObject.mScore = 10;
BonusObject.mType = nil;

BonusObject.COINS_TYPE = 1;
BonusObject.TIME_TYPE = 2;

--------------------------------
function BonusObject:initAnimation()
    info_log("HunterObject:initAnimation");

    info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    local animation = PlistAnimation:create();

    if self.mType == BonusObject.COINS_TYPE then
        animation:init("CoinsBonus.plist", self.mNode, self.mNode:getAnchorPoint());
    elseif self.mType == BonusObject.TIME_TYPE then
        animation:init("TimeBonus.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.2);
    end

    self.mAnimation = RepeatAnimation:create();
    self.mAnimation:init(animation);
    self.mAnimation:play();
end

---------------------------------
function BonusObject:getBoundingBox()
    local rect = self.mNode:getBoundingBox();
    if self.mType == BonusObject.TIME_TYPE then
        rect.height = rect.height * 0.5;
    end
    return rect;
end

--------------------------------
function BonusObject:setScore(score)
    self.mScore = score;
end

---------------------------------
function BonusObject:setCustomProperties(properties)
    info_log("BonusObject:setCustomProperties ");

    BonusObject:superClass().setCustomProperties(self, properties);

    if properties.Count then
        info_log("BonusObject:setCustomProperties Count ", properties.Count);
        self.mScore = properties.Count;
    end
end

--------------------------------
function BonusObject:init(field, node, score, type)
    info_log("BonusObject:init ")
    BonusObject:superClass().init(self, field, node, Callback.new(field, Field.onEnterBonusTrigger));

    if score ~= nil then
        self.mScore = score;
    end

    self.mType = type;
    self:initAnimation();
end

---------------------------------
function BonusObject:destroy()
    info_log("BonusObject:destroy ");

    BonusObject:superClass().destroy(self);

    self.mAnimation:destroy();
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);
    info_log("BonusObject:onEnter score ", self.mScore);

    if self.mType == BonusObject.COINS_TYPE then
        self.mField:addScore(self.mScore);
    elseif self.mType == BonusObject.TIME_TYPE then
        self.mField:addTime(self.mScore);
    end

    local pos = self:getScreenPos();
    self.mField:getMainUi():createGettingBonus(pos, self.mScore);
    self.mField:delayDelete(self);
end

