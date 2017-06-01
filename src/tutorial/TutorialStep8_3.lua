require "src/tutorial/TutorialStep1"

TutorialStep8_3 =  inheritsFrom(TutorialStep1)
TutorialStep8_3.mCCBFileName = "Step8";
TutorialStep8_3.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_11;
TutorialStep8_3.mPlayerIndex = 2;

--------------------------------
function TutorialStep8_3:init(gameScene, field, tutorialManager)
	TutorialStep8_3:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep8_3:getNextStep()
	return "TutorialStep8_4";
end

