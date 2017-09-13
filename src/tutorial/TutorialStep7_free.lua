require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"
require "src/algorithms/WavePathFinder"

TutorialStep7_free =  inheritsFrom(TutorialStepBase)

TutorialStep7_free.mCCBFileName = "Step5_1";
TutorialStep7_free.mNextStep = nil;
TutorialStep7_free.mFoxAnimation = "Fox";

TutorialStep7_free.FREE_TIME = 2.0;
TutorialStep7_free.mCurrentFingerTime = 0;
TutorialStep7_free.mPlayers = nil;

--------------------------------
function TutorialStep7_free:init(gameScene, field, tutorialManager)
	TutorialStep7_free:superClass().init(self, gameScene, field, tutorialManager, self.mCCBFileName);

	self.mNextStep = "TutorialStep9";

	self.mTutorialManager:getMainUI():getJoystick():clearBlockedButtons();

	self.mPlayer = self.mField:getPlayerObjects()[2];
	self.mPlayers = self.mField:getPlayerObjects();
	self:initFinger(gameScene, field);
end

--------------------------------
function TutorialStep7_free:getNextStep()
	info_log("TutorialStep7_free:getNextStep ", self.mNextStep);
	return self.mNextStep;
end

--------------------------------
function TutorialStep7_free:onTouchHandler()
	self.mCurrentFingerTime = 0;
	self.mFinger:stop();
end

--------------------------------
function TutorialStep7_free:findFingerPositionToCoins(coins)
	local triggerPos = coins:getGridPosition();

	local finishPosition = nil;
	local minDist = 9999999;
	local minDistPlayer = nil;
	for i, player in ipairs(self.mPlayers) do
		local cloneArray = self.mField:cloneArray();
		local path = WavePathFinder.buildPath(player:getGridPosition(), triggerPos, cloneArray, self.mField.mSize);
    	path = WavePathFinder.normalizePath(path);
    	--WavePathFinder.printPath(path);
		
		local dist = WavePathFinder.lengthPath(path);
		info_log("TutorialStep7_free:findFingerPosition dist i ", i, " dist ", dist);
		if minDist > dist then
			finishPosition = #path > 1 and path[2] or path[1];
			minDist = dist;
			minDistPlayer = player;
		end
	end

	finishPosition = self.mField:gridPosToReal(finishPosition);
	finishPosition.x = finishPosition.x + self.mField:getCellSize() / 2;
	finishPosition.y = finishPosition.y + self.mField:getCellSize() / 2;

	return self:getPlayerPosImpl(minDistPlayer), finishPosition;
end

--------------------------------
function TutorialStep7_free:checkFinish()
	--info_log("TutorialStep7_free:checkFinish ");
	local coins = self.mField:getObjectsByTag(FactoryObject.BONUS_TAG);
	if type(coins) ~= "table" or #coins == 0 then
		self.mIsFinished = true;
	end

	--------------------------------
	if self.mField:getState() == Field.WIN then
		self.mIsFinished = true;
		self.mNextStep = nil;
		--info_log("TutorialStep7_free:checkFinish self.mNextStep ", self.mNextStep);
	end

end

--------------------------------
function TutorialStep7_free:findFingerPosition()
	info_log("TutorialStep7_free:findFingerPosition ");

	local coins = self.mField:getObjectsByTag(FactoryObject.BONUS_TAG);
	if type(coins) == "table" and #coins > 0 then
		local coin = coins[1];
		info_log("TutorialStep7_free:findFingerPosition coin ", coin);
		return self:findFingerPositionToCoins(coin);
	end

	self.mIsFinished = true;
	return nil, nil;
end

--------------------------------
function TutorialStep7_free:tick(dt)
	info_log("TutorialStep7_free:tick ");
	TutorialStep7_free:superClass().tick(self, dt);

	self.mFinger:tick(dt);
	self:checkFinish();

	if self.mCurrentFingerTime ~= nil then
  		--info_log("TutorialStep1:tick ContainedObj ", self.mTrigger:getContainedObj())

		self.mCurrentFingerTime = self.mCurrentFingerTime + dt;

		if self.mCurrentFingerTime > self.FREE_TIME and not self.mFinger:IsMoving() and not self.mPlayer:IsMoving()
            and self.mField:getState() ~= Field.PAUSE then

            local playerPos, finishPos = self:findFingerPosition();
            if playerPos and finishPos then
				self.mFinger:move(playerPos, finishPos);
			end
		end
	end
end
