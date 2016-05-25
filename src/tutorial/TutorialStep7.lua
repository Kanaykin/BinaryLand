require "src/tutorial/TutorialStepBase"

TutorialStep7 =  inheritsFrom(TutorialStepBase)
TutorialStep7.mCCBFileName = "Step7";

--------------------------------
function TutorialStep7:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	self:foxBabyAnimation();

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end
end

--------------------------------
function TutorialStep7:tick(dt)
	TutorialStep7:superClass().tick(self, dt);

end