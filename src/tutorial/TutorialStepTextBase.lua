require "src/tutorial/TutorialStepBase"
require "src/base/Log"

TutorialStepTextBase =  inheritsFrom(TutorialStepBase)

TutorialStepTextBase.mCCBFileName = "";
TutorialStepTextBase.mNextStep = "";
TutorialStepTextBase.mFoxAnimation = "FoxGirl";

TutorialStepTextBase.LABEL_TAG = 2;
TutorialStepTextBase.LABEL_NEXT_TAG = 22;
TutorialStepTextBase.STEP_DURATION = 4;

--------------------------------
function TutorialStepTextBase:getNextStep()
	return self.mNextStep;
end

--------------------------------
function TutorialStepTextBase:init(gameScene, field, tutorialManager)
	TutorialStepTextBase:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, self.STEP_DURATION);


	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.LEFT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(true);

    self:foxAnimation(self.mFoxAnimation);

    local label = tolua.cast(self.mNode:getChildByTag(self.LABEL_NEXT_TAG), "cc.Label");
    if label then
    	setLabelLocalizedText(label, field.mGame);
        setDefaultFont(label, field.mGame:getScale());
    end
end

--------------------------------
function TutorialStepTextBase:tick(dt)
	TutorialStepTextBase:superClass().tick(self, dt);
end
