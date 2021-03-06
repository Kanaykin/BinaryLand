require "src/animations/EmptyAnimation"
require "src/base/Log"

PlistAnimation = inheritsFrom(EmptyAnimation)
PlistAnimation.mAnimation = nil;
PlistAnimation.mAction = nil;
PlistAnimation.mLastFrame = nil;
PlistAnimation.mPlayed = nil;
PlistAnimation.mPaused = false;

--------------------------------
function PlistAnimation:getAction()
	return self.mAction;
end

--------------------------------
function PlistAnimation:getLastFrame()
  return self.mLastFrame;
end

--------------------------------
function PlistAnimation:setAction(action)
	self.mAction:release();
	self.mAction = action;
	self.mAction:retain();
end

--------------------------------
function PlistAnimation:getCurrentFrameIndex()
  return self.mAction:getCurrentFrameIndex();
end

--------------------------------
function PlistAnimation:destroy()
	PlistAnimation:superClass().destroy(self);
	self.mAction:release();
end

----------------------------
function PlistAnimation:play()
  self.mPlayed = true
--	debug_log("PlistAnimation:play");
	PlistAnimation:superClass().play(self);

  if not self.mPaused then
      if not self.mAction:isDone() then
        self.mNode:stopAction(self.mAction);
      end
      self.mNode:runAction(self.mAction);
  else 
      self.mNode:getActionManager():resumeTarget(self.mNode);
  end
  self.mPaused = false

	--debug_log("PlistAnimation:play mNode ", self.mNode);
	--debug_log("PlistAnimation:play mAction ", self.mAction);
end

---------------------------------
function PlistAnimation:isDone()
	--debug_log("PlistAnimation:isDone ", CCDirector:getInstance():getActionManager():numberOfRunningActionsInTarget(self.mAction:getTarget()));
	return self.mPlayed and (self.mAction and self.mAction:isDone() or 
		CCDirector:getInstance():getActionManager():getNumberOfRunningActionsInTarget(self.mAction:getTarget()) == 0);
end

--------------------------------
function PlistAnimation:tick(dt)
	--debug_log("animation is done :", self.mAction:isDone());
end

----------------------------
function PlistAnimation:stop()
    debug_log("PlistAnimation:stop ");
    self.mPaused = false;
    if not self.mAction:isDone() then
        self.mNode:stopAction(self.mAction);
    end
end

----------------------------
function PlistAnimation:pause()
  self.mNode:getActionManager():pauseTarget(self.mNode);
  self.mPaused = true;
end

--------------------------------
function PlistAnimation:loadFramesFromFile(plistName, arrayFrames)
    local array = cc.FileUtils:getInstance():getValueMapFromFile(plistName);
    local frames = array["frames"];
    if not frames then
      return;
    end
    info_log("PlistAnimation:init ", array["frames"]);

    local cache = CCSpriteFrameCache:getInstance();
    cache:addSpriteFrames(plistName);

    for key, val in pairs(frames) do
        --info_log("PlistAnimation:init key ", key);
        --info_log("PlistAnimation:init val ", val);

      local nameStr = key;
      table.insert(arrayFrames, nameStr);
    end
end

--------------------------------
function PlistAnimation:init(plistName, node, anchor, texture, delayPerUnit)

	PlistAnimation:superClass().init(self, texture, node, anchor);

    if not delayPerUnit then
        delayPerUnit = 1 / 10;
    end

    local arrayFrames = {};
    self:loadFramesFromFile(plistName, arrayFrames);

    local cache = CCSpriteFrameCache:getInstance();

   	table.sort( arrayFrames, function(x, y)
   		return y > x;
   	end );
    
    self.mAnimation = CCAnimation:create();
    self.mLastFrame = cache:getSpriteFrame(arrayFrames[#arrayFrames]);
    for i, val in ipairs(arrayFrames) do
   		local frame = cache:getSpriteFrame(val);
   		--info_log("PlistAnimation frame ", frame);
   		self.mAnimation:addSpriteFrame(frame);
      if not texture and i == 1 then
        self:setFrame(frame);
      end
   	end

    self.mAnimation:setDelayPerUnit(delayPerUnit);
    self.mAnimation:setRestoreOriginalFrame(true);

    local action = cc.Animate:create(self.mAnimation);
    self.mAction = action;--CCActionInterval:create(action, 1);
    self.mAction:retain();
end
