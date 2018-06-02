require "src/base/Inheritance"
require "src/tutorial/Finger"
require "src/tutorial/Arrow"
require "src/base/Log"
require "src/gui/TouchWidget"

TutorialStepBase =  inheritsFrom(nil)
TutorialStepBase.mFinger = nil
TutorialStepBase.mArrow = nil
TutorialStepBase.mField = nil;
TutorialStepBase.mTutorialManager = nil
TutorialStepBase.mIsFinished = false
TutorialStepBase.mNode = nil;
TutorialStepBase.mCurrentTime = nil;
TutorialStepBase.mTouchBegan = false;

TutorialStepBase.LAYER_TAG = 10;

---------------------------------
function TutorialStepBase:destroy()
    self.mTutorialManager:getMainUI():removeListener(self);

	if self.mFinger then
		self.mFinger:destroy();
		self.mFinger = nil;
	end

	if self.mArrow then
		self.mArrow:destroy();
		self.mArrow = nil;
	end

	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		--self.mNode:release();
		self.mNode = nil;
	end
end

--------------------------------
function TutorialStepBase:foxAnimation(animName)--FoxBaby
    info_log("TutorialStep1:foxAnimation self.mNode ", animName);

    if not self.mNode then
    	return;
    end
    local foxBaby = self.mNode:getChildByTag(TutorialStep1.FOX_BABY_TAG);
    info_log("TutorialStep1:foxAnimation ", foxBaby);

    if foxBaby then
        local animation = PlistAnimation:create();
        animation:init(animName .. "TutorAnim.plist", foxBaby, foxBaby:getAnchorPoint(), nil, 0.2);

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

	local callFunc = cc.CallFunc:create(callback);
	animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	animator:runAnimationsForSequenceNamed("animation");
end

-- --------------------------------
function TutorialStepBase:onTouchHandler(action)
	info_log("TutorialStepBase:onTouchHandler 2 action ", action);
	if action == "began" then
		self.mTouchBegan = true;
	end

	if self.mTouchBegan and action == "ended" then
		self.mIsFinished = true;
	end
end

---------------------------------
function TutorialStepBase:initFromCCB(ccbfile, gameScene)
	if not ccbfile then
		return;
	end
	local ccpproxy = cc.CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbfile, reader, false);
	self.mNode = node;

	local animator = reader:getActionManager();
	self:initBeginAnimation(animator);

	gameScene:addChild(node);

	local layer = tolua.cast(node:getChildByTag(TutorialStepBase.LAYER_TAG), "cc.Layer");
	info_log("TutorialStepBase:init layer ", layer);

	local function onTouchHandler(action, var)
		info_log("TutorialStepBase:onTouchHandler 1 action ", action);
		self:onTouchHandler(action);
		return false--self.mTouch:onTouchHandler(action, var);
	end
	-- self.mTouch = TouchWidget:create();
	-- self.mTouch:init(layer:getBoundingBox());

	if layer then
    	layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
    	layer:setTouchEnabled(true);
    end
end

--------------------------------
function TutorialStepBase:getPlayerPosImpl(player)
	local playerGridPosition = Vector.new(self.mField:getGridPosition(player.mNode));
	--[[info_log("playerGridPosition ", playerGridPosition.x);
	local dest = self.mField:gridPosToReal(playerGridPosition);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	return dest;]]
	return Vector.new(player.mNode:getPosition());

end

--------------------------------
function TutorialStepBase:getPlayerPos()
	return self:getPlayerPosImpl(self.mPlayer);
end

--------------------------------
function TutorialStepBase:getPlayerGridPos()
	local playerGridPosition = Vector.new(self.mField:getGridPosition(self.mPlayer.mNode));
	return playerGridPosition;
end

--------------------------------
function TutorialStepBase:tick(dt)
	-- if self.mCurrentTime then
	--     self.mCurrentTime = self.mCurrentTime - dt;
	-- 	if self.mCurrentTime <= 0 then
	-- 		self.mIsFinished = true;
	-- 	end
	-- end
end

--------------------------------
function TutorialStepBase:initFinger(gameScene, field)
	self.mFinger = Finger:create();
	self.mFinger:init(gameScene, field);
end

--------------------------------
function TutorialStepBase:initArrow(gameScene, field)
	self.mArrow = Arrow:create();
	
	self.mArrow:init(gameScene, field, self:getPlayerPos(), self.mFingerFinishPosition);
end

--------------------------------
function TutorialStepBase:finished()
	return self.mIsFinished;
end

--------------------------------
function TutorialStepBase:init(gameScene, field, tutorialManager, ccbfile, step_duration)
	self.mField = field;

	self.mTutorialManager = tutorialManager;
	info_log("TutorialStepBase:init ", self.mTutorialManager );

	self:initFromCCB(ccbfile, gameScene);

	self.mTutorialManager:getMainUI():addTouchListener(self);

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    if label then
    	setLabelLocalizedText(label, field.mGame);
        setDefaultFont(label, field.mGame:getScale());
    end
    self.mCurrentTime = step_duration;

end
