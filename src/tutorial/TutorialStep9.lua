require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep9 =  inheritsFrom(TutorialStepTextBase)

TutorialStep9.mCCBFileName = "Step9";
TutorialStep9.mNextStep = "TutorialStep9_free";
TutorialStep9.mFoxAnimation = "FoxGirl";

--------------------------------
function TutorialStep9:init(gameScene, field, tutorialManager)
	TutorialStep9:superClass().init(self, gameScene, field, tutorialManager);
	
	local finishTriggers = self.mField:getObjectsByTag(FactoryObject.FINISH_TAG);
    for i, trigger in ipairs(finishTriggers) do
    	trigger:showBacklight();
    end
end