require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep4Lvl_2 =  inheritsFrom(TutorialStepTextBase)

TutorialStep4Lvl_2.mCCBFileName = "Step4Lvl_2";
TutorialStep4Lvl_2.mNextStep = nil;
TutorialStep4Lvl_2.mFoxAnimation = "Fox";

--------------------------------
function TutorialStep4Lvl_2:destroy()
	TutorialStep4Lvl_2:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end