require "src/tutorial/TutorialStep1"
require "src/base/Log"

TutorialStep5 =  inheritsFrom(TutorialStep1)
TutorialStep5.mCCBFileName = "Step5";
TutorialStep5.mFinishPosition = Vector.new(9, 6);
TutorialStep5.mTriggerTag = FactoryObject.TUTORIAL_TRIGGER_3;
TutorialStep5.mPlayerIndex = 2;

--------------------------------
function TutorialStep5:init(gameScene, field, tutorialManager)
	TutorialStep5:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.TOP);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.RIGHT);
	self.mTutorialManager:getMainUI():getJoystick():addBlockedButton(Joystick.BUTTONS.BOTTOM);
end

--------------------------------
function TutorialStep5:getNextStep()
	return "TutorialStep6";
end

--------------------------------
function TutorialStep5:tick(dt)
	self.mFinger:tick(dt);

	if self.mCurrentFingerTime ~= nil then
		-- check finished
		--info_log("self.mField:getState() ", self.mField:getState());
		if --[[self.mTrigger:getContainedObj() ~= nil]] self.mField:getState() == Field.WIN then
			info_log("TutorialStep1:tick FINISH Step");
			self.mIsFinished = true;
		end

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() and self.mField:getState() ~= Field.PAUSE then
			self.mFinger:move(self:getPlayerPos(), self.mFinishPosition);
		end
	end
end