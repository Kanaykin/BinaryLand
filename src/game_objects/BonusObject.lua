require "src/game_objects/Trigger"
require "src/base/Log"
require "src/base/List"

BonusObject = inheritsFrom(Trigger)

BonusObject.mAnimation = nil;
BonusObject.mAnimationWait = nil;

BonusObject.mListOpenAnimation = nil;

BonusObject.mScore = 10;
BonusObject.mType = nil;

BonusObject.COINS_TYPE = 1;
BonusObject.TIME_TYPE = 2;
BonusObject.CHEST_COINS_TYPE = 3;
BonusObject.CHEST_TIME_TYPE = 4;

--------------------------------
function BonusObject:initAnimation()
    info_log("BonusObject:initAnimation");

    info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    local animation = PlistAnimation:create();

    if self.mType == BonusObject.COINS_TYPE then
        animation:init("CoinsBonus.plist", self.mNode, self.mNode:getAnchorPoint());
    elseif self.mType == BonusObject.TIME_TYPE then
        animation:init("TimeBonus.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.1);
    elseif self.mType == BonusObject.CHEST_COINS_TYPE then
        animation:init("ChestBonus.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.2);
        --self:createChestOpenAnimation();
    end

    self.mAnimation = RepeatAnimation:create();
    self.mAnimation:init(animation);
    self.mAnimation:play();
end

--------------------------------
function BonusObject:updateOpenAnimation(dt)
    if not self.mListOpenAnimation then
        return
    end

    if List.isEmpty(self.mListOpenAnimation) then
        local pos = self:getScreenPos();
        self.mField:getMainUi():createGettingBonus(pos, self.mScore);
        self.mField:delayDelete(self);
        return;
    end

    if not self.mListOpenAnimation[self.mListOpenAnimation.first]:tick(dt) then
        List.popleft(self.mListOpenAnimation);
    end
end

--------------------------------
function BonusObject:tick(dt)
    BonusObject:superClass().tick(self, dt);
    self.mAnimation:tick(dt)

    self:updateOpenAnimation(dt);
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

	if properties.Type then
        info_log("BonusObject:setCustomProperties Type ", properties.Type);
        self.mType = properties.Type;
		self:initAnimation();
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

    if self.mAnimation then
        self.mAnimation:destroy();
    end

    --[[if self.mOpenAnimation then
        self.mOpenAnimation:destroy();
    end]]
end

--------------------------------
function BonusObject:createChestOpenAnimation()
    local animation = PlistAnimation:create();
    self.mAnimationWait = animation;

    animation:init("ChestBonusOpen.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.1);

    return animation;
end

--------------------------------
function BonusObject:createChestOpenedAnimation()
    local textureName = "ChestOpened.png"
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);

    local empty = EmptyAnimation:create();
    empty:init(texture, self.mNode, { x = 0.5, y = -0.08});

    return empty;
end


--------------------------------
function BonusObject:createBonusSprite()
    --self.mBonusShowed = true;
    local texture = cc.Director:getInstance():getTextureCache():addImage("Coin.png");
    local sprite = cc.Sprite:createWithTexture(texture);
    sprite:setAnchorPoint({ x = -0.25, y = -0.5});
    --sprite:setOpacity(100);
    sprite:setVisible(false);
    self.mNode:addChild(sprite);
    return sprite;
end

---------------------------------
function BonusObject:createOpenAnimation()
    local anim = self:createChestOpenAnimation();

    local stopAnimation = {};
    stopAnimation.mObj = self;
    stopAnimation.mAnim = anim;
    stopAnimation.tick = function(self, dt)
        self.mObj.mNode:stopAllActions();
        self.mAnim:play();
        return false;
    end
    List.pushright(self.mListOpenAnimation, stopAnimation);

    local playAnimation = {}
    playAnimation.mAnim = anim;
    playAnimation.mOpenedAnim = self:createChestOpenedAnimation();
    playAnimation.tick = function(self, dt)
        self.mAnim:tick(dt);
        if self.mAnim:isDone() then
            self.mOpenedAnim:play();
            self.mAnim:destroy();
            return false
        end
        return true;
    end
    List.pushright(self.mListOpenAnimation, playAnimation);

    local bonusImage = self:createBonusSprite();
    local showBonus = {}
    showBonus.mImage = bonusImage;
    showBonus.tick = function(self, dt)
        self.mImage:setVisible(true);
        self.mImage:setOpacity(0);
        return false;
    end
    List.pushright(self.mListOpenAnimation, showBonus);

    local opacityBonus = {}
    opacityBonus.mImage = bonusImage;
    opacityBonus.mVelocity = 255 / 0.25;
    opacityBonus.mOpacity = 0
    opacityBonus.tick = function(self, dt)
        self.mOpacity = self.mOpacity + dt * self.mVelocity;
        self.mImage:setOpacity(math.min(self.mOpacity, 255));
        return self.mOpacity < 255;
    end
    List.pushright(self.mListOpenAnimation, opacityBonus);
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);
    info_log("BonusObject:onEnter score ", self.mScore);

    self.mListOpenAnimation = List.new();
    if self.mType == BonusObject.COINS_TYPE then
        self.mField:addScore(self.mScore);
    elseif self.mType == BonusObject.TIME_TYPE then
        self.mField:addTime(self.mScore);
    elseif self.mType == BonusObject.CHEST_COINS_TYPE then
        self.mField:addScore(self.mScore);
        self:createOpenAnimation();
    end

end

