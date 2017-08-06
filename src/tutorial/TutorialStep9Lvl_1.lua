require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep9Lvl_1 =  inheritsFrom(TutorialStepTextBase)

TutorialStep9Lvl_1.mCCBFileName = "Step9Lvl_1";
TutorialStep9Lvl_1.mNextStep = nil;
TutorialStep9Lvl_1.mFoxAnimation = "Fox";

--------------------------------
function TutorialStep9Lvl_1:destroy()
	TutorialStep9Lvl_1:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end