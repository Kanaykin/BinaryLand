require "src/tutorial/TutorialStep1"

TutorialStep9_2 =  inheritsFrom(TutorialStep1)
TutorialStep9_2.mCCBFileName = "Step8";
TutorialStep9_2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_13;
TutorialStep9_2.mPlayerIndex = 2;

--------------------------------
function TutorialStep9_2:init(gameScene, field, tutorialManager)
	TutorialStep9_2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);

end

--------------------------------
function TutorialStep9_2:getNextStep()
	return "TutorialStep9_3";
end

