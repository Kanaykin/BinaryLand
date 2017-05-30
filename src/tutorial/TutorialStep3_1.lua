require "src/tutorial/TutorialStep1"

TutorialStep3_1 =  inheritsFrom(TutorialStep1)
TutorialStep3_1.mCCBFileName = "Step3";
TutorialStep3_1.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_4;
TutorialStep3_1.mPlayerIndex = 1;
TutorialStep3_1.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep3_1:init(gameScene, field, tutorialManager)
	TutorialStep3_1:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

end

--------------------------------
function TutorialStep3_1:getNextStep()
	return "TutorialStep3_2";
end

--------------------------------
function TutorialStep3_1:tick(dt)
	TutorialStep3_1:superClass().tick(self, dt);

	if self.mPlayer and self.mPlayer:isInTrap() then
		self.mIsFinished = true;
	end
end