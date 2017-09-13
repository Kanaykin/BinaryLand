require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep3Lvl_1 =  inheritsFrom(TutorialStepTextBase)

TutorialStep3Lvl_1.mCCBFileName = "Step3Lvl_1";
TutorialStep3Lvl_1.mNextStep = nil;
TutorialStep3Lvl_1.mFoxAnimation = "FoxGirl";

--------------------------------
function TutorialStep3Lvl_1:destroy()
	TutorialStep3Lvl_1:superClass().destroy(self);
	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);
end