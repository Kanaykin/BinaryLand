require "src/animations/EmptyAnimation"

PlistAnimation = inheritsFrom(EmptyAnimation)
PlistAnimation.mAnimation = nil;
PlistAnimation.mAction = nil;

--------------------------------
function PlistAnimation:getAction()
	return self.mAction;
end

--------------------------------
function PlistAnimation:setAction(action)
	self.mAction:release();
	self.mAction = action;
	self.mAction:retain();
end

--------------------------------
function PlistAnimation:destroy()
	PlistAnimation:superClass().destroy(self);
	self.mAction:release();
end

----------------------------
function PlistAnimation:play()
--	print("PlistAnimation:play");
	PlistAnimation:superClass().play(self);

	self.mNode:stopAction(self.mAction);
	print("PlistAnimation:play mNode ", self.mNode);
	print("PlistAnimation:play mAction ", self.mAction);
	self.mNode:runAction(self.mAction);
end

---------------------------------
function PlistAnimation:isDone()
	--print("PlistAnimation:isDone ", CCDirector:getInstance():getActionManager():numberOfRunningActionsInTarget(self.mAction:getTarget()));
	return self.mAction and self.mAction:isDone() or 
		CCDirector:getInstance():getActionManager():getNumberOfRunningActionsInTarget(self.mAction:getTarget()) == 0;
end

--------------------------------
function PlistAnimation:tick(dt)
	--print("animation is done :", self.mAction:isDone());
end

--------------------------------
function PlistAnimation:init(plistName, node, anchor, texture)

	PlistAnimation:superClass().init(self, texture, node, anchor);

    local array = cc.FileUtils:getInstance():getValueMapFromFile(plistName);
    local frames = array["frames"];
    print("PlistAnimation:init ", array["frames"]);

	local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
   	cache:addSpriteFramesWithFile(plistName);

   	self.mAnimation = CCAnimation:create();

   	local arrayFrames = {};
    for key, val in pairs(frames) do
        print("PlistAnimation:init key ", key);
        print("PlistAnimation:init val ", val);

        local nameStr = key;
   		table.insert(arrayFrames, nameStr);
   	end

   	table.sort( arrayFrames, function(x, y) 
   		return y < x;
   	end );

   	for i, val in ipairs(arrayFrames) do
   		local frame = cache:spriteFrameByName(val);
   		print("PlistAnimation frame ", frame);
   		self.mAnimation:addSpriteFrame(frame);
   	end

   	self.mAnimation:setDelayPerUnit(1 / 10);
	self.mAnimation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(self.mAnimation);
	self.mAction = action;--CCActionInterval:create(action, 1);

	self.mAction:retain();
end