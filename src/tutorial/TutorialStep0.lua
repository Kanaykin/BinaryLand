require "src/tutorial/TutorialStepBase"
require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep0 =  inheritsFrom(TutorialStepTextBase)

TutorialStep0.mCCBFileName = "Step0";
TutorialStep0.mNextStep = "TutorialStep1";
TutorialStep0.mFoxAnimation = "FoxGirl";

