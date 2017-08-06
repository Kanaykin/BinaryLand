require "src/base/Inheritance"
require "src/tutorial/TutorialStep0"
require "src/tutorial/TutorialStep1"
require "src/tutorial/TutorialStep1_1"
require "src/tutorial/TutorialStep1_2"
require "src/tutorial/TutorialStep1_3"
require "src/tutorial/TutorialStep1_4"
require "src/tutorial/TutorialStep1_5"
require "src/tutorial/TutorialStep2"
require "src/tutorial/TutorialStep3"
require "src/tutorial/TutorialStep3_1"
require "src/tutorial/TutorialStep3_2"
require "src/tutorial/TutorialStep4"
require "src/tutorial/TutorialStep4_1"
require "src/tutorial/TutorialStep5"
require "src/tutorial/TutorialStep5_1"
require "src/tutorial/TutorialStep5_2"
require "src/tutorial/TutorialStep6"
require "src/tutorial/TutorialStep7"
require "src/tutorial/TutorialStep7_free"
require "src/tutorial/TutorialStep7_1"
require "src/tutorial/TutorialStep8"
require "src/tutorial/TutorialStep8_1"
require "src/tutorial/TutorialStep8_2"
require "src/tutorial/TutorialStep8_3"
require "src/tutorial/TutorialStep8_4"
require "src/tutorial/TutorialStep9"
require "src/tutorial/TutorialStep9_free"
require "src/tutorial/TutorialStep9_1"
require "src/tutorial/TutorialStep9_2"
require "src/tutorial/TutorialStep9_3"

require "src/tutorial/TutorialStep2Lvl_1"
require "src/tutorial/TutorialStep2Lvl_2"
require "src/tutorial/TutorialStep2Lvl_3"
require "src/tutorial/TutorialStep3Lvl_1"
require "src/tutorial/TutorialStep4Lvl_1"
require "src/tutorial/TutorialStep4Lvl_2"
require "src/tutorial/TutorialStep5Lvl_1"
require "src/tutorial/TutorialStep7Lvl_1"
require "src/tutorial/TutorialStep9Lvl_1"
require "src/base/Log"

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
function TutorialManager:destroy()
	if self.mCurrentStep then
		self.mCurrentStep:destroy();
	end
end

--------------------------------
function TutorialManager:init(gameScene, field, mainUi, tutorialStep)
	info_log("TutorialManager:init()");
	self.mField = field;
	self.mGameScene = gameScene;
	self.mMainUi = mainUi;

	self.mCurrentStep = _G[tutorialStep]:create();
	self.mCurrentStep:init(gameScene, self.mField, self);
end

--------------------------------
function TutorialManager:tick(dt)
	if self.mCurrentStep == nil then
		return
	end
	self.mCurrentStep:tick(dt);

	if self.mCurrentStep:finished() then
		local nextStepNext = self.mCurrentStep:getNextStep();
		info_log("TutorialManager:tick ", nextStepNext);
		self.mCurrentStep:destroy();
		self.mCurrentStep = nil;
		if nextStepNext and _G[nextStepNext] then
	        info_log("TutorialManager:tick nextStepNext ", nextStepNext);
			self.mCurrentStep = _G[nextStepNext]:create();
			info_log("TutorialManager:tick nextStepNext ", nextStepNext);
			self.mCurrentStep:init(self.mGameScene, self.mField, self);
		end
	end
end

