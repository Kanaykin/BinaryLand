require "src/tutorial/TutorialStepBase"

TutorialStep4 =  inheritsFrom(TutorialStepBase)
TutorialStep4.mCCBFileName = "Step4";
TutorialStep4.STEP_DURATION = 2;
TutorialStep4.mCurrentTime = nil;
TutorialStep4.mPlayerIndex = 2;

--------------------------------
function TutorialStep4:init(gameScene, field, tutorialManager)
	TutorialStep4:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():resetButtonPressed();

	self:foxBabyAnimation();

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end

    self.mCurrentTime = TutorialStep4.STEP_DURATION;
    local player = self.mField:getPlayerObjects()[self.mPlayerIndex];
    player:resetMovingParams();
end

--------------------------------
function TutorialStep4:getNextStep()
	return "TutorialStep5";
end

--------------------------------
function TutorialStep4:tick(dt)
	TutorialStep4:superClass().tick(self, dt);

	self.mCurrentTime = self.mCurrentTime - dt;
	if self.mCurrentTime <= 0 then
		self.mIsFinished = true;
	end
end