require "src/game_objects/PlayerObject"
require "src/game_objects/FoxHelpEffect"
require "src/animations/PlistAnimation"
require "src/animations/RandomAnimation"
require "src/animations/DelayAnimation"
require "src/animations/AnimationDoneCallback"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/base/Interpolator"
require "src/game_objects/FoxTrace.lua"

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
FoxObject.mCageAnimations = nil;
FoxObject.mTypeCage = nil;

FoxObject.mDebugBox = nil;
FoxObject.mNeedDebugBox = false;
FoxObject.mSize = nil;
FoxObject.mTrace = nil;

FoxObject.mAnchorInterpolation = nil;
FoxObject.mCallbackOnDone = nil;

FoxObject.FOX_STATE = {
    PS_IN_CAGE_LEFT = PlayerObject.PLAYER_STATE.PS_LAST + 1,
    PS_IN_CAGE_RIGHT = PlayerObject.PLAYER_STATE.PS_LAST + 2,
    PS_IN_HIDDEN_CAGE = PlayerObject.PLAYER_STATE.PS_LAST + 3
};

FoxObject.CAGE_TYPE = {
    CT_CAGE = 1,
    CT_HIDDEN = 2
}

--------------------------------
function FoxObject:init(field, node, needReverse)
	self.mAnimationNode  = node:getChildByTag(FoxObject.OBJECT_NODE_TAG);
	self.mEffectNode = node:getChildByTag(FoxObject.EFFECT_NODE_TAG);
	self.mEffectNode:setVisible(true);

    self.mNewEffect = FoxHelpEffect:create();
    self.mNewEffect:init(node, field.mGame);
    self.mNewEffect:setVisible(false);

	info_log("FoxObject:init node_obj ", self.mAnimationNode:getAnchorPoint().y);
	
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

    -- create trace
    self.mTrace = FoxTrace:create();
    self.mTrace:init(field:getSize());
end

---------------------------------
function FoxObject:getTrace()
    return self.mTrace;
end

---------------------------------
function FoxObject:restore(data)
    debug_log("FoxObject:restore mInTrap ", self.mInTrap, " data.inTrap ", data.inTrap)
    FoxObject:superClass().restore(self, data);
    --self.mLastButtonPressed = data.lastButtonPressed;
    if self.mInTrap and not data.inTrap then
        self.mInTrap = data.inTrap;
        self:playAnimation(-1);
    end
end

---------------------------------
function FoxObject:setCustomProperties(properties)
    info_log("FoxObject:setCustomProperties properties.state ", properties.state);

    FoxObject:superClass().setCustomProperties(self, properties);

    if properties.InTrap then
        self:playAnimation(PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP);
        info_log("FoxObject:setCustomProperties self.mLastButtonPressed ", self.mLastButtonPressed);
        info_log("FoxObject:setCustomProperties self.mAnimations[self.mLastButtonPressed] ", self.mAnimations[self.mLastButtonPressed]);
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
	return cc.rect(pos.x, pos.y, size.width, size.height);
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
    --debug_log("FoxObject:updateFlipNode ", self:getId(), " self.mLastDir ", self.mLastDir)
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
            info_log("FoxObject:updateFlipNode flip ", flip, " id ", self:getId());
            self:updateAnchorFightAnimation();
        end
	end
	return flip; 
end


--------------------------------
function FoxObject:updateAnchorPoint(dt)
    if self.mAnchorInterpolation then
        local anchor = self:getAnchorInHiddenCageAnimation();

        self.mAnchorInterpolation:tick(dt);
        local cur = self.mAnchorInterpolation:getCurrent();
        debug_log("FoxObject:updateAnchorPoint x ", cur.x, " y ", cur.y);
        self.mAnimationNode:setAnchorPoint(cc.p(cur.x, cur.y));

        if cur.x == anchor.x and cur.y == anchor.y then
            self.mAnchorInterpolation = nil
        end
    end
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

    if self.mNewEffect:isDependAnimation(curr) then
        self.mNewEffect:setVisible(true);
    else
        self.mNewEffect:setVisible(false);
    end
    self:updateDebugBox();

    self.mTrace:updatePosition(self.mGridPosition);

    self:updateAnchorPoint(dt);
    self.mCallbackOnDone:tick(dt);
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
    elseif button == PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP then
        debug_log("FoxObject:playAnimation self:isInTrap() ", self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_CAGE_LEFT])
        if self.mTypeCage == FoxObject.CAGE_TYPE.CT_CAGE then
            local sprite = tolua.cast(self.mAnimationNode, "cc.Sprite");
            debug_log("FoxObject:playAnimation sprite:isFlippedX() ", sprite:isFlippedX())
            debug_log("FoxObject:playAnimation self.mLastDir ", self.mLastDir)
            if sprite:isFlippedX() then
                debug_log("FoxObject:playAnimation right ")
                self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_CAGE_RIGHT];
                
                self.mLastDir = self.mIsFemale and Joystick.BUTTONS.RIGHT or Joystick.BUTTONS.LEFT;
                self:updateFlipNode(self.mAnimationNode);
                --if self.mIsFemale then
                    self.mNewEffect:updateFlip(self.mIsFemale and self.mLastDir ~= Joystick.BUTTONS.LEFT or self.mLastDir ~= Joystick.BUTTONS.RIGHT);
                --end
            else
                self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_CAGE_LEFT];
            end
            --self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_HIDDEN_CAGE];
            --self.mAnimationNode:setVisible(false);
            
            --sprite:setFlippedX(not self.mIsFemale)
        elseif self.mTypeCage == FoxObject.CAGE_TYPE.CT_HIDDEN then
            self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_HIDDEN_CAGE];
            --self.mCallbackOnDone:start();
        else
            self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mCageAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP];
        end
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
function FoxObject:isFlipped()
    local sprite = tolua.cast(self.mAnimationNode, "cc.Sprite");
    return sprite:isFlippedX();
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

---------------------------------
function FoxObject:leaveTrap(pos)
    FoxObject:superClass().leaveTrap(self, pos);
    self.mTypeCage = nil;
end

--------------------------------
function FoxObject:enterHiddenTrap(pos)
    self:enterCage(pos);

    self.mTypeCage = FoxObject.CAGE_TYPE.CT_HIDDEN;

    local anchor = self:getAnchorInHiddenCageAnimation();
    local curAnchor = self.mAnimationNode:getAnchorPoint();
    --self.mAnimationNode:setAnchorPoint(anchor);

    self.mAnchorInterpolation = LinearInterpolator:create();
    self.mAnchorInterpolation:init(Vector.new(curAnchor.x, curAnchor.y), Vector.new(anchor.x, anchor.y), 0.2);
end

--------------------------------
function FoxObject:enterCage(pos)
    self.mTypeCage = FoxObject.CAGE_TYPE.CT_CAGE;

    self:enterTrap(pos);

    --self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = self.mAnimations[FoxObject.FOX_STATE.PS_IN_CAGE_LEFT];
end

--------------------------------
function FoxObject:onMoveFinished( )
    FoxObject:superClass().onMoveFinished(self);
    if self.mInTrap then
        local gridPosition = self.mGridPosition;--Vector.new(self.mField:positionToGrid(pos));
        local cageId = BaseObject:convertToId(gridPosition.x, gridPosition.y, "104");
        debug_log("FoxObject:onMoveFinished cageTag ", cageId);
        local cage = self.mField:getObjectById(cageId);
        debug_log("FoxObject:onMoveFinished cage ", cage);
        if cage then
            cage:setVisible(false);
        end
    end
end

--------------------------------
function FoxObject:getAnchorInCageAnimation(id_anim)
    if self.mIsFemale then
        return id_anim == FoxObject.FOX_STATE.PS_IN_CAGE_LEFT and { x = 0.52, y = 0.26} or { x = 0.495, y = 0.26};
    else
        return { x = 0.5, y = 0.27};
    end
end

--------------------------------
function FoxObject:getAnchorInHiddenCageAnimation()
    if self.mIsFemale then
        return { x = 0.48, y = 0.15};
    else
        return { x = 0.48, y = 0.15};
    end
end

--------------------------------
function FoxObject:onHiddenAnimDone()
    debug_log("FoxObject:onHiddenAnimDone ")
    local pos = self.mField:gridPosToReal(Vector.new(self.mGridPosition.x, self.mGridPosition.y + 1));
    pos.x = pos.x + self.mField.mCellSize / 2;
    --pos.y = pos.y + self.mField.mCellSize / 2;
    
    local other = nil
    local players = self.mField:getPlayerObjects();
    for i, player in pairs(players) do
        if player ~= self then
            other = player;
        end
    end

    if other and not other:isInTrap() then
        self.mField:createSpirit(pos, other);
    end
end

--------------------------------
function FoxObject:createInHiddenCageAnimation()
    local animation = PlistAnimation:create();
    local anchor = self:getAnchorInHiddenCageAnimation(); --self.mAnimationNode:getAnchorPoint();
    animation:init(self:getPrefixTexture().."InHiddenTrap.plist", self.mAnimationNode, anchor, nil, 0.2);


    self.mCallbackOnDone = AnimationDoneCallback:create();
    self.mCallbackOnDone:init(animation, Callback.new(self, FoxObject.onHiddenAnimDone));


    local sequence = SequenceAnimation:create();
    sequence:init();
    sequence:addAnimation(animation);

    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mAnimationNode, anchor);
    emptyAnim:setFrame(animation:getLastFrame());

    sequence:addAnimation(emptyAnim);

    self.mCageAnimations[FoxObject.FOX_STATE.PS_IN_HIDDEN_CAGE] = sequence;
end

--------------------------------
function FoxObject:getNameLocation()
    local level = self.mField:getGame().mSceneMan:getCurrentScene():getLevel();
    local location = level:getLocation();
    return location:getDescription();
end

--------------------------------
function FoxObject:createInCageSideAnimation(texture_prefix, id_anim)
    local location = self:getNameLocation();
    debug_log("FoxObject:createInCageSideAnimation ", location);
    local texture_prefix_origin = texture_prefix
    texture_prefix = location..texture_prefix;
    local sequence = SequenceAnimation:create();
    sequence:init();

    do
        local animation = PlistAnimation:create();
        --local textureName = self:getPrefixTexture() .. "InCage"..texture_prefix.."First.png";
        --local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
        --local contentSize = texture:getContentSize() -- {width = texture:getPixelsWide(), height = texture:getPixelsHigh()}
        local anchor = self:getAnchorInCageAnimation(id_anim);
        animation:init(self:getPrefixTexture().."InCage" .. texture_prefix .. ".plist", self.mAnimationNode, anchor, texture, 0.2);

        sequence:addAnimation(animation);
    end

    -------------------------------
    local idle = PlistAnimation:create();
    idle:init(self:getPrefixTexture().."InCage" .. texture_prefix .. "End.plist", self.mAnimationNode, anchor, nil, 0.2);
    local delayAnim = DelayAnimation:create();

    local textureName = self:getPrefixTexture() .. "InCage"..texture_prefix_origin.."Text.png";
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    local contentSize = texture:getContentSize() -- {width = texture:getPixelsWide(), height = texture:getPixelsHigh()}
    debug_log("FoxObject:createInCageAnimation texture ", texture)

    delayAnim:init(idle, math.random(3, 5), texture, contentSize, textureName);

    local endAnimRep = RepeatAnimation:create();
    endAnimRep:init(delayAnim, true);

    sequence:addAnimation(endAnimRep);

    self.mNewEffect:addDependAnimation(endAnimRep);

    self.mCageAnimations[id_anim] = sequence;
end

--------------------------------
function FoxObject:createInCageAnimation()
    self.mCageAnimations = {}
    self:createInCageSideAnimation("Left", FoxObject.FOX_STATE.PS_IN_CAGE_LEFT);
    self:createInCageSideAnimation("Right", FoxObject.FOX_STATE.PS_IN_CAGE_RIGHT);
    self:createInHiddenCageAnimation();
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
    self.mNewEffect:addDependAnimation(empty);

    --self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = sequence;
    self.mCageAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = sequence;
end

---------------------------------
function FoxObject:destroyAnimation()
    self.mAnimations[PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP] = nil;
    for i, animation in pairs(self.mCageAnimations) do
        if animation then
            animation:destroy();
        end
    end

    FoxObject:superClass().destroyAnimation(self);

    self.mBackIdleAnimation:destroy();
    self.mSideIdleAnimation:destroy();
    self.mFrontIdleAnimation:destroy();
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

    self:createInCageAnimation();
    self:createInTrapAnimation();

	--self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE] = EmptyAnimation:create();
	--local frontTexture = tolua.cast(self.mAnimationNode, "cc.Sprite"):getTexture();
	--self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE]:init(frontTexture, self.mAnimationNode, contentSize);

	self:initEffectAnimations();

	self.mAnimations[-1]:play();
end
