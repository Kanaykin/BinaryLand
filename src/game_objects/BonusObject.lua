require "src/game_objects/Trigger"
require "src/base/Log"
require "src/base/List"

BonusObject = inheritsFrom(Trigger)

BonusObject.mAnimation = nil;
BonusObject.mAnimationWait = nil;

BonusObject.mListOpenAnimation = nil;

BonusObject.mScore = 10;
BonusObject.mType = nil;
BonusObject.mTimeLabel = nil;
BonusObject.mOpened = nil;

BonusObject.COINS_TYPE = 1;
BonusObject.TIME_TYPE = 2;
BonusObject.CHEST_TYPE = 3;

BonusObject.MAIN_TIME_NODE_TAG = 1;
BonusObject.ANIM_TIME_NODE_TAG = 2;
BonusObject.ANIM_LABEL_NODE_TAG = 3;
BonusObject.BASE_NODE_TAG = 5;
BonusObject.FAKE_NODE_TAG = 99;

BonusObject.CHEST_COINS_TYPE = 0;
BonusObject.CHEST_TIME_TYPE = 1;

BonusObject.mChestType = BonusObject.CHEST_COINS_TYPE;

--------------------------------
function BonusObject:initTimeBonus(animation)
    --animation:init("TimeBonus.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.1);
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("TimeBonus", reader, false);
    self.mNode:addChild(node);
    --self.mNode:setAnchorPoint(cc.p(0, 0));
    local fakeNode = self.mNode:getChildByTag(BonusObject.FAKE_NODE_TAG);
    debug_log("BonusObject:initTimeBonus fakeNode ", fakeNode);
    if fakeNode then
        fakeNode:setVisible(false);
    end

    node = node:getChildByTag(BonusObject.BASE_NODE_TAG);
    --self.mNode:ignoreAnchorPointForPosition(true);

    local mainNode = node:getChildByTag(BonusObject.MAIN_TIME_NODE_TAG);
    debug_log("BonusObject:initAnimation mainNode ", mainNode);
    if mainNode then
        animation:init("TimeBonus.plist", mainNode, mainNode:getAnchorPoint(), nil, 0.1);
        --self.mSize = mainNode:getBoundingBox();

        local tmpBox = self:getBoundingBox();
        debug_log("BonusObject:initAnimation tmpBox ", tmpBox.x, " ", tmpBox.y, " ", tmpBox.width, " ", tmpBox.height);
    end
    local animNode = node:getChildByTag(BonusObject.ANIM_TIME_NODE_TAG);
    if animNode then
        local animator = reader:getActionManager();

        function callback()
            debug_log("BonusObject:initAnimation finish ");
            animator:runAnimationsForSequenceNamed("LoopAnimation");
        end

        local callFunc = CCCallFunc:create(callback);
        animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");
        animator:runAnimationsForSequenceNamed("LoopAnimation");

        local label = tolua.cast(animNode:getChildByTag(BonusObject.ANIM_LABEL_NODE_TAG), "cc.Label");
        debug_log("BonusObject:initAnimation label ", label);

        if label then
            setDefaultFont(label, self:getField():getGame():getScale());
            self.mTimeLabel = label;
            self.mTimeLabel:setString(tostring(self.mScore));
        end
    end

end

--------------------------------
function BonusObject:initAnimation()
    info_log("BonusObject:initAnimation");

    --info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    local animation = PlistAnimation:create();

    if self.mType == BonusObject.COINS_TYPE then
        animation:init("CoinsBonus.plist", self.mNode, self.mNode:getAnchorPoint());
    elseif self.mType == BonusObject.TIME_TYPE then
        self:initTimeBonus(animation);
    elseif self.mType == BonusObject.CHEST_TYPE then
        debug_log("BonusObject:initAnimation id ", self:getId());
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
    if self.mTimeLabel then
        self.mTimeLabel:setString(tostring(score));
    end
end

---------------------------------
function BonusObject:setCustomProperties(properties)
    info_log("BonusObject:setCustomProperties ");

    BonusObject:superClass().setCustomProperties(self, properties);

    if properties.Count then
        info_log("BonusObject:setCustomProperties Count ", properties.Count);
        self:setScore(properties.Count);
    end

	if properties.Type then
        info_log("BonusObject:setCustomProperties Type ", properties.Type);
        self.mType = properties.Type;
		self:initAnimation();
    end

    if properties.ChestType then
        info_log("BonusObject:setCustomProperties chestBonusType ", properties.ChestType);
        self.mChestType = properties.ChestType;
    end
    if self.mType == BonusObject.CHEST_TYPE and self.mChestType == BonusObject.CHEST_COINS_TYPE then
        self.mField:incCoinsObjects();
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
    debug_log("BonusObject:createBonusSprite ", self.mChestType)
    local texture = cc.Director:getInstance():getTextureCache():addImage(
        self.mChestType == BonusObject.CHEST_COINS_TYPE and "Coin.png" or "TimeEmpty.png");
    local sprite = cc.Sprite:createWithTexture(texture);
    sprite:setAnchorPoint(self.mChestType == BonusObject.CHEST_COINS_TYPE and { x = -0.25, y = -0.5}
        or { x = -0.5, y = -0.3});
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
function BonusObject:store(data)
    BonusObject:superClass().store(self, data);
    return not self.mOpened
end

---------------------------------
function BonusObject:onEnter(player)
    BonusObject:superClass().onEnter(self, player);
    info_log("BonusObject:onEnter type ", self.mType);

    self.mListOpenAnimation = List.new();
    if self.mType == BonusObject.COINS_TYPE or ( self.mType == BonusObject.CHEST_TYPE and self.mChestType == BonusObject.CHEST_COINS_TYPE) then
        self.mField:addScore(self.mScore);
    elseif self.mType == BonusObject.TIME_TYPE or ( self.mType == BonusObject.CHEST_TYPE and self.mChestType == BonusObject.CHEST_TIME_TYPE)  then
        self.mField:addTime(self.mScore);
    end

    if self.mType == BonusObject.CHEST_TYPE then
        self:createOpenAnimation();
    end
    self.mOpened = true

end

