require "src/tutorial/TutorialStepBase"
require "src/algorithms/WavePathFinder"

TutorialStepPath =  inheritsFrom(TutorialStepBase)
TutorialStepPath.mCCBFileName = "Step5_1";
TutorialStepPath.mTriggerTags = {FactoryObject.TUTORIAL_TRIGGER_4, FactoryObject.TUTORIAL_TRIGGER_5};
TutorialStepPath.mTriggers = nil;
TutorialStepPath.mPlayer = nil;
TutorialStepPath.FREE_TIME = 2.0;

TutorialStepPath.mCurrentFingerTime = nil;
TutorialStepPath.mFingerFinishPosition = nil;

--------------------------------
function TutorialStepPath:init(gameScene, field, tutorialManager)
	TutorialStepPath:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	--self:foxBabyAnimation();

	local label = tolua.cast(self.mNode:getChildByTag(TutorialStep1.LABEL_TAG), "cc.Label");
    if label then
        setDefaultFont(label, field.mGame:getScale());
    end
    self.mTriggers = {} 
    for i, tag in ipairs(self.mTriggerTags) do
    	self.mTriggers[i] = self.mField:getObjectsByTag(tag)[1];
    end

	self.mPlayer = self.mField:getPlayerObjects()[2];
	self:initFinger(gameScene, field);

end

--------------------------------
function TutorialStepPath:getNextStep()
	return "TutorialStep6";
end

--------------------------------
function TutorialStepPath:onBeginAnimationFinished()
	info_log("TutorialStepPath:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStepPath.FREE_TIME;
end

--------------------------------
function TutorialStepPath:findFingerPosition()
	info_log("TutorialStepPath:findFingerPosition");

	-- find nearest trigger
	local triggerNear = nil;
	local dist = 999999999;
	for i, trigger in ipairs(self.mTriggers) do
		local playerPos = self.mPlayer:getGridPosition();
		local triggerPos = trigger:getGridPosition();
		local newDist = (playerPos - triggerPos):len();
		if newDist < dist then
			dist = newDist;
			triggerNear = trigger;
		end
	end
	--triggerNear = self.mTriggers[2];

	local cloneArray = self.mField:cloneArray();
    local path = WavePathFinder.buildPath(self.mPlayer:getGridPosition(), triggerNear:getGridPosition(), cloneArray, self.mField.mSize);
    path = WavePathFinder.normalizePath(path);
    WavePathFinder.printPath(path);
	self.mFingerFinishPosition = #path > 1 and path[2] or path[1];
	self.mFingerFinishPosition = self.mField:gridPosToReal(self.mFingerFinishPosition);
	self.mFingerFinishPosition.x = self.mFingerFinishPosition.x + self.mField:getCellSize() / 2;
	self.mFingerFinishPosition.y = self.mFingerFinishPosition.y + self.mField:getCellSize() / 2;
end

--------------------------------
function TutorialStepPath:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStepPath:tick(dt)
	TutorialStepPath:superClass().tick(self, dt);

	self.mFinger:tick(dt);

	for i, trigger in ipairs(self.mTriggers) do
		if trigger:getContainedObj() ~= nil then
			info_log("TutorialStep5:tick FINISH Step");
			self.mIsFinished = true;
		end
	end

	if self.mCurrentFingerTime ~= nil then
  		--info_log("TutorialStep1:tick ContainedObj ", self.mTrigger:getContainedObj())

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() and not self.mPlayer:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then
            self:findFingerPosition();
			self.mFinger:move(self:getPlayerPos(), self.mFingerFinishPosition);
		end
	end
end