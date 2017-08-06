require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep7Lvl_1 =  inheritsFrom(TutorialStepTextBase)

TutorialStep7Lvl_1.mCCBFileName = "Step7Lvl_1";
TutorialStep7Lvl_1.mNextStep = nil;
TutorialStep7Lvl_1.mFoxAnimation = "FoxGirl";

--------------------------------
function TutorialStep7Lvl_1:destroy()
	TutorialStep7Lvl_1:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end