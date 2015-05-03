require "src/base/Inheritance"
require "src/tutorial/Finger"
require "src/base/Log"

TutorialStepBase =  inheritsFrom(nil)
TutorialStepBase.mFinger = nil
TutorialStepBase.mField = nil;
TutorialStepBase.mTutorialManager = nil
TutorialStepBase.mIsFinished = false
TutorialStepBase.mNode = nil;

---------------------------------
function TutorialStepBase:destroy()
    self.mTutorialManager:getMainUI():removeListener(self);

	if self.mFinger then
		self.mFinger:destroy();
		self.mFinger = nil;
	end

	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		--self.mNode:release();
		self.mNode = nil;
	end
end

--------------------------------
function TutorialStepBase:foxBabyAnimation()
    info_log("TutorialStep1:foxBabyAnimation self.mNode ", self.mNode);
    local foxBaby = self.mNode:getChildByTag(TutorialStep1.FOX_BABY_TAG);
    info_log("TutorialStep1:foxBabyAnimation ", foxBaby);

    if foxBaby then
        local animation = PlistAnimation:create();
        animation:init("FoxBabyTutorAnim.plist", foxBaby, foxBaby:getAnchorPoint());

        local repeatAnimation = RepeatAnimation:create();
        repeatAnimation:init(animation);
        repeatAnimation:play();
    end
end

--------------------------------
function TutorialStepBase:onBeginAnimationFinished()
	info_log("TutorialStepBase:onBeginAnimationFinished");
end

--------------------------------
function TutorialStepBase:initBeginAnimation(animator)
	function callback()
		self:onBeginAnimationFinished();
	end

	local callFunc = CCCallFunc:create(callback);
	animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	animator:runAnimationsForSequenceNamed("animation");
end

--------------------------------
function TutorialStepBase:onTouchHandler()
end

---------------------------------
function TutorialStepBase:initFromCCB(ccbfile, gameScene)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbfile, reader, false);
	self.mNode = node;

	local animator = reader:getActionManager();
	self:initBeginAnimation(animator);

	gameScene:addChild(node);

	local layer = tolua.cast(node, "cc.Layer");
	info_log("TutorialStepBase:init layer ", layer);

	local function onTouchHandler(action, var)
		info_log("onTouchHandler ");
		self:onTouchHandler();
	end

    self.mTutorialManager:getMainUI():addTouchListener(self);

end

--------------------------------
function TutorialStepBase:getPlayerPos()
	local playerGridPosition = Vector.new(self.mField:getGridPosition(self.mPlayer.mNode));
	--[[info_log("playerGridPosition ", playerGridPosition.x);
	local dest = self.mField:gridPosToReal(playerGridPosition);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	return dest;]]
	return Vector.new(self.mPlayer.mNode:getPosition());
end

--------------------------------
function TutorialStepBase:getPlayerGridPos()
	local playerGridPosition = Vector.new(self.mField:getGridPosition(self.mPlayer.mNode));
	return playerGridPosition;
end

--------------------------------
function TutorialStepBase:tick(dt)
end

--------------------------------
function TutorialStepBase:initFinger(gameScene, field)
	self.mFinger = Finger:create();
	self.mFinger:init(gameScene, field);
end

--------------------------------
function TutorialStepBase:finished()
	return self.mIsFinished;
end

--------------------------------
function TutorialStepBase:init(gameScene, field, tutorialManager, ccbfile)
	self.mField = field;

	self.mTutorialManager = tutorialManager;
	info_log("TutorialStepBase:init ", self.mTutorialManager );

	self:initFromCCB(ccbfile, gameScene);
end