require "src/tutorial/TutorialStep1"

TutorialStep2 =  inheritsFrom(TutorialStep1)
TutorialStep2.mCCBFileName = "Step2";
TutorialStep2.mFinishPosition = Vector.new(7, 6);
TutorialStep2.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_2;
TutorialStep2.mPlayerIndex = 2;
TutorialStep2.LABEL_TAG2 = 3;

--------------------------------
function TutorialStep2:init(gameScene, field, tutorialManager)
	TutorialStep2:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);

    local label = tolua.cast(self.mNode:getChildByTag(TutorialStep2.LABEL_TAG2), "cc.Label");
	debug_log("TutorialStep2:init label ", label);
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end
end

--------------------------------
function TutorialStep2:getNextStep()
	return "TutorialStep3";
end