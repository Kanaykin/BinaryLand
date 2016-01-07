require "src/base/Inheritance"

AnimationDoneCallback = inheritsFrom(nil)
AnimationDoneCallback.mCallback = nil
AnimationDoneCallback.mAnimation = nil
AnimationDoneCallback.mSent = nil
AnimationDoneCallback.mStarted = nil

-------------------------------------
function AnimationDoneCallback:init(animation, callback)
	self.mCallback = callback;
	self.mAnimation = animation;
	self.mSent = false
	self.mStarted = false
end

-------------------------------------
function AnimationDoneCallback:start()
	self.mStarted = true
end

-------------------------------------
function AnimationDoneCallback:tick(dt)
	if self.mAnimation:isDone() and not self.mSent then
		self.mSent = true;
		self.mCallback();
	end
end
