require "src/game_objects/PlayerObject"
require "src/game_objects/FoxHelpEffect"
require "src/animations/PlistAnimation"
require "src/animations/RandomAnimation"
require "src/animations/DelayAnimation"
require "src/scenes/SoundConfigs"
require "src/base/Log"

FoxObject = inheritsFrom(PlayerObject)

FoxObject.mVelocity = 60;
FoxObject.mAnimationNode = nil;
FoxObject.mEffectNode = nil;

FoxObject.mNewEffect = nil;
FoxObject.mFirstUpdate = 0;

FoxObject.mEffectAnimations = nil;
FoxObject.mFightPlistAnimations = nil;

FoxObject.OBJECT_NODE_TAG = 5;
FoxObject.EFFECT_NODE_TAG = 6;

FoxObject.mFrontIdleAnimation = nil;
FoxObject.mBackIdleAnimation = nil;
FoxObject.mSideIdleAnimation = nil;
FoxObject.mDebugBox = nil;
FoxObject.mNeedDebugBox = false;
FoxObject.mSize = nil;

--------------------------------
function FoxObject:init(field, node, needReverse)
	self.mAnimationNode  = node:getChildByTag(FoxObject.OBJECT_NODE_TAG);
	self.mEffectNode = node:getChildByTag(FoxObject.EFFECT_NODE_TAG);
	self.mEffectNode:setVisible(true);

    self.mNewEffect = FoxHelpEffect:create();
    self.mNewEffect:init(node, field.mGame);
    self.mNewEffect:setVisible(false);

	info_log("FoxObject:init node_obj ", self.mAnimationNode);
	
	FoxObject:superClass().init(self, field, node, needReverse);

    self.mLastDir = 2;
        if not self.mIsFemale then
        tolua.cast(self.mAnimationNode, "cc.Sprite"):setFlippedX(true);
    end
    self:updateAnchorFightAnimation();

	self.mVelocity = self.mVelocity * field.mGame:getScale();

    if self.mNeedDebugBox then
        local nodeBox = cc.DrawNode:create();
        self.mAnimationNode:addChild(nodeBox);
        self.mDebugBox = nodeBox;
    end
    self.mSize = self.mAnimationNode:getBoundingBox();
end

---------------------------------
function FoxObject:setCustomProperties(properties)
    info_log("FoxObject:setCustomProperties properties.state ", properties.state);

    FoxObject:superClass().setCustomProperties(self, properties);

    if properties.state then
        self:playAnimation(properties.state);
        self.mAnimations[self.mLastButtonPressed]:setCurrentAnimation(2);
        self.mInTrap = true;
        self.mField:createSnareTrigger(Vector.new(self.mNode:getPosition()));
    end
end

--------------------------------
function FoxObject:updateDebugBox()
    if self.mDebugBox then
        local box = self:getBoundingBox();
        local size = self.mAnimationNode:getBoundingBox();
        local anchor = self.mAnimationNode:getAnchorPoint();
        box.x = 0;
        box.y = 0;
        self.mDebugBox:clear();
        local center = cc.p(box.x + anchor.x * size.width , box.y + anchor.y * size.height);
        self.mDebugBox:drawCircle(center, box.width / 2.0 * 0.7,
            360, 360, false, {r = 0, g = 0, b = 0, a = 100});

        if self.mFightTrigger:isActivated() then
            self.mFightTrigger:drawDebug(self.mDebugBox, center);
        end

        --[[self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x + box.width, box.y), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x, box.y + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x + box.width, box.y), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y + box.height), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});]]
    end
end

--------------------------------
function FoxObject:move(dt)
	FoxObject:superClass().move(self, dt);
end

---------------------------------
function FoxObject:getBoundingBox()
	local pos = FoxObject:superClass().getBoundingBox(self);
	local size = self.mSize;
	return cc.rect(pos.x, pos.y, size.width, size.width);
end

--------------------------------
function FoxObject:setFightActivated(activated)
	info_log("FoxObject:setFightActivated ", activated);
	FoxObject:superClass().setFightActivated(self, activated);
	self.mEffectNode:setVisible(activated);

	local flip = self:updateFlipNode(self.mEffectNode);

	if flip then
		local anchor = self.mEffectNode:getPositionX();
		info_log("FoxObject:setFightActivated getPositionX ", anchor);
		self.mEffectNode:setPositionX(-anchor);
	end

	if activated then
		--self.mEffectAnimations[1]:play();
		--self.mEffectAnimations[1]:setStopAfterDone(false);
		SimpleAudioEngine:getInstance():playEffect(gSounds.PLAYER_ATTACK_SOUND)
	else
		--self.mEffectNode:stopAllActions();
		--self.mEffectAnimations[1]:stop();
	end
end

--------------------------------
function FoxObject:weakfight()
	local result = FoxObject:superClass().weakfight(self);
	self.mEffectAnimations[1]:setStopAfterDone(true);
	return result;
end

--------------------------------
function FoxObject:fight()
	local result = FoxObject:superClass().fight(self);
	--self.mEffectAnimations[1]:play();
	if self.mEffectAnimations[1] then
		self.mEffectAnimations[1]:setStopAfterDone(false);
	end
	return result;
end

--------------------------------
function FoxObject:updateFlipNode(node)
	local flip = false;
	if node and self.mLastDir == Joystick.BUTTONS.RIGHT or self.mLastDir ==  Joystick.BUTTONS.LEFT then
		flip = self.mLastDir == Joystick.BUTTONS.RIGHT;
		if self.mIsFemale then
			flip = not flip;
		end
		--flip = (self.mIsFemale) and (not flip) or flip;
        local sprite = tolua.cast(node, "cc.Sprite");
        if flip ~= sprite:isFlippedX() then
            sprite:setFlippedX(flip);
            info_log("FoxObject:updateFlipNode");
            self:updateAnchorFightAnimation();
        end
	end
	return flip; 
end

--------------------------------
function FoxObject:tick(dt)
	FoxObject:superClass().tick(self, dt);
    if self.mFirstUpdate <= 2 then
        self.mFirstUpdate = self.mFirstUpdate + 1;
        self:updateOrder();
    end

	self:updateFlipNode(self.mAnimationNode);

	self.mEffectAnimations[1]:tick();

    local currAnim = self:getCurrentAnimation();
    local curr = currAnim:currentAnimation();

    if self.mNewEffect:getDependAnimation() == curr then
        self.mNewEffect:setVisible(true);
    else
        self.mNewEffect:setVisible(false);
    end
    self:updateDebugBox();
end

--------------------------------
function FoxObject:createRepeatAnimation(node, nameAnimation, soft, delayPerUnit, anchor, texture)
	local animation = PlistAnimation:create();
	animation:init(nameAnimation, node, anchor and anchor or node:getAnchorPoint(), texture, delayPerUnit);

	local repeatAnimation = RepeatAnimation:create();
	repeatAnimation:init(animation, soft);
	return repeatAnimation;
end

--------------------------------
function FoxObject:createFightRepeatAnimation(node, nameAnimation, soft, delayPerUnit, anchor, texture)
    local animation = PlistAnimation:create();
    animation:init(nameAnimation, node, anchor and anchor or node:getAnchorPoint(), texture, delayPerUnit);

    self.mFightPlistAnimations[#self.mFightPlistAnimations + 1] = animation;

    local repeatAnimation = RepeatAnimation:create();
    repeatAnimation:init(animation, soft);
    return repeatAnimation;
end

--------------------------------
function FoxObject:getAnimationNode()
	return self.mAnimationNode;
end

--------------------------------
function FoxObject:createIdleAnimation(animation, nameAnimation, texture, textureSize, textureName, delayPerUnit)
	local idle = PlistAnimation:create();
	idle:init(nameAnimation, self.mAnimationNode, self.mAnimationNode:getAnchorPoint(), nil, delayPerUnit);
	local delayAnim = DelayAnimation:create();
	delayAnim:init(idle, math.random(0, 2), texture, textureSize, textureName);
	animation:addAnimation(delayAnim);
end

--------------------------------
function FoxObject:initEffectAnimations()
	self.mEffectAnimations = {};
	self.mEffectAnimations[1] = self:createRepeatAnimation(self.mEffectNode, "WaveHor.plist", true);
end

--------------------------------
function FoxObject:playAnimation(button)
	if button == PlayerObject.PLAYER_STATE.PS_TOP then
		self.mAnimations[-1] = self.mBackIdleAnimation;
	elseif button == PlayerObject.PLAYER_STATE.PS_LEFT or 
		button == PlayerObject.PLAYER_STATE.PS_RIGHT then
		self.mAnimations[-1] = self.mSideIdleAnimation;
    elseif button == PlayerObject.PLAYER_STATE.PS_BOTTOM then
        self.mAnimations[-1] = self.mFrontIdleAnimation;
	end
	FoxObject:superClass().playAnimation(self, button);
end

--------------------------------
function FoxObject:getPrefixTexture()
	if self.mIsFemale then
		return "FoxGirl";
	else
		return "Fox";
	end
end

--------------------------------
function FoxObject:createSideIdleAnimation()
    --local texture = tolua.cast(self.mAnimationNode, "cc.Sprite"):getTexture();
    local textureName = self:getPrefixTexture() .. ".png";
    info_log("FoxObject:initAnimation textureName ", textureName);
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    if texture then
        local contentSize = texture:getContentSize() -- {width = texture:getPixelsWide(), height = texture:getPixelsHigh()}

        self.mAnimations[-1] = RandomAnimation:create();
        self.mAnimations[-1]:init();
        self:createIdleAnimation(self.mAnimations[-1], self:getPrefixTexture().."Idle1.plist", texture, contentSize, textureName);
        self:createIdleAnimation(self.mAnimations[-1], self:getPrefixTexture().."Idle2.plist", texture, contentSize, textureName);

        self.mSideIdleAnimation = self.mAnimations[-1];
    end
end

--------------------------------
function FoxObject:createBackIdleAnimation()
    self.mAnimations[-2] = RandomAnimation:create();
    self.mAnimations[-2]:init();
    local textureName = self:getPrefixTexture() .. "Back.png";
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    if texture then
        local contentSize = texture:getContentSize() -- {width = texture:getPixelsWide(), height = texture:getPixelsHigh()}
        self:createIdleAnimation(self.mAnimations[-2], self:getPrefixTexture().."BackIdle1.plist", texture, contentSize, textureName, 0.3);

        self.mBackIdleAnimation = self.mAnimations[-2];
    end
end

--------------------------------
function FoxObject:createFrontIdleAnimation()
    self.mFrontIdleAnimation = RandomAnimation:create();
    self.mFrontIdleAnimation:init();
    local textureName = self:getPrefixTexture() .. "Front.png";
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    local contentSize = texture:getContentSize() -- {width = texture:getPixelsWide(), height = texture:getPixelsHigh()}
    self:createIdleAnimation(self.mFrontIdleAnimation, self:getPrefixTexture().."FrontIdle1.plist", texture, contentSize, textureName);

self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE] = self.mFrontIdleAnimation;
end

--------------------------------
function FoxObject:getAnchorFightAnimation()
    local sprite = tolua.cast(self.mAnimationNode, "cc.Sprite");
    info_log("FoxObject isFlippedX() ", sprite:isFlippedX());
    local mult = sprite:isFlippedX() and 1 or -1;

    if self.mIsFemale then
        return { x = 0.5 + 0.195 / 2 * mult, y = 0.35 + 0.04 / 2}, sprite:isFlippedX();
    else
        return { x = 0.5 + 0.34 / 2 * mult, y = 0.35 + 0.065 / 2}, sprite:isFlippedX();
    end
end

--------------------------------
function FoxObject:updateAnchorFightAnimation()
    local anchor, flipped = self:getAnchorFightAnimation();
	for i, animation in ipairs(self.mFightPlistAnimations) do
        animation:setAnchor(anchor);
    end

    self.mNewEffect:updateFlip(flipped);
end

--------------------------------
function FoxObject:createFightAnimation()
    local textureName = self:getPrefixTexture() .. "FightStatic.png"
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    local contentSize = texture:getContentSize();
    info_log("FoxObject:createFightAnimation width ", contentSize.width, " height ", contentSize.height);

    local anchor = self.mAnimationNode:getAnchorPoint();
    info_log("FoxObject:createFightAnimation anchor x ", anchor.x, "anchor.y ", anchor.y);
    local originSize = self.mAnimationNode:getContentSize();
    info_log("FoxObject:createFightAnimation originSize width ", originSize.width, " height ", originSize.height);

    local newAnchorX = (originSize.width * anchor.x) / contentSize.width;
    info_log("FoxObject newAnchorX ", newAnchorX);

    local newAnchorY = (originSize.height * anchor.y) / contentSize.height;
    info_log("FoxObject newAnchorY ", newAnchorY);

    self.mFightPlistAnimations = {};

    for i = PlayerObject.PLAYER_STATE.PS_FIGHT_LEFT, PlayerObject.PLAYER_STATE.PS_FIGHT_DOWN do
        info_log("FIGHT anchor x ", self.mAnimationNode:getAnchorPoint().x, ", y ", self.mAnimationNode:getAnchorPoint().y)
        self.mAnimations[i] = self:createFightRepeatAnimation(self.mAnimationNode, self:getPrefixTexture() .. "Fight.plist", true, 0.06, self:getAnchorFightAnimation(), texture);
    end
end

--------------------------------
function FoxObject:getInTrapAnchor(anchorOrigin)
    if self.mIsFemale then
        return anchorOrigin;
    else
        return { x = anchorOrigin.x, y = anchorOrigin.y + 0.05};
    end
end

--------------------------------
function FoxObject:createInTrapAnimation()
    local sequence = SequenceAnimation:create();
    sequence:init();

    local anchor = self:getInTrapAnchor(self.mAnimationNode:getAnchorPoint());

    local animation = PlistAnimation:create();

    local textureName = self:getPrefixTexture().."InTrapFirst.png"
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);

    animation:init(self:getPrefixTexture().."InTrap.plist", self.mAnimationNode, anchor, texture, 0.2);

    sequence:addAnimation(animation);

    local textureEmptyName = self:getPrefixTexture().."InTrapStatic.png"
    local textureEmpty = cc.Director:getInstance():getTextureCache():addImage(textureEmptyName);

    local empty = EmptyAnimation:create();
    empty:init(textureEmpty, self.mAnimationNode, anchor)

    sequence:addAnimation(empty);
    self.mNewEffect:setDependAnimation(empty);

    self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = sequence;
end

--------------------------------
function FoxObject:initAnimation()
	self.mAnimations = {}

    self:createSideIdleAnimation();
    self:createBackIdleAnimation();
    self:createFrontIdleAnimation();
	
	-- create empty animation
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
            self.mAnimations[i] = self:createRepeatAnimation(self.mAnimationNode, self:getPrefixTexture().."Walk.plist", nil, 1 / 4);
		end
	end

	self.mAnimations[PlayerObject.PLAYER_STATE.PS_TOP] = self:createRepeatAnimation(self.mAnimationNode, self:getPrefixTexture().."WalkBack.plist", nil, 1 / 4);

    self.mAnimations[PlayerObject.PLAYER_STATE.PS_BOTTOM] = self:createRepeatAnimation(self.mAnimationNode, self:getPrefixTexture().."WalkFront.plist", nil, 1 / 4);

    self:createFightAnimation();

    self:createInTrapAnimation();

	--self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE] = EmptyAnimation:create();
	--local frontTexture = tolua.cast(self.mAnimationNode, "cc.Sprite"):getTexture();
	--self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE]:init(frontTexture, self.mAnimationNode, contentSize);

	self:initEffectAnimations();

	self.mAnimations[-1]:play();
end
