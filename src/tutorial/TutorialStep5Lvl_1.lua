require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep5Lvl_1 =  inheritsFrom(TutorialStepTextBase)

TutorialStep5Lvl_1.mCCBFileName = "Step5Lvl_1";
TutorialStep5Lvl_1.mNextStep = nil;
TutorialStep5Lvl_1.mFoxAnimation = "Fox";

--------------------------------
function TutorialStep5Lvl_1:destroy()
	TutorialStep5Lvl_1:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end