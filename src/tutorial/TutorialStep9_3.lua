require "src/tutorial/TutorialStep1"

TutorialStep9_3 =  inheritsFrom(TutorialStep1)
TutorialStep9_3.mCCBFileName = "Step8";
TutorialStep9_3.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_10;
TutorialStep9_3.mPlayerIndex = 1;

--------------------------------
function TutorialStep9_3:init(gameScene, field, tutorialManager)
	TutorialStep9_3:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);

end

--------------------------------
function TutorialStep9_3:getNextStep()
	--return "TutorialStep9";
end

--------------------------------
function TutorialStep9_3:finished()
	return false;
end