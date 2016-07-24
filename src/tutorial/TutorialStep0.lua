require "src/tutorial/TutorialStepBase"
require "src/base/Log"

TutorialStep0 =  inheritsFrom(TutorialStepBase)

TutorialStep0.mCCBFileName = "Step0";
TutorialStep0.LABEL_TAG = 2;
TutorialStep0.STEP_DURATION = 4;

--------------------------------
function TutorialStep0:getNextStep()
	return "TutorialStep1";
end

--------------------------------
function TutorialStep0:init(gameScene, field, tutorialManager)
	TutorialStep0:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, self.STEP_DURATION);


	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(true);

    self:foxAnimation("FoxGirl");
end

--------------------------------
function TutorialStep0:tick(dt)
	TutorialStep0:superClass().tick(self, dt);
end
