require "src/tutorial/TutorialStep1"

TutorialStep8_2 =  inheritsFrom(TutorialStep1)
TutorialStep8_2.mCCBFileName = "Step8";
TutorialStep8_2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_10;
TutorialStep8_2.mPlayerIndex = 2;

--------------------------------
function TutorialStep8_2:init(gameScene, field, tutorialManager)
	TutorialStep8_2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep8_2:getNextStep()
	return "TutorialStep8_3";
end

