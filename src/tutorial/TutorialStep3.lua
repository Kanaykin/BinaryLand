require "src/tutorial/TutorialStep1"

TutorialStep3 =  inheritsFrom(TutorialStep1)
TutorialStep3.mCCBFileName = "Step3";
TutorialStep3.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_3;
TutorialStep3.mPlayerIndex = 1;
TutorialStep3.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep3:init(gameScene, field, tutorialManager)
	TutorialStep3:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep3:getNextStep()
	return "TutorialStep3_1";
end