require "src/tutorial/TutorialStepBase"

TutorialStep7_1 =  inheritsFrom(TutorialStepBase)
TutorialStep7_1.mCCBFileName = "Step7_1";
TutorialStep7_1.STEP_DURATION = 4;

--------------------------------
function TutorialStep7_1:init(gameScene, field, tutorialManager)
	TutorialStep7_1:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep7_1.STEP_DURATION);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self:foxBabyAnimation();
end

--------------------------------
function TutorialStep7_1:getNextStep()
	return "TutorialStep8";
end

--------------------------------
function TutorialStep7_1:tick(dt)
	TutorialStep5:superClass().tick(self, dt);
end