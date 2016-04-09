require "src/game_objects/MovableObject"
require "src/game_objects/SpiritStates"
require "src/game_objects/FoxHelpEffect"

SpiritObject = inheritsFrom(MovableObject)
SpiritObject.mAnimations = nil
SpiritObject.mPlayer = nil

SpiritObject.ANIMATION_STATE = {
	AS_FIRST_APPEAR = 1,
	AS_FOLLOW_PLAYER = 2,
	AS_DISAPPEAR = 3
}
SpiritObject.mCurrentAnimation = nil--SpiritObject.ANIMATION_STATE.AS_FIRST_APPEAR
SpiritObject.mStateMachine = nil
SpiritObject.mSourcePosition = nil
SpiritObject.mHelpEffect = nil
SpiritObject.mAnimationHideHelp = nil;

--------------------------------
function SpiritObject:init(field, node, player)
	info_log("SpiritObject:init(", node, ")");
	SpiritObject:superClass().init(self, field, node);

	self.mPlayer = player;

	self.mHelpEffect = FoxHelpEffect:create();
    self.mHelpEffect:init(node, field.mGame);
    self.mHelpEffect:setVisible(false);

	self:initAnimation();
	--self.mAnimations[self.mCurrentAnimation]:play();

    self.mSourcePosition = Vector.new(self.mNode:getPosition());
    debug_log("SpiritObject:init self.mSourcePosition ", self.mSourcePosition.x, ", ", self.mSourcePosition.y);

    self.mStateMachine = SpiritStateMachine:create();
    self.mStateMachine:init(self);

    --self:createDebugBox(node);
end

---------------------------------
function SpiritObject:destroy()
	debug_log("SpiritObject:destroy ");
	
	SpiritObject:superClass().destroy(self);

	for i, animation in ipairs(self.mAnimations) do
		animation:destroy();
	end
end

--------------------------------
function SpiritObject:playAnimation(animation)
	info_log("SpiritObject:playAnimation ", animation);
	if self.mCurrentAnimation ~= animation then
		self.mCurrentAnimation = animation;
		self.mNode:stopAllActions();
		--button = (button == nil) and -1 or button;
		self.mAnimations[animation]:play();
	end
end

--------------------------------
function SpiritObject:getAnimation(animation)
	return self.mAnimations[animation];
end

--------------------------------
function SpiritObject:createAppearAnimation()
	local prefix =  not self.mPlayer:isFemale() and "Girl" or "";

	local anchor = self.mNode:getAnchorPoint();
	local animation = PlistAnimation:create();
    animation:init("Spirit"..prefix.."Appear.plist", self.mNode, anchor, nil, 0.1);
    return animation;
end

--------------------------------
function SpiritObject:createLoopAnimation(loop)
	local prefix =  not self.mPlayer:isFemale() and "Girl" or "";

	local anchor = self.mNode:getAnchorPoint();
    local repeat_loop = RepeatAnimation:create();
    local animation_loop = PlistAnimation:create();
    animation_loop:init("Spirit"..prefix.."Loop.plist", self.mNode, anchor, nil, 0.2);
    repeat_loop:init(animation_loop, false, loop);
    return repeat_loop;
end

--------------------------------
function SpiritObject:createFirstAppearAnimation()
	local prefix =  not self.mPlayer:isFemale() and "Girl" or "";

	local sequence = SequenceAnimation:create();
    sequence:init();

	local anchor = self.mNode:getAnchorPoint();

	local animation = self:createAppearAnimation();
    sequence:addAnimation(animation);

    local repeat_loop = self:createLoopAnimation(2);
    sequence:addAnimation(repeat_loop);
    self.mHelpEffect:addDependAnimation(repeat_loop);

	local animationHide = PlistAnimation:create();
    animationHide:init("Spirit"..prefix.."Hide.plist", self.mNode, anchor, nil, 0.1);
    sequence:addAnimation(animationHide);
    self.mAnimationHideHelp = animationHide;

    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNode, anchor);
    emptyAnim:setFrame(animationHide:getLastFrame());

    sequence:addAnimation(emptyAnim);

	return sequence;
end

--------------------------------
function SpiritObject:createDisappearAnimation()
	local prefix =  not self.mPlayer:isFemale() and "Girl" or "";
	local sequence = SequenceAnimation:create();
    sequence:init();

	local animationHide = PlistAnimation:create();
    animationHide:init("Spirit"..prefix.."Hide.plist", self.mNode, anchor, nil, 0.1);
    sequence:addAnimation(animationHide);

    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNode, anchor);
    emptyAnim:setFrame(animationHide:getLastFrame());

    sequence:addAnimation(emptyAnim);

	return sequence;
end

--------------------------------
function SpiritObject:createFollowPlayerAnimation()
	debug_log("SpiritObject:createFollowPlayerAnimation ")
	local sequence = SequenceAnimation:create();
    sequence:init();

	local anchor = self.mNode:getAnchorPoint();

	local animation = self:createAppearAnimation();
    sequence:addAnimation(animation);

    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNode, anchor);
    emptyAnim:setFrame(animation:getLastFrame());
    sequence:addAnimation(emptyAnim);

    --local repeat_loop = self:createLoopAnimation();
    --sequence:addAnimation(repeat_loop);

    local sequenceRepeat = RandomAnimation:create();
    sequenceRepeat:init();
    sequence:addAnimation(sequenceRepeat);

    local animation_loop = self:createLoopAnimation(2);

    local delayAnim = DelayAnimation:create();
	local textureName = "Spirit.png";
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    local contentSize = texture:getContentSize();
	--local textureName = tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName();
	debug_log("createFollowPlayerAnimation textureName ", textureName)
    delayAnim:init(animation_loop, math.random(0, 1000)/1000, texture, contentSize, textureName);
    sequenceRepeat:addAnimation(delayAnim);

    return sequence;
end

--------------------------------
function SpiritObject:onPlayerLeaveWeb(player)
	if self.mPlayer ~= player then
		self.mStateMachine:onPlayerLeaveWeb(player);
	end
end

--------------------------------
function SpiritObject:disappear()
	self.mField:delayDelete(self);
end

--------------------------------
function SpiritObject:setPlayerFlip()
	local flip = not self.mPlayer:isFlipped();

	local sprite = tolua.cast(self.mNode, "cc.Sprite");
    if flip ~= sprite:isFlippedX() then
        sprite:setFlippedX(flip);
    end
    self.mHelpEffect:setAnchor({x = flip and -1.3 or -0.3, y = -3.5});
    self.mHelpEffect:updateFlip(flip);
end

--------------------------------
function SpiritObject:setSourcePosition()
	--debug_log("SpiritObject:setSourcePosition self.mSourcePosition ", self.mSourcePosition.x, ", ", self.mSourcePosition.y);
	self.mNode:setPosition(self.mSourcePosition.x, self.mSourcePosition.y);
end

--------------------------------
function SpiritObject:setPlayerPosition()
	local pos = self.mPlayer:getPosition();
	--debug_log("SpiritObject:setPlayerPosition pos ", pos.x, ", ", pos.y);

    pos.y = pos.y + self.mField.mCellSize / 1.2;
	self.mNode:setPosition(pos.x, pos.y);
end

--------------------------------
function SpiritObject:initAnimation()
	self.mAnimations = {}
    
    self.mAnimations[SpiritObject.ANIMATION_STATE.AS_FIRST_APPEAR] = self:createFirstAppearAnimation();
    self.mAnimations[SpiritObject.ANIMATION_STATE.AS_FOLLOW_PLAYER] = self:createFollowPlayerAnimation();
    self.mAnimations[SpiritObject.ANIMATION_STATE.AS_DISAPPEAR] = self:createDisappearAnimation();
end

--------------------------------
function SpiritObject:getCurrentAnimation()
    return self.mAnimations[self.mCurrentAnimation];
end

--------------------------------
function SpiritObject:tick(dt)
    SpiritObject:superClass().tick(self, dt);

	self.mStateMachine:tick(dt);
	self.mAnimations[self.mCurrentAnimation]:tick(dt);

	local currAnim = self:getCurrentAnimation();
    local curr = currAnim:currentAnimation();

    if self.mHelpEffect:isDependAnimation(curr) then
        self.mHelpEffect:setVisible(true);
    end
    if self.mAnimationHideHelp == curr then
    	self.mHelpEffect:setVisible(false);
    end
end