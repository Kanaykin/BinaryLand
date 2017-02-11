require "src/tutorial/TutorialStepPath"

TutorialStep4 =  inheritsFrom(TutorialStepPath)
TutorialStep4.mCCBFileName = "Step4";
TutorialStep4.STEP_DURATION = 3;
TutorialStep4.mPlayerIndex = 2;
TutorialStep4.mTriggerTags = {FactoryObject.TUTORIAL_TRIGGER_5};

--------------------------------
function TutorialStep4:init(gameScene, field, tutorialManager)
	TutorialStep4:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName, TutorialStep4.STEP_DURATION);
end

--------------------------------
function TutorialStep4:getNextStep()
	return "TutorialStep5";
end

--------------------------------
function TutorialStep4:tick(dt)
	TutorialStep4:superClass().tick(self, dt);
end