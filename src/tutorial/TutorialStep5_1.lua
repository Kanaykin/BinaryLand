require "src/tutorial/TutorialStep1"

TutorialStep5_1 =  inheritsFrom(TutorialStep1)
TutorialStep5_1.mCCBFileName = "Step5";
TutorialStep5_1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_7;
TutorialStep5_1.mPlayerIndex = 2;

--------------------------------
function TutorialStep5_1:init(gameScene, field, tutorialManager)
	TutorialStep5_1:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep5_1:getNextStep()
	return "TutorialStep5_2";
end
