require "src/animations/Animation"
require "src/base/Log"

RandomAnimation = inheritsFrom(IAnimation)

RandomAnimation.mAnimations = nil
RandomAnimation.mCurrentAnimation = nil
RandomAnimation.mPaused = false;

--------------------------------
function RandomAnimation:init()
	self.mAnimations = {}
end

--------------------------------
function RandomAnimation:addAnimation(animation)
	self.mAnimations[#self.mAnimations + 1] = animation
end

--------------------------------
function RandomAnimation:tick(dt)
	if self.mPaused then
		return;
	end
	if self.mCurrentAnimation then
		self.mCurrentAnimation:tick(dt);
	end
	self:playNext();
end

----------------------------
function RandomAnimation:pause()
	self.mPaused = true;
  	if self.mCurrentAnimation then
		self.mCurrentAnimation:pause();
	end
end

--------------------------------
function RandomAnimation:playNext()
	--debug_log("RandomAnimation:playNext ", not self.mCurrentAnimation or self.mCurrentAnimation:isDone());
	if not self.mCurrentAnimation or self.mCurrentAnimation:isDone() then
		local animNum = math.fmod(math.random (1, 32767), #self.mAnimations) + 1;
		self.mCurrentAnimation = self.mAnimations[animNum];
		self.mCurrentAnimation:play();
	end
end

--------------------------------
function RandomAnimation:play()
	if self.mPaused then
		self.mPaused = false;
  		if self.mCurrentAnimation then
			self.mCurrentAnimation:play();
		end
		return;
	end
	--info_log("RandomAnimation:play");
	self:playNext();
end
