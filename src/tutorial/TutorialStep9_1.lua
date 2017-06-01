require "src/tutorial/TutorialStep1"

TutorialStep9_1 =  inheritsFrom(TutorialStep1)
TutorialStep9_1.mCCBFileName = "Step8";
TutorialStep9_1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_11;
TutorialStep9_1.mPlayerIndex = 2;

--------------------------------
function TutorialStep9_1:init(gameScene, field, tutorialManager)
	TutorialStep9_1:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);

end

--------------------------------
function TutorialStep9_1:getNextStep()
	return "TutorialStep9_2";
end

