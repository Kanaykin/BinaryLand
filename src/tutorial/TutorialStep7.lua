require "src/tutorial/TutorialStepBase"

TutorialStep7 =  inheritsFrom(TutorialStepBase)
TutorialStep7.mCCBFileName = "Step7";
TutorialStep7.STEP_DURATION = 4;

--------------------------------
function TutorialStep7:init(gameScene, field, tutorialManager)
	TutorialStep7:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep7.STEP_DURATION);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(true);

	self:foxAnimation("FoxGirl");
end

--------------------------------
function TutorialStep7:getNextStep()
	return "TutorialStep8";
end

--------------------------------
function TutorialStep7:tick(dt)
	TutorialStep7:superClass().tick(self, dt);

end