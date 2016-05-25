require "src/tutorial/TutorialStep1"

TutorialStep2 =  inheritsFrom(TutorialStep1)
TutorialStep2.mCCBFileName = "Step2";
--TutorialStep2.mFinishPosition = Vector.new(7, 6);
TutorialStep2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_2;
TutorialStep2.mPlayerIndex = 2;
TutorialStep2.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep2:init(gameScene, field, tutorialManager)
	TutorialStep2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep2:getNextStep()
	return "TutorialStep3";
end