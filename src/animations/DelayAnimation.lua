require "src/animations/Animation"
require "src/base/Log"

DelayAnimation = inheritsFrom(IAnimation)

DelayAnimation.mImpl = nil

DelayAnimationSoftImpl = inheritsFrom(IAnimation)
DelayAnimationSoftImpl.mAnimation = nil
DelayAnimationSoftImpl.mTexture = nil
DelayAnimationSoftImpl.mTextureName = nil
DelayAnimationSoftImpl.mAnchor = nil

--------------------------------
function DelayAnimationSoftImpl:init(animation, delay, texture, textureSize, textureName, anchor)
    info_log("DelayAnimationSoftImpl:init (", texture, ", ", textureSize, ", ", textureName);
	local action = animation:getAction();
	local delayAction = cc.DelayTime:create(delay);
	local seq = cc.Sequence:create(delayAction, action);

	animation:setAction(seq);

	self.mAnimation = animation;
    self.mAnchor = anchor;

	-- remembe texture
	if texture and textureSize then
		self.mTexture = texture;
		self.mTextureSize = textureSize;
        self.mTextureName = textureName;
	elseif animation.getNode then
		local node = animation:getNode();
		local texture = tolua.cast(node, "cc.Sprite"):getTexture();
		self.mTexture = texture;
		self.mTextureSize = node:getContentSize();
	end
end

---------------------------------
function DelayAnimationSoftImpl:isDone()
	return self.mAnimation:isDone();
end

---------------------------------
function DelayAnimationSoftImpl:destroy()
	self.mAnimation:destroy();
end

----------------------------
function DelayAnimationSoftImpl:play()
	info_log("DelayAnimationSoftImpl:play ", self.mTextureName)
	if self.mTexture then
        if self.mTextureName then
            local sprite = GuiHelper.getSpriteFrame(self.mTextureName, self.mTextureSize);
            --info_log("DelayAnimationSoftImpl:play sprite ", sprite);
            tolua.cast(self.mAnimation:getNode(), "cc.Sprite"):setSpriteFrame(sprite);
        else
            --tolua.cast(self.mAnimation:getNode(), "cc.Sprite"):setTexture(self.mTexture);
            --tolua.cast(self.mAnimation:getNode(), "cc.Sprite"):setTextureRect(cc.rect(0, 0, self.mTextureSize.width, self.mTextureSize.height));
        end
	end
    if self.mAnchor then
        self.mNode:setAnchorPoint(self.mAnchor);
    end
	self.mAnimation:play();
end

--////////////////////////////////////////
--------------------------------
DelayAnimationHardImpl = inheritsFrom(IAnimation)
DelayAnimationHardImpl.mAnimation = nil
DelayAnimationHardImpl.mCurrentDelay = nil
DelayAnimationHardImpl.mDelay = nil
DelayAnimationHardImpl.mPlaying = false

function DelayAnimationHardImpl:init(animation, delay)
	self.mDelay = delay;
	self.mAnimation = animation;
end

---------------------------------
function DelayAnimationHardImpl:isDone()
	return self.mCurrentDelay and self.mCurrentDelay <= 0 and self.mAnimation:isDone();
end

---------------------------------
function DelayAnimationHardImpl:destroy()
	self.mAnimation:destroy();
end

----------------------------
function DelayAnimationHardImpl:play()
	info_log("DelayAnimationHardImpl:play ", self.mTextureName)
	self.mCurrentDelay = self.mDelay;
	self.mPlaying = false;
end

--------------------------------
function DelayAnimationHardImpl:tick(dt)
	--debug_log("DelayAnimationHardImpl:tick ", self.mCurrentDelay)
	if self.mCurrentDelay then
		
		self.mCurrentDelay = self.mCurrentDelay - dt;
		
		if self.mCurrentDelay <= 0 and not self.mPlaying then
			self.mPlaying = true;
			self.mAnimation:play();
		else
			self.mAnimation:tick(dt);
		end
	end
end

--////////////////////////////////////////
--------------------------------
function DelayAnimation:init(animation, delay, texture, textureSize, textureName, anchor)
	if animation:getAction() then
		self.mImpl = DelayAnimationSoftImpl:create();
		self.mImpl:init(animation, delay, texture, textureSize, textureName, anchor);
	else 
		self.mImpl = DelayAnimationHardImpl:create();
		self.mImpl:init(animation, delay);
	end
end

--------------------------------
function DelayAnimation:tick(dt)
	self.mImpl:tick(dt);
end

---------------------------------
function DelayAnimation:isDone()
	return self.mImpl:isDone();
end

----------------------------
function DelayAnimation:play()
	--debug_log("DelayAnimation:play")
	--self.mAnimation:play();
	self.mImpl:play();
end

---------------------------------
function DelayAnimation:destroy()
	self.mImpl:destroy();
end