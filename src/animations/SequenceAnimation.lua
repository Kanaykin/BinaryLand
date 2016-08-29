require "src/animations/Animation"
require "src/base/Log"

SequenceAnimation = inheritsFrom(IAnimation)

SequenceAnimation.mAnimations = nil
SequenceAnimation.mCurrentAnimation = nil

--------------------------------
function SequenceAnimation:init()
	self.mAnimations = {}
end

----------------------------
function SequenceAnimation:currentAnimation()
    return self.mCurrentAnimation and self.mAnimations[self.mCurrentAnimation]:currentAnimation() or self;
end

--------------------------------
function SequenceAnimation:addAnimation(animation)
	self.mAnimations[#self.mAnimations + 1] = animation
end

---------------------------------
function SequenceAnimation:isDone()
	return #self.mAnimations == self.mCurrentAnimation and self.mAnimations[self.mCurrentAnimation]:isDone(); 
end

--------------------------------
function SequenceAnimation:tick(dt)
    --debug_log("SequenceAnimation:tick self.mCurrentAnimation ", self.mCurrentAnimation);
	if self.mCurrentAnimation and self.mAnimations[self.mCurrentAnimation] then
		self.mAnimations[self.mCurrentAnimation]:tick(dt)
		self:playNext();
	end
end

--------------------------------
function SequenceAnimation:setCurrentAnimation(num)
    if self.mCurrentAnimation then
        self.mAnimations[self.mCurrentAnimation]:stop();
    end
    self.mCurrentAnimation = num;
    self.mAnimations[self.mCurrentAnimation]:play();
end

--------------------------------
function SequenceAnimation:playNext()
	--debug_log("SequenceAnimation:playNext ");
	local needPlay = false;
	if not self.mCurrentAnimation then
		self.mCurrentAnimation = 1;
		needPlay = true;
	elseif self.mAnimations[self.mCurrentAnimation] and self.mAnimations[self.mCurrentAnimation]:isDone()
            and self.mAnimations[self.mCurrentAnimation + 1] then
		self.mCurrentAnimation = self.mCurrentAnimation + 1;
		needPlay = true;
	end
	if needPlay and self.mAnimations[self.mCurrentAnimation] then
		self.mAnimations[self.mCurrentAnimation]:play();
	end
end

--------------------------------
function SequenceAnimation:play()
	--info_log("SequenceAnimation:play");
    self.mCurrentAnimation = nil;
	self:playNext();
end