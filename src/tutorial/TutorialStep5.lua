require "src/tutorial/TutorialStepBase"

TutorialStep5 =  inheritsFrom(TutorialStepBase)
TutorialStep5.mCCBFileName = "Step5";
TutorialStep5.STEP_DURATION = 3;

--------------------------------
function TutorialStep5:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep5.STEP_DURATION);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self:foxAnimation("FoxGirl");
end

--------------------------------
function TutorialStep5:getNextStep()
	return "TutorialStep6";
end

--------------------------------
function TutorialStep5:tick(dt)
	TutorialStep5:superClass().tick(self, dt);
end