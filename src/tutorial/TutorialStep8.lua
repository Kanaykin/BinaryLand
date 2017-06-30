require "src/tutorial/TutorialStep1"

TutorialStep8 =  inheritsFrom(TutorialStep1)
TutorialStep8.mCCBFileName = "Step8";
TutorialStep8.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_8;
TutorialStep8.mPlayerIndex = 2;
TutorialStep8.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep8:init(gameScene, field, tutorialManager)
	TutorialStep8:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep8:getNextStep()
	return "";
end

