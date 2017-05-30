require "src/tutorial/TutorialStep1"

TutorialStep3_2 =  inheritsFrom(TutorialStep1)
TutorialStep3_2.mCCBFileName = "Step3";
TutorialStep3_2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_5;
TutorialStep3_2.mPlayerIndex = 1;
TutorialStep3_2.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep3_2:init(gameScene, field, tutorialManager)
	TutorialStep3_2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	-- self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);

end

--------------------------------
function TutorialStep3_2:getNextStep()
	return "TutorialStep4";
end

--------------------------------
function TutorialStep3_2:tick(dt)
	TutorialStep3_2:superClass().tick(self, dt);

	if self.mPlayer and self.mPlayer:isInTrap() then
		self.mIsFinished = true;
	end
end