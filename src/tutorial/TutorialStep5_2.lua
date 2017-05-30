require "src/tutorial/TutorialStep1"

TutorialStep5_2 =  inheritsFrom(TutorialStep1)
TutorialStep5_2.mCCBFileName = "Step5";
TutorialStep5_2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_5;
TutorialStep5_2.mPlayerIndex = 2;

--------------------------------
function TutorialStep5_2:init(gameScene, field, tutorialManager)
	TutorialStep5_2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep5_2:getNextStep()
	return "TutorialStep6";
end
