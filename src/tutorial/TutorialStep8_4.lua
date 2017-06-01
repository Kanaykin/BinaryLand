require "src/tutorial/TutorialStep1"

TutorialStep8_4 =  inheritsFrom(TutorialStep1)
TutorialStep8_4.mCCBFileName = "Step8";
TutorialStep8_4.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_12;
TutorialStep8_4.mPlayerIndex = 2;

--------------------------------
function TutorialStep8_4:init(gameScene, field, tutorialManager)
	TutorialStep8_4:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);

end

--------------------------------
function TutorialStep8_4:getNextStep()
	return "TutorialStep9";
end

