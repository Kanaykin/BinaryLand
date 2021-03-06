require "src/tutorial/TutorialStepBase"
require "src/base/Log"

TutorialStep3 =  inheritsFrom(TutorialStepBase)
TutorialStep3.mCCBFileName = "Step3";
TutorialStep3.mSecondPlayer = nil;
TutorialStep3.mCurrentFingerTime = nil;
TutorialStep3.FREE_TIME = 2.0;
TutorialStep3.mPlayerIndex = 2;

--------------------------------
function TutorialStep3:init(gameScene, field, tutorialManager)
	TutorialStep3:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mPlayer = self.mField:getPlayerObjects()[2];
	self.mSecondPlayer = self.mField:getPlayerObjects()[1];

	self:initFinger(gameScene, field);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);

    self:foxBabyAnimation();
    local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    debug_log("TutorialStep3:init label ", label);
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end
end

--------------------------------
function TutorialStep3:onTouchHandler()
	self.mCurrentFingerTime = 0;
	--self.mFinger:stop();
end

--------------------------------
function TutorialStep3:onBeginAnimationFinished()
	info_log("TutorialStep3:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStep3.FREE_TIME;
end

--------------------------------
function TutorialStep3:getNextStep()
	return "TutorialStep4";
end

--------------------------------
function TutorialStep3:tick(dt)

	if self.mCurrentFingerTime ~= nil then

		if not self.mSecondPlayer:isInTrap() then
			info_log("TutorialStep3:tick FINISH Step");
			self.mIsFinished = true;
		end

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then
			self.mFinger:setPosition(self:getPlayerPos());
			self.mFinger:playDoubleTapAnimation();
		end

	end
end