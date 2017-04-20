require "src/tutorial/TutorialStepBase"
require "src/base/Log"

TutorialStep1 =  inheritsFrom(TutorialStepBase)
TutorialStep1.mPlayer = nil;
TutorialStep1.mPlayerIndex = 2;
TutorialStep1.FREE_TIME = 2.0;
TutorialStep1.mCurrentFingerTime = nil;

TutorialStep1.mFingerFinishPosition = nil;--Vector.new(6, 6);

TutorialStep1.mCCBFileName = "Step1";
TutorialStep1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_1;
TutorialStep1.mTrigger = nil;
TutorialStep1.FOX_BABY_TAG = 1;
TutorialStep1.LABEL_TAG = 2;

---------------------------------
function TutorialStep1:destroy()
	info_log("TutorialStep1:destroy()");

	TutorialStep1:superClass().destroy(self);
end

--------------------------------
function TutorialStep1:getNextStep()
	return "TutorialStep1_1";
end

--------------------------------
function TutorialStep1:onBeginAnimationFinished()
	info_log("TutorialStep1:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStep1.FREE_TIME;
end

--------------------------------
function TutorialStep1:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStep1:init(gameScene, field, tutorialManager)
	TutorialStep1:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	-- local dest = field:gridPosToReal(self.mFinishPosition);
	-- dest.x = dest.x + field.mCellSize / 2;
	-- dest.y = dest.y + field.mCellSize / 2;
	-- self.mFinishPosition = dest;

	self.mPlayer = self.mField:getPlayerObjects()[self.mPlayerIndex];

	self.mTrigger = self.mField:getObjectsByTag(self.mTriggerTag)[1];
	info_log("TutorialStep1:init self.mTrigger ", self.mTrigger);
	local dest = self.mTrigger:getPosition();
	--dest.x = dest.x + field.mCellSize / 2;
	--dest.y = dest.y + field.mCellSize / 2;
	self.mFingerFinishPosition = dest;

	self:initFinger(gameScene, field);
	self:initArrow(gameScene, field);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(true);

    --self:foxAnimation("Fox");
end

--------------------------------
function TutorialStep1:tick(dt)
	-- check finished
	if self.mTrigger:getContainedObj() ~= nil then
		info_log("TutorialStep1:tick FINISH Step");
		self.mIsFinished = true;
	end

	self.mFinger:tick(dt);

	self.mArrow:setPositions(self:getPlayerPos(), self.mFingerFinishPosition);

	if self.mCurrentFingerTime ~= nil then
  --       --info_log("TutorialStep1:tick ContainedObj ", self.mTrigger:getContainedObj())

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() and not self.mPlayer:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then
			self.mFinger:move(self:getPlayerPos(), self.mFingerFinishPosition);
		end
	end
end
