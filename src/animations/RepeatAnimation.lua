require "src/animations/Animation"
require "src/base/Log"

RepeatAnimation = inheritsFrom(IAnimation)

RepeatAnimation.mImpl = nil

RepeatAnimationSoftImpl = inheritsFrom(IAnimation)
RepeatAnimationSoftImpl.mAnimation = nil
RepeatAnimationSoftImpl.mAction = nil;

--------------------------------
function RepeatAnimationSoftImpl:init(animation, times)
    --info_log("RepeatAnimationSoftImpl:init ( ", times);

	local action = animation:getAction();
	local repeatAction = times ~= nil and CCRepeat:create(action, times) or CCRepeatForever:create(action);
	animation:setAction(repeatAction);

	self.mAnimation = animation;
	self.mAction = repeatAction;
end

----------------------------
function RepeatAnimationSoftImpl:play()
	self.mAnimation:play();
end

---------------------------------
function RepeatAnimationSoftImpl:pause()
	local node = self.mAction:getTarget();
	node:getActionManager():pauseTarget(node);
end

----------------------------
function RepeatAnimationSoftImpl:stop()
	debug_log("RepeatAnimationSoftImpl:stop ");
	self.mAnimation:stop()
end

---------------------------------
function RepeatAnimationSoftImpl:setStopAfterDone(stopAfterDone)
	
end

---------------------------------
function RepeatAnimationSoftImpl:destroy()
	self.mAnimation:destroy();
end

--------------------------------
function RepeatAnimationSoftImpl:tick(dt)
end

---------------------------------
function RepeatAnimationSoftImpl:getAction()
    return self.mAction;
end

--------------------------------
function RepeatAnimationSoftImpl:setAction(action)
	self.mAction:release();
	self.mAction = action;
	self.mAction:retain();
end

---------------------------------
function RepeatAnimationSoftImpl:isDone()
	return self.mAnimation:isDone();
end

--///////////////////////////////
--------------------------------
RepeatAnimationHardImpl = inheritsFrom(IAnimation)
RepeatAnimationHardImpl.mAnimation = nil
RepeatAnimationHardImpl.mPlaying = false
RepeatAnimationHardImpl.mStopAfterDone = false
RepeatAnimationHardImpl.mPaused = false;

--------------------------------
function RepeatAnimationHardImpl:init(animation)
	self.mAnimation = animation;
end

----------------------------
function RepeatAnimationHardImpl:play()
	self.mPaused = false
	self.mAnimation:play();
	self.mPlaying = true
end

---------------------------------
function RepeatAnimationHardImpl:destroy()
	self.mAnimation:destroy();
end

---------------------------------
function RepeatAnimationHardImpl:setStopAfterDone(stopAfterDone)
	self.mStopAfterDone = stopAfterDone
end

----------------------------
function RepeatAnimationHardImpl:stop()
	self.mPlaying = false
end

--------------------------------
function RepeatAnimationHardImpl:setAction()
end

--------------------------------
function RepeatAnimationHardImpl:tick(dt)
	if self.mPaused then
		return;
	end
	if self.mPlaying and self:isDone() and not self.mStopAfterDone then
		--info_log("RepeatAnimationHardImpl:tick replay ");
		self:play();
	end
end

---------------------------------
function RepeatAnimationHardImpl:pause()
	self.mPaused = true;
	self.mAnimation:pause();
end

---------------------------------
function RepeatAnimationHardImpl:getAction()
    return nil;
end

---------------------------------
function RepeatAnimationHardImpl:isDone()
	return self.mAnimation:isDone();
end

--///////////////////////////////
--------------------------------
function RepeatAnimation:init(animation, hard, time)
	if hard then
		self.mImpl = RepeatAnimationHardImpl:create();
		self.mImpl:init(animation);
	else
		self.mImpl = RepeatAnimationSoftImpl:create();
		self.mImpl:init(animation, time);
	end
end

---------------------------------
function RepeatAnimation:getAction()
    return --self.mImpl:getAction();
end

--------------------------------
function RepeatAnimation:setAction(action)
	self.mImpl:setAction(action);
end

---------------------------------
function RepeatAnimation:isDone()
	return self.mImpl:isDone();
end

----------------------------
function RepeatAnimation:play()
	self.mImpl:play();
end

----------------------------
function RepeatAnimation:stop()
	debug_log("RepeatAnimation:stop ");
	self.mImpl:stop();
end

---------------------------------
function RepeatAnimation:pause()
	self.mImpl:pause();
end

---------------------------------
function RepeatAnimation:destroy()
	self.mImpl:destroy();
end

---------------------------------
function RepeatAnimation:setStopAfterDone(stopAfterDone)
	self.mImpl:setStopAfterDone(stopAfterDone);
end

--------------------------------
function RepeatAnimation:tick(dt)
	self.mImpl:tick(dt);
end
