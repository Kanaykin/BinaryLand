require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"
require "src/algorithms/WavePathFinder"

TutorialStep9_free =  inheritsFrom(TutorialStepBase)

TutorialStep9_free.mCCBFileName = "Step5_1";
TutorialStep9_free.mNextStep = "TutorialStep8";
TutorialStep9_free.mFoxAnimation = "Fox";

TutorialStep9_free.FREE_TIME = 2.0;
TutorialStep9_free.mCurrentFingerTime = 0;
TutorialStep9_free.mTriggers = nil;
TutorialStep9_free.mPlayer = nil;
TutorialStep9_free.mFingerFinishPosition = nil;
TutorialStep9_free.mTriggerTags = {FactoryObject.TUTORIAL_TRIGGER_10, FactoryObject.TUTORIAL_TRIGGER_13};

--------------------------------
function TutorialStep9_free:init(gameScene, field, tutorialManager)
	TutorialStep9_free:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	self.mPlayer = self.mField:getPlayerObjects()[1];
	self:initFinger(gameScene, field);

	self.mTriggers = {} 
    for i, tag in ipairs(TutorialStep9_free.mTriggerTags) do
    	self.mTriggers[i] = self.mField:getObjectsByTag(tag)[1];
    end

end

--------------------------------
function TutorialStep9_free:getNextStep()
	return nil;
end

--------------------------------
function TutorialStep9_free:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStep9_free:findPlayer()
	local across = self:findAcrossFinish();
	info_log("TutorialStep9_free:findPlayer across ", across)
	if not across then
		for i, trigger in ipairs(self.mTriggers) do
			if trigger:getContainedObj() ~= nil then
				self.mPlayer = trigger:getContainedObj() == self.mField:getPlayerObjects()[1] and
					self.mField:getPlayerObjects()[2] or self.mField:getPlayerObjects()[1];
			end
		end
	end
	self.mPlayer = self.mPlayer and self.mPlayer or self.mField:getPlayerObjects()[2];
	info_log("TutorialStep8:findPlayer self.mPlayer ", self.mPlayer);
	return across;
end

--------------------------------
function TutorialStep9_free:getDistanceToBorder(posIn, delta)
	local pos = Vector.new(posIn.x, posIn.y);
    local newPos = Vector.new(pos.x + delta, pos.y);
    while self.mField:isFreePoint( newPos ) do
        pos = newPos;
        newPos = Vector.new(pos.x + delta, pos.y);
    end
    return math.abs(newPos.x - posIn.x);
end

--------------------------------
function TutorialStep9_free:checkFinish()
	if self.mField:getState() == Field.WIN then
		self.mIsFinished = true;

		local finishTriggers = self.mField:getObjectsByTag(FactoryObject.FINISH_TAG);
    	for i, trigger in ipairs(finishTriggers) do
    		trigger:hideBacklight();
    	end
	end

	-- if self.mAcross then
	-- 	return;
	-- end
	-- self.mIsFinished = true;
	-- for i, trigger in ipairs(self.mTriggers) do
	-- 	if trigger:getContainedObj() == nil  then
	-- 		self.mIsFinished = false;
	-- 		return;
	-- 	end
	-- end
end

--------------------------------
function TutorialStep9_free:findAcrossFinish()
	local triggerPos = self.mTriggers[1]:getGridPosition();

	local pos1 = self.mField:getPlayerObjects()[1]:getGridPosition();
	local pos2 = self.mField:getPlayerObjects()[2]:getGridPosition();

	self.mAcross = false;
	if pos2.y == triggerPos.y and
		pos1.y == triggerPos.y then
		self.mAcross = true;
		local deltaLeft1 = self:getDistanceToBorder(pos1, -1);
		local deltaLeft2 = self:getDistanceToBorder(pos2, -1);
		local deltaRight1 = self:getDistanceToBorder(pos1, 1);
		local deltaRight2 = self:getDistanceToBorder(pos2, 1);
		debug_log("deltaLeft1 ", deltaLeft1);
		debug_log("deltaLeft2 ", deltaLeft2);
		debug_log("deltaRight1 ", deltaRight1);
		debug_log("deltaRight2 ", deltaRight2);
		local maxDelta = 999999;
		local delta1 = math.abs(deltaRight1 - deltaLeft1);
		local delta2 = math.abs(deltaRight2 - deltaLeft2);

		if delta1 == delta2 and pos1.x ~= pos2.x then
			return false;
		end
		if maxDelta > delta1 then
			maxDelta = delta1;
			self.mPlayer = self.mField:getPlayerObjects()[1];
			local dir = (deltaRight2 - deltaLeft2);
			dir = dir / math.abs(dir);
			if dir > 0 then
				self.mFingerFinishPosition = Vector.new(pos1.x + deltaRight1 - 1, pos1.y);
			else
				self.mFingerFinishPosition = Vector.new(pos1.x - deltaLeft1 + 1, pos1.y);
			end
		end
		if maxDelta > delta2 then
			maxDelta = delta2;
			self.mPlayer = self.mField:getPlayerObjects()[2];
			local dir = (deltaRight1 - deltaLeft1);
			dir = dir / math.abs(dir);
			if dir > 0 then
				self.mFingerFinishPosition = Vector.new(pos2.x + deltaRight2 - 1, pos1.y);
			else
				self.mFingerFinishPosition = Vector.new(pos2.x - deltaLeft2 + 1, pos1.y);
			end
		end
		
		self.mFingerFinishPosition = self.mField:gridPosToReal(self.mFingerFinishPosition);
		self.mFingerFinishPosition.x = self.mFingerFinishPosition.x + self.mField:getCellSize() / 2;
		self.mFingerFinishPosition.y = self.mFingerFinishPosition.y + self.mField:getCellSize() / 2;
		return true;
	end
	return false;
end

--------------------------------
function TutorialStep9_free:findFingerPosition()

	info_log("TutorialStep9_free:findFingerPosition");

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
	local finishPosition = #path > 1 and path[2] or path[1];
	finishPosition = self.mField:gridPosToReal(finishPosition);
	finishPosition.x = finishPosition.x + self.mField:getCellSize() / 2;
	finishPosition.y = finishPosition.y + self.mField:getCellSize() / 2;

	return self:getPlayerPosImpl(self.mPlayer), finishPosition;
end

--------------------------------
function TutorialStep9_free:findFingerPosition()
	info_log("TutorialStep8:findFingerPosition");

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
function TutorialStep9_free:tick(dt)
	TutorialStep9_free:superClass().tick(self, dt);

	self.mFinger:tick(dt);
	self:checkFinish();

	if self.mCurrentFingerTime ~= nil then
  		--info_log("TutorialStep1:tick ContainedObj ", self.mTrigger:getContainedObj())

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() and not self.mPlayer:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then
            local across = self:findPlayer();
            if not across then
            	self:findFingerPosition();
            end
			self.mFinger:move(self:getPlayerPos(), self.mFingerFinishPosition);
		end
	end
end