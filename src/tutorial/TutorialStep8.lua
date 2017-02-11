require "src/tutorial/TutorialStepBase"

TutorialStep8 =  inheritsFrom(TutorialStepBase)
TutorialStep8.mCCBFileName = "Step8";
TutorialStep8.mTriggers = nil;
TutorialStep8.mPlayer = nil;
TutorialStep8.mCurrentFingerTime = nil;
TutorialStep8.mFingerFinishPosition = nil;
TutorialStep8.mAcross = nil;
TutorialStep8.FREE_TIME = 2.0;

--------------------------------
function TutorialStep8:init(gameScene, field, tutorialManager)
	TutorialStep8:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	--self:foxAnimation();
	self.mTriggers = self.mField:getObjectsByTag(FactoryObject.FINISH_TAG);

	self:initFinger(gameScene, field);
	self:findPlayer();
end

--------------------------------
function TutorialStep8:onBeginAnimationFinished()
	info_log("TutorialStep8:onBeginAnimationFinished");
	self.mCurrentFingerTime = TutorialStep8.FREE_TIME;
end

--------------------------------
function TutorialStep8:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStep8:getDistanceToBorder(posIn, delta)
	local pos = Vector.new(posIn.x, posIn.y);
    local newPos = Vector.new(pos.x + delta, pos.y);
    while self.mField:isFreePoint( newPos ) do
        pos = newPos;
        newPos = Vector.new(pos.x + delta, pos.y);
    end
    return math.abs(newPos.x - posIn.x);
end

--------------------------------
function TutorialStep8:findAcrossFinish()
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
function TutorialStep8:findPlayer()
	local across = self:findAcrossFinish();
	info_log("TutorialStep8:findPlayer across ", across)
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
function TutorialStep8:getNextStep()
	return "TutorialStep7_1";
end

--------------------------------
function TutorialStep8:checkFinish()
	if self.mAcross then
		return;
	end
	for i, trigger in ipairs(self.mTriggers) do
		if trigger:getContainedObj() == self.mPlayer  then
			self.mIsFinished = true;
			return;
		end
	end
end

--------------------------------
function TutorialStep8:findFingerPosition()
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
function TutorialStep8:tick(dt)
	TutorialStep8:superClass().tick(self, dt);

	if self.mField:getState() ~= Field.IN_GAME then
		return;
	end
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