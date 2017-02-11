require "src/tutorial/TutorialStepBase"

TutorialStep3_2 =  inheritsFrom(TutorialStepBase)
TutorialStep3_2.mCCBFileName = "Step3_2";
TutorialStep3_2.STEP_DURATION = 6;
TutorialStep3_2.mPlayerIndex = 2;

--------------------------------
function TutorialStep3_2:init(gameScene, field, tutorialManager)
	TutorialStep3_2:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep3_2.STEP_DURATION);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():resetButtonPressed();

	self:foxAnimation("FoxGirl");

    local player = self.mField:getPlayerObjects()[self.mPlayerIndex];
    player:resetMovingParams();
end

--------------------------------
function TutorialStep3_2:getNextStep()
	return "TutorialStep4";
end

--------------------------------
function TutorialStep3_2:tick(dt)
	TutorialStep3_2:superClass().tick(self, dt);
end