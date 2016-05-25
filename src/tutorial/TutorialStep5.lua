require "src/tutorial/TutorialStepBase"

TutorialStep5 =  inheritsFrom(TutorialStepBase)
TutorialStep5.mCCBFileName = "Step5";
TutorialStep5.mTriggerTags = {FactoryObject.TUTORIAL_TRIGGER_4, FactoryObject.TUTORIAL_TRIGGER_5};
TutorialStep5.mTriggers = nil;

--------------------------------
function TutorialStep5:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	self:foxBabyAnimation();

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end
    self.mTriggers = {} 
    for i, tag in ipairs(TutorialStep5.mTriggerTags) do
    	self.mTriggers[i] = self.mField:getObjetcByTag(tag);
    end
end

--------------------------------
function TutorialStep5:getNextStep()
	return "TutorialStep6";
end

--------------------------------
function TutorialStep5:tick(dt)
	TutorialStep5:superClass().tick(self, dt);

	for i, trigger in ipairs(self.mTriggers) do
		if trigger:getContainedObj() ~= nil then
			info_log("TutorialStep5:tick FINISH Step");
			self.mIsFinished = true;
		end
	end
end