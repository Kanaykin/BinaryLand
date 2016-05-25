require "src/tutorial/TutorialStep1"

TutorialStep6 =  inheritsFrom(TutorialStepBase)
TutorialStep6.mCCBFileName = "Step6";
TutorialStep6.FREE_TIME = 2.0;
TutorialStep6.mCurrentFingerTime = nil;
TutorialStep6.mPlayer = nil;
TutorialStep6.mSecondPlayer = nil;

--------------------------------
function TutorialStep6:init(gameScene, field, tutorialManager)
	TutorialStep6:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mPlayer = self.mField:getPlayerObjects()[2];
	self.mSecondPlayer = self.mField:getPlayerObjects()[1];

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():resetButtonPressed();

	self:foxBabyAnimation();

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
	debug_log("TutorialStep2:init label ", label);
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end

    self:initFinger(gameScene, field);

    self.mCurrentFingerTime = TutorialStep3.FREE_TIME;
    self.mPlayer:resetMovingParams();
end

--------------------------------
function TutorialStep6:onBeginAnimationFinished()
	self.mCurrentFingerTime = TutorialStep3.FREE_TIME;
end

--------------------------------
function TutorialStep6:onTouchHandler()
	self.mCurrentFingerTime = 0;
end

--------------------------------
function TutorialStep6:getNextStep()
	return "TutorialStep7";
end

--------------------------------
function TutorialStep6:tick(dt)

	if self.mCurrentFingerTime ~= nil then

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then
			self.mFinger:setPosition(self:getPlayerPos());
			self.mFinger:playDoubleTapAnimation();
		end

	end

	if not self.mSecondPlayer:isInTrap() then
		info_log("TutorialStep6:tick FINISH Step");
		self.mIsFinished = true;
	end
end
