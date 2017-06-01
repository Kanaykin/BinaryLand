require "src/tutorial/TutorialStep1"

TutorialStep8_1 =  inheritsFrom(TutorialStep1)
TutorialStep8_1.mCCBFileName = "Step8";
TutorialStep8_1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_9;
TutorialStep8_1.mPlayerIndex = 2;
TutorialStep8_1.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep8_1:init(gameScene, field, tutorialManager)
	TutorialStep8_1:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep8_1:getNextStep()
	return "TutorialStep8_2";
end

