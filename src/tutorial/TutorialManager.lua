require "src/base/Inheritance"
require "src/tutorial/TutorialStep1"
require "src/tutorial/TutorialStep2"
require "src/tutorial/TutorialStep3"
require "src/tutorial/TutorialStep4"
require "src/tutorial/TutorialStep5"
require "src/tutorial/TutorialStep6"

TutorialManager =  inheritsFrom(nil)
TutorialManager.mCurrentStep = nil;
TutorialManager.mField = nil;
TutorialManager.mGameScene = nil;
TutorialManager.mMainUi = nil;

--------------------------------
function TutorialManager:getMainUI()
	return self.mMainUi;
end

--------------------------------
function TutorialManager:init(gameScene, field, mainUi)
	print("TutorialManager:init()");
	self.mField = field;
	self.mGameScene = gameScene;
	self.mMainUi = mainUi;

	self.mCurrentStep = TutorialStep1:create();
	self.mCurrentStep:init(gameScene, self.mField, self);
end

--------------------------------
function TutorialManager:tick(dt)
	self.mCurrentStep:tick(dt);

	if self.mCurrentStep:finished() then
		local nextStepNext = self.mCurrentStep:getNextStep();
        print("TutorialManager:tick nextStepNext ", nextStepNext);
		self.mCurrentStep:destroy();
		self.mCurrentStep = _G[nextStepNext]:create();
		print("TutorialManager:tick nextStepNext ", nextStepNext);
		self.mCurrentStep:init(self.mGameScene, self.mField, self);
	end
end

