require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep2Lvl_3 =  inheritsFrom(TutorialStepTextBase)

TutorialStep2Lvl_3.mCCBFileName = "Step2Lvl_3";
TutorialStep2Lvl_3.mNextStep = nil;--"TutorialStep2Lvl_2";
TutorialStep2Lvl_3.mFoxAnimation = "Fox";

--------------------------------
function TutorialStep2Lvl_3:destroy()
	TutorialStep2Lvl_3:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end