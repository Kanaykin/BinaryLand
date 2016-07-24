require "src/tutorial/TutorialStepBase"

TutorialStep4 =  inheritsFrom(TutorialStepBase)
TutorialStep4.mCCBFileName = "Step4";
TutorialStep4.STEP_DURATION = 3;
TutorialStep4.mPlayerIndex = 2;

--------------------------------
function TutorialStep4:init(gameScene, field, tutorialManager)
	TutorialStep4:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep4.STEP_DURATION);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
	self.mTutorialManager:getMainUI():getJoystick():resetButtonPressed();

	self:foxAnimation("Fox");

    local player = self.mField:getPlayerObjects()[self.mPlayerIndex];
    player:resetMovingParams();
end

--------------------------------
function TutorialStep4:getNextStep()
	return "TutorialStep5";
end

--------------------------------
function TutorialStep4:tick(dt)
	TutorialStep4:superClass().tick(self, dt);
end