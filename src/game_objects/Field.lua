require "src/base/Inheritance"
require "src/math/Vector"
require "src/game_objects/FieldNode"
require "src/game_objects/FactoryObject"
require "src/base/Log"

Field = inheritsFrom(nil)
Field.mArray = nil;
Field.mPlayerFreeArray = nil;
Field.mSize = nil;
Field.mFieldNode = nil;
Field.mEnemyObjects = nil;
Field.mFinishTrigger = nil;
Field.mGame = nil;
Field.mTime = nil;
Field.mScore = nil;
Field.mMainUi = nil;
Field.mBonusLevel = nil;
Field.mBonusLevelFile = nil;
Field.mIsBonusLevel = nil;
Field.mIsTutorialLevel = nil;
Field.mObjectsById = nil;
Field.mBrickObjects = nil;

Field.mPlayerObjects = nil;

-- #FIXME: 
local MAX_NUMBER = math.huge;
local MIN_NUMBER = -math.huge;

Field.mObjects = nil;
Field.mNeedDestroyObjects = nil;
Field.mFreePoints = nil;
Field.mCellSize = nil;
Field.mState = nil;
Field.mStateListener = nil;
Field.mId = nil;
Field.mCustomProperties = nil;
Field.mEnemyEnterTriggerListener = nil;

Field.mLevelStatistic = nil;

-- smooth camera moving
Field.mMaxScroll = 5;
Field.mPlayerPosY = nil;

-- states
Field.PAUSE = 1;
Field.IN_GAME = 2;
Field.WIN = 3;
Field.LOSE = 4;

--------------------------------
function COORD(x, y, width)
	return x + 1 + y * (width + 1);
end

--------------------------------
function PRINT_FIELD(array, size)
	info_log("PRINT_FIELD !");
	for j = 0, size.y do
		local raw = "";
		for i = 0, size.x do
			--debug_log("COORD ", COORD(i, j, size.x), " i ", i, " j ", j)
			raw = raw .. tostring(array[COORD(i, j, size.x)]) .. " ";
		end
		info_log(raw);
	end
end

---------------------------------
function Field:getState()
	return self.mState;
end

---------------------------------
function Field:destroy()
    debug_log("Field:destroy")
	for i, obj in ipairs(self.mObjects) do
		obj:destroy();
	end
end

--------------------------------
function Field:setMainUi(mainUi)
    self.mMainUi = mainUi;
end

--------------------------------
function Field:getMainUi()
    return self.mMainUi;
end
--------------------------------
function Field:getObjectsByTag(tag)
    local result = {};
	for _, obj in ipairs(self.mObjects) do
		info_log("Field:getObjectsByTag tag ", obj:getTag())
		if obj:getTag() == tag then
			table.insert(result, obj);
		end
	end
	return result
end

--------------------------------
function Field:setStateListener(listener)
	self.mStateListener = listener;
end

--------------------------------
function Field:getCellSize()
	return self.mCellSize;
end

--------------------------------
function Field:getFreePoints()
	return self.mFreePoints;
end

--------------------------------
function Field:printField()
	PRINT_FIELD(self.mArray, self.mSize);
end

--------------------------------
function Field:getSize()
    return self.mSize;
end

--------------------------------
function Field:cloneArray()
	PRINT_FIELD(self.mArray, self.mSize);
	local cloneArr = {};
	for i, val in pairs(self.mArray) do
		--print ("i ", i, "val ", val);
		cloneArr[i] = val;
	end
	PRINT_FIELD(cloneArr, self.mSize);
	return cloneArr;
end

--------------------------------
function Field:isBrick(brick)
	return brick:getTag() == FactoryObject.BRICK_TAG;
end

---------------------------------
function Field:fieldToScreen(pos)
	local scrollPos = self.mFieldNode:getScrollPos();
	return pos + scrollPos;
end

---------------------------------
function Field:setScrollPos(scrollPosY, playerDir)
    local scrollPos = self.mFieldNode:getScrollPos();
    scrollPos = Vector.new(scrollPos.x, -scrollPos.y);
    debug_log("Field:setScrollPos ", scrollPosY);
    debug_log("scrollPos ", scrollPos.y);

    local len = math.abs(scrollPosY - scrollPos.y);
    debug_log("len ", len);

    if len > 0 then
        local dir = (scrollPosY - scrollPos.y) / len;

        debug_log(" Field:setScrollPos dir ", dir);
        debug_log(" Field:setScrollPos playerDir ", playerDir);

        if dir * playerDir < 0 then
            if self.mMaxScroll < len then
                self.mFieldNode:setScrollPos(Vector.new(0, scrollPos.y + self.mMaxScroll * dir));
            else
                self.mFieldNode:setScrollPos(Vector.new(0, scrollPosY));
            end
        end
    end
end

---------------------------------
function Field:updateScrollPos()
	local min = math.huge;
	local max = -math.huge;
    local equal = true;
    local forceUpdate = false;

    local dir = 0;
    local yMax = -math.huge;

	for i, val in ipairs(self.mPlayerObjects) do
        local x, y = val.mNode:getPosition();
        --debug_log("Field:updateScrollPos x ", x, " y ", y)
        if not val:isInTrap() then
            min = math.min(min, y);
            max = math.max(max, y);
        end
        if self.mPlayerPosY[i] ~= y then
            equal = false;
        end

        if not self.mPlayerPosY[i] then
        	forceUpdate = true;
        end

        if self.mPlayerPosY[i] and yMax < math.abs(self.mPlayerPosY[i] - y) then
            yMax = math.abs(self.mPlayerPosY[i] - y);
            --debug_log ("Field:updateScrollPos yMax ", yMax);
            --debug_log ("Field:updateScrollPos self.mPlayerPosY[i] ", self.mPlayerPosY[i]);
            --debug_log ("Field:updateScrollPos y ", y);
            dir = (self.mPlayerPosY[i] - y) / yMax;
        end
        self.mPlayerPosY[i] = y;
	end

    if equal then
        return;
    end

	--debug_log ("Field:updateScrollPos forceUpdate ", forceUpdate);
    if min ~= math.huge and max ~= -math.huge then
        local visibleSize = CCDirector:getInstance():getVisibleSize();
        local pos = (max - min) / 2 + min - visibleSize.height / 2;-- max - visibleSize.height / 2;
        pos = math.max(pos, 0);

        --print ("Field:updateScrollPos ", pos);
        if forceUpdate then
        	self.mFieldNode:setScrollPos(Vector.new(0, pos));
        else
        	--self:smoothCameraMove(Vector.new(0, pos));
        	self:setScrollPos(pos, dir);
        end
    end
end

---------------------------------
function Field:checkFinishGame()
	if self.mState ~= Field.IN_GAME then
		return;
	end

    -- check bonus room without finish trigger
    -- exit from door
    if self.mIsBonusLevel and #self.mFinishTrigger == 0 then
        return
    end

	-- check win game
	local allObjectInTrigger = true;
	for _, trigger in ipairs(self.mFinishTrigger) do
		local obj = trigger:getContainedObj();
        if not obj or PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP == obj:getLastButtonPressed() then
			allObjectInTrigger = false;
		end
	end
	
	if allObjectInTrigger then
		info_log("Field:checkFinishGame WIN");
		self:onStateWin()
		return;
	end

	-- check game over
	local allObjectInTrap = true;
	for _, object in ipairs(self.mPlayerObjects) do
		--debug_log("isInTrap ", object:isInTrap());
		if not object:isInTrap() then
			allObjectInTrap = false;
		end
	end

	if allObjectInTrap or (self.mTime and self.mTime <= 0) then
		info_log("Field:checkFinishGame LOSE");
		self:onStateLose();
		return;
	end
end

---------------------------------
function Field:onStateLose()
	self.mState = Field.LOSE;
	info_log("LOSE !!!");
	if self.mStateListener then
        if self.mIsBonusLevel then
            self.mStateListener:onStateWin();
        else
            self.mStateListener:onStateLose();
        end
	end
end

---------------------------------
function Field:restore(data)
    info_log("Field:restore ");
    if not data.field then
        info_log("Invalid field data");
        return;
    end
    self.mTime = data.field.time;
    self.mScore = data.field.score;
    info_log("Field:restore objects ", data.field.objects);
    for id, objectData in pairs(data.field.objects) do
        local object = self:getObjectById(id);
        info_log("Field:restore id ", id, " object ", object);
        if object then
            object:restore(objectData);
        end
    end
    -- remove object
    for _, object in ipairs(self.mObjects) do
        local id = object:getId();
        if id and not data.field.objects[id] then
            self:delayDelete(object);
        end
    end

end

---------------------------------
function Field:store(data)
    data.field = {}
    data.field.time = self.mTime;
    data.field.score = self.mScore;
    -- store objects
    data.field.objects = {}
    for _, object in ipairs(self.mObjects) do
        local storedData = {}
        info_log("Field:store obj ", object:getId());
        if object:store(storedData) then
            data.field.objects[object:getId()] = storedData;
        end
    end
end

---------------------------------
function Field:onEnterBonusRoomDoor(player, pos, trigger)
    info_log("Field:onEnterBonusRoomDoor ", player, " pos ", pos, " trigger ", trigger);
    player:onEnterBonusRoomDoor();
    if self.mStateListener then
        self.mStateListener:onEnterBonusRoomDoor(player:isFemale(), trigger:getBonusFile());
    end
    info_log("Field:onEnterBonusRoomDoor end");
end

---------------------------------
function Field:addCoinsObject(object)
    self.mLevelStatistic.startCountCoins = self.mLevelStatistic.startCountCoins and self.mLevelStatistic.startCountCoins + 1 or 1;
    self:addObject(object);
end

---------------------------------
function Field:computeStars()
    local trapStar = self.mLevelStatistic.enterTrap and 0 or 1;

    local timeStar = 3;
    if self.mTime then
        local time = (self.mLevelStatistic.startTimeLevel - self.mTime) / self.mLevelStatistic.startTimeLevel;
        debug_log("Field:computeStars ", time)

        timeStar = 0;
        if time <= 1.0 / 3.0 then
            timeStar = 3;
        elseif time <= 1.0 / 2.0 then
            timeStar = 2;
        elseif time <= 2.0 / 3.0 then
            timeStar = 1;
        end
    end
    local coinsStar = self.mLevelStatistic.startCountCoins == self.mLevelStatistic.countCoins and 1 or 0;
    debug_log("Field:computeStars startCountCoins ", self.mLevelStatistic.startCountCoins)
    debug_log("Field:computeStars trapStar ", trapStar)
    debug_log("Field:computeStars timeStar ", timeStar)
    debug_log("Field:computeStars coinsStar ", coinsStar)
    return {trapStar = trapStar,
    timeStar = timeStar,
    coinsStar = coinsStar,
    allStar = trapStar + timeStar + coinsStar}
end

---------------------------------
function Field:onStateWin()

    --self.mLevelStatistic.countCoins
    --self.mLevelStatistic.enterTrap
    --self.mLevelStatistic.startTimeLevel
    debug_log("Field:onStateWin countCoins ", self.mLevelStatistic.countCoins);
    debug_log("Field:onStateWin enterTrap ", self.mLevelStatistic.enterTrap);
    debug_log("Field:onStateWin startTimeLevel ", self.mLevelStatistic.startTimeLevel);

    local stars = self:computeStars();

	self.mState = Field.WIN;
	info_log("WIN !!! ", self.mBonusLevelFile);
	if self.mStateListener then
        --check bonus level
        if self.mBonusLevel or self.mBonusLevelFile then
            self.mStateListener:onStateBonusStart();
        else
            self.mStateListener:onStateWin(stars);
        end
	end

	for _, object in ipairs(self.mObjects) do
		object:onStateWin();
	end
end

---------------------------------
function Field:onStatePause()
	self.mState = Field.PAUSE;
	info_log("PAUSE !!!");
    for i, obj in ipairs(self.mObjects) do
        obj:onStatePause();
    end
end

---------------------------------
function Field:onStateInGame()
	self.mState = Field.IN_GAME;
	info_log("IN GAME !!!");
    for i, obj in ipairs(self.mObjects) do
        obj:onStateInGame();
    end
end

---------------------------------
function Field:updateState()
	if self.mState ~= Field.PAUSE and self.mState ~= Field.IN_GAME then
		return;
	end
	--debug_log("self.mGame.mDialogManager:hasModalDlg() ", self.mGame.mDialogManager:hasModalDlg());
	if self.mState == Field.IN_GAME and self.mGame.mDialogManager:hasModalDlg() then
		self:onStatePause();
	elseif self.mState == Field.PAUSE and not self.mGame.mDialogManager:hasModalDlg() then
		self:onStateInGame();
	end
end

---------------------------------
function Field:tick(dt)
	self:updateState();

    --debug_log("Field:tick self.mId ", self.mId);
    for i, obj in ipairs(self.mNeedDestroyObjects) do
        self:removeObject(obj);
        self:removeEnemy(obj);
        obj:destroy();
    end
    self.mNeedDestroyObjects = {}

    --self:updateCameraMove(dt);

	if self.mState == Field.IN_GAME then
        if self.mTime then
            self.mTime = self.mTime - dt;
        end
    end

    for i, obj in ipairs(self.mBrickObjects) do
        obj:tick(dt);
    end

    if self.mState ~= Field.PAUSE then
		for i, obj in ipairs(self.mObjects) do
			obj:tick(dt);
		end

        --debug_log("Field:tick count objects ", #self.mObjects);

		self:updateScrollPos();
		self:checkFinishGame();
	end
end

--------------------------------
function Field:fillFreePoint(gridPos, points)
    local cloneArray = self:cloneArray();
    WavePathFinder.fillArray({gridPos}, Vector.new(-1, -1), cloneArray, self.mSize,
        WavePathFinder.FIRST_INDEX + 1);

    local p = cloneArray[COORD(16, 5, self.mSize.x)];
    info_log("££££££ ", p)
    PRINT_FIELD(cloneArray, self.mSize);

    for j = 0, self.mSize.y do
        for i = 0, self.mSize.x do
            if cloneArray[COORD(i, j, self.mSize.x)] > 1 then
                table.insert(points, Vector.new(i, j));
            end
        end
    end
end

--------------------------------
function Field:gridPosToReal(posDest)
	local x = (posDest.x - 1) * self.mCellSize + self.mLeftBottom.x;
	local y = (posDest.y - 1) * self.mCellSize + self.mLeftBottom.y;
	return Vector.new(x, y);
end

--------------------------------
function Field:getPlayerObjects()
	return self.mPlayerObjects;
end

--------------------------------
function Field:findArrayIndex(array, object)
	local index = nil;
	for i, val in ipairs(array) do
		if val == object then
			index = i;
			break;
		end
	end
	return index;
end

--------------------------------
function Field:removeObject(object)
	info_log("Field:removeObject(", object, ")");

    local id = object:getId();
    if id then
        self.mObjectsById[id] = nil;
        info_log("Field:removeObject id ", id);
    end

	local index = self:findArrayIndex(self.mObjects, object);
	if index then
		table.remove(self.mObjects, index);
	end
	info_log("Field:removeObject ", index);
end

--------------------------------
function Field:removeEnemy(enemy)
	info_log("Field:removeEnemy(", enemy, ")");
	local index = self:findArrayIndex(self.mEnemyObjects, enemy);
	if index then
		table.remove(self.mEnemyObjects, index);
	end
	info_log("Field:removeEnemy ", index);
end

--------------------------------
function Field:createBonus(rect, position, orderPos, bonusVal)
    local texture = cc.Director:getInstance():getTextureCache():addImage("Coin.png");
    info_log("Field:createBonus texture ", texture, " rect ", rect, "bonus ", bonus);
    local sprite = cc.Sprite:createWithTexture(texture, rect);
    self:getFieldNode():addChild(sprite);

    sprite:setAnchorPoint(cc.p(0.5, 0.5));
    sprite:setPosition(cc.p(position.x, position.y));
    local bonus = FactoryObject:createBonusObject(self, sprite);
    bonus:setScore(bonusVal);
    bonus:setOrder(orderPos);
end


--------------------------------
function Field:addScore(score)
    self.mScore = self.mScore + score;
    self.mLevelStatistic.countCoins = self.mLevelStatistic.countCoins and self.mLevelStatistic.countCoins + 1 or 1;
end

--------------------------------
function Field:addTime(score)
    self.mTime = self.mTime + score;
end

--------------------------------
function Field:onEnterBonusTrigger(player)
    info_log("Field:onEnterBonusTrigger ");
--    self.mScore = self.mScore + 100;
    SimpleAudioEngine:getInstance():playEffect(gSounds.BONUS_SOUND);
end

--------------------------------
function Field:addBonus(enemy)
    if enemy.getBonus and enemy.getBonus() then
        local rect = enemy:getBoundingBox();
        local pos = enemy:getPosition();
        local orderPos = enemy:getPrevOrderPos();
        self:createBonus(rect, pos, orderPos - 1, enemy:getBonus());
    end
end

--------------------------------
function Field:addEnemyEnterTriggerListener(listener)
    if self.mEnemyEnterTriggerListener then
        local newListener = ListenerGlue.new(self.mEnemyEnterTriggerListener, listener);
        self.mEnemyEnterTriggerListener = newListener;
    else
        self.mEnemyEnterTriggerListener = listener;
    end
end

--------------------------------
function Field:onEnemyEnterTrigger(enemy)
	info_log("Field:onEnemyEnterTrigger ", enemy);
	SimpleAudioEngine:getInstance():playEffect(gSounds.MOB_DEATH_SOUND)

    enemy:onEnterFightTrigger();
    if self.mEnemyEnterTriggerListener then
        self.mEnemyEnterTriggerListener:onEnemyEnterTrigger(enemy);
    end
end

--------------------------------
function Field:onEnemyLeaveTrigger(enemy)
end

--------------------------------
function Field:getEnemyObjects()
	return self.mEnemyObjects;
end

--------------------------------
function Field:collideObject(player, destPos)
	for _, object in ipairs(self.mPlayerObjects) do
		if player ~= object and object:isInTrap() then
			--check bbox
			local boxl = player:getBoundingBox();
			
			boxl.x = destPos.x-- + boxl.origin.x;
			boxl.y = destPos.y-- + boxl.origin.y;
			-- info_log("Field:collideObject1 x ", boxl.x, " y ", boxl.y);
			-- info_log("Field:collideObject1 size x ", boxl.width, " y ", boxl.height);
			local boxr = object:getBoundingBox();
			-- info_log("Field:collideObject2 x ", boxr.x, " y ", boxr.y);
			-- info_log("Field:collideObject2 size x ", boxr.width, " y ", boxr.height);

			local centerL = Vector.new(boxl.x , boxl.y );
			local centerR = Vector.new(boxr.x , boxr.y );
			local diametr = Vector.distance(centerL, centerR);

            -- if not self.mDebugBox1 then
            --     local nodeBox = cc.DrawNode:create();
            --     self:getFieldNode():addChild(nodeBox);
            --     self.mDebugBox1 = nodeBox;
            -- end
            -- self.mDebugBox1:clear();
            -- self.mDebugBox1:drawCircle(cc.p(centerL.x, centerL.y), boxl.width / 2.0,
            -- 360, 360, false, {r = 1, g = 0, b = 0, a = 1});

            -- if not self.mDebugBox2 then
            --     local nodeBox = cc.DrawNode:create();
            --     self:getFieldNode():addChild(nodeBox);
            --     self.mDebugBox2 = nodeBox;
            -- end
            -- self.mDebugBox2:clear();
            -- self.mDebugBox2:drawCircle(cc.p(centerR.x, centerR.y), boxr.width / 2.0,
            -- 360, 360, false, {r = 1, g = 0, b = 0, a = 1});

			return diametr <= boxr.width * 0.7;
		end
	end
	return false;
end

--------------------------------
function Field:isFreePoint( point )
	return self.mArray[COORD(point.x, point.y, self.mSize.x)] == 0;
end

--------------------------------
function Field:isFreePointForPlayer( point )
    return self.mArray[COORD(point.x, point.y, self.mSize.x)] == 0 or self.mPlayerFreeArray[COORD(point.x, point.y, self.mSize.x)];
end

--------------------------------
function Field:positionToGrid(position)
	local leftBottom = Vector.new(position.x - self.mLeftBottom.x, position.y - self.mLeftBottom.y);
	return math.floor(leftBottom.x / self.mCellSize) + 1, math.floor(leftBottom.y / self.mCellSize) + 1;
end

--------------------------------
function Field:getGridPosition(node)
	local posX, posY = node:getPosition();
	local anchor = cc.p(0, 0);--node:getAnchorPoint();
	local nodeSize = node:getContentSize();
	
	local leftBottom = Vector.new(posX - anchor.x * nodeSize.width, posY - anchor.y * nodeSize.height);
	return self:positionToGrid(leftBottom);
end

--------------------------------
function Field:onPlayerLeaveWeb(player)
	info_log("onPlayerLeaveWeb ");
	player:leaveTrap(nil);
    -- get Spirit and remove it
    local spirit = self:getObjectsByTag(FactoryObject.SPIRIT_TAG)[1];
    debug_log("Field:onPlayerLeaveWeb spirit ", spirit);
    if spirit then
        spirit:onPlayerLeaveWeb(player);
    end
end

--------------------------------
function Field:incEnterTrapCounter()
    if not self.mIsTutorialLevel then
        self.mLevelStatistic.enterTrap = self.mLevelStatistic.enterTrap and self.mLevelStatistic.enterTrap + 1 or 1;
    end
end

--------------------------------
function Field:onPlayerEnterTornadoTrap(player, pos, trigger)
    info_log("onPlayerEnterTornadoTrap trigger ", trigger);
    -- if player is primary then game over
    player:enterTornadoTrap(pos, trigger);
    self:incEnterTrapCounter();
end

--------------------------------
function Field:onPlayerEnterHiddenTrap(player, pos)
    info_log("onPlayerEnterHiddenTrap ");

    local gridPos = Vector.new(self:positionToGrid(pos));
    local dest = self:gridPosToReal(gridPos);
    dest.x= dest.x + self.mCellSize / 2;
    dest.y= dest.y + self.mCellSize / 2;

    -- if player is primary then game over
    player:enterHiddenTrap(dest);
    self:incEnterTrapCounter();
end

--------------------------------
function Field:onPlayerEnterWeb(player, pos)
	info_log("onPlayerEnterWeb ");
	-- if player is primary then game over
	player:enterCage(pos);
    self:incEnterTrapCounter();
end

--------------------------------
function Field:onPlayerEnterMob(player, pos)
	info_log("onPlayerEnterMob ");
	-- if player is primary then game over
	player:enterTrap(nil);
    self:incEnterTrapCounter();
end

--------------------------------
function Field:onPlayerEnterNet(player, pos)
    info_log("Field:onPlayerEnterNet ");
    player:enterNet();
    self:incEnterTrapCounter();
end

--------------------------------
function Field:onPlayerLeaveNet(player)
    self:onPlayerLeaveWeb(player);
end

--------------------------------
function Field:getFieldNode()
	return self.mFieldNode;
end

--------------------------------
function Field:createSpirit(pos, player)
    local node = CCSprite:create("Spirit.png");

    --pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0));
    node:setPosition(pos);
    node:setTag(FactoryObject.SPIRIT_TAG);

    self:getFieldNode():addChild(node);

    local spirit = SpiritObject:create();
    spirit:init(self, node, player);
    self:addObject(spirit);
end

--------------------------------
function Field:createTornadoTrigger(node)
    info_log("Field:createTornadoTrigger");
    local web = SnareTrigger:create();
    local enterCallback = Callback.new(self, Field.onPlayerEnterTornadoTrap);
    local leaveCallback = Callback.new(self, Field.onPlayerLeaveWeb)
    web:init(self, node, enterCallback, leaveCallback);
    table.insert(self.mObjects, web);
    table.insert(self.mEnemyObjects, web);
end

--------------------------------
function Field:createSnareTrigger(pos, fromBullet)
	info_log("Field:createSnareTrigger x= ", pos.x, " y= ", pos.y);
	local node = CCNode:create();
	node:setContentSize(cc.size(self:getCellSize(), self:getCellSize()));
	self:getFieldNode():addChild(node);

	-- #FIXME: anchor point for fox scene
	node:setAnchorPoint(cc.p(0.5, 0.5));
	node:setPosition(cc.p(pos.x, pos.y));

	local web = SnareTrigger:create();
    local enterCallback = Callback.new(self, Field.onPlayerEnterMob);
    local leaveCallback = Callback.new(self, Field.onPlayerLeaveWeb)
    if fromBullet then
        enterCallback = Callback.new(self, Field.onPlayerEnterNet);
        leaveCallback = Callback.new(self, Field.onPlayerLeaveNet)
    end
	web:init(self, node, enterCallback, leaveCallback);
	table.insert(self.mObjects, web);
	table.insert(self.mEnemyObjects, web);
end

--------------------------------
function Field:addArrayBorder()
	info_log("Field:addArrayBorder x ", self.mSize.x, " y ", self.mSize.y);

	for j = 0, self.mSize.y do
		self.mArray[COORD(0, j, self.mSize.x)] = 1;
		self.mArray[COORD(self.mSize.x, j, self.mSize.x)] = 1;
	end

	for i = 0, self.mSize.x do
		self.mArray[COORD(i, 0, self.mSize.x)] = 1;
		self.mArray[COORD(i, self.mSize.y, self.mSize.x)] = 1;
	end
end

--------------------------------
function Field:addBrick(brick)
    table.insert(self.mBrickObjects, brick);
	local x, y = self:getGridPosition(brick:getNode());
	self.mArray[COORD(x, y, self.mSize.x)] = 1;
end

--------------------------------
function Field:addMob(mob)
	self:addObject(mob);
	table.insert(self.mEnemyObjects, mob);
end

--------------------------------
function Field:addFinish(finish)
	self:addObject(finish);
	table.insert(self.mFinishTrigger, finish);
end

--------------------------------
function Field:addPlayer(player)
	self:addObject(player);
	table.insert(self.mPlayerObjects, player);
end

--------------------------------
function Field:getObjectById(id)
    return self.mObjectsById[id];
end

--------------------------------
function Field:addObject(object)
	table.insert(self.mObjects, object);
    local id = object:getId();
    if id then
        self.mObjectsById[id] = object;
    end
end


--------------------------------
function Field:addBonusRoomDoor(object)
    self:addObject(object);
    local brick = object:getNode();
    local x, y = self:getGridPosition(brick);
    self.mArray[COORD(x, y, self.mSize.x)] = 1;
    self.mPlayerFreeArray[COORD(x, y, self.mSize.x)] = 1;
end

--------------------------------
function Field:removeBonusRoomDoor(object)
    local brick = object:getNode();
    local x, y = self:getGridPosition(brick);
    self.mArray[COORD(x, y, self.mSize.x)] = 1;
    self.mPlayerFreeArray[COORD(x, y, self.mSize.x)] = nil;
end

--------------------------------
function Field:getTimer()
	return self.mTime;
end

--------------------------------
function Field:getScore()
    return self.mScore;
end

--------------------------------
function Field:setScore(score)
    self.mScore = score;
end

--------------------------------
function Field:getGame()
    return self.mGame;
end

--------------------------------
function Field:delayDelete(object)
    self.mNeedDestroyObjects[#self.mNeedDestroyObjects + 1] = object;
end

--------------------------------
function Field:getCustomProperties(gridPosX, gridPosY, tag)
    if self.mCustomProperties then
        info_log("Field:getCustomProperties ", BaseObject:convertToId(gridPosX, gridPosY, tag));
        return self.mCustomProperties[BaseObject:convertToId(gridPosX, gridPosY, tag)];
    end
end

--------------------------------
function Field:setCustomProperties(customProperties)
    self.mCustomProperties = customProperties;
end

--------------------------------
function Field:deleteTornadoInPos(pos)
    local tornados = self:getObjectsByTag(FactoryObject.TORNADO_TAG);
    for i, tornado in ipairs(tornados) do
        if tornado:getGridPosition() == pos then
            tornado:setVisible(false);
        end
    end
end

--------------------------------
function Field:resetDogInHunter(dog)
    debug_log("Field:resetDogInHunter ")
    local hunters = self:getObjectsByTag(FactoryObject.HUNTER_TAG);
    for i, hunter in ipairs(hunters) do
        if hunter:getDog() == dog then
            hunter:onDogFoundPlayer(nil);
        end
    end
end

--------------------------------
function Field:onHunterDead(hunter)
    debug_log("Field:onHunterDead ");
    -- reset hunter's dog
    local dog = hunter:getDog();
    if dog then
        dog:onPlayerLeave();
    end

    -- run away dogs
    --local hunters = self:getObjectsByTag(FactoryObject.HUNTER_TAG);
    local hunters = self:getNearestHunters(hunter:getGridPosition(), false);
    debug_log("Field:onHunterDead hunters count ", #hunters);
    -- get avalable hunters
    -- #todo:
    local dogs = self:getObjectsByTag(FactoryObject.DOG_TAG);
    if #hunters <=1 then
        -- remove all
        for i, dog in ipairs(dogs) do
            dog:onHunterDead();
        end
    elseif #dogs >= 1 and #dogs >= #hunters then
        if dog then
            dog:onHunterDead();
        else
            dogs[1]:onHunterDead();
        end
    end
end

--------------------------------
function Field:getNearestHunters(pos, onlyAlive)
    local nearestHunters = {};
    local hunters = self:getObjectsByTag(FactoryObject.HUNTER_TAG);
    for i, hunter in ipairs(hunters) do
        debug_log("Field:getNearestHunters hunter isDead ", hunter:isDead());
        if not onlyAlive or not hunter:isDead() then
            local hunterPos = hunter:getGridPosition();
            local cloneArray = self:cloneArray();
            local path = WavePathFinder.buildPath(pos, hunterPos, cloneArray, self.mSize);

            local dist = #path--(hunterPos - pos):lenSq();
            debug_log("Field:getNearestHunters dist ", dist);
            if dist > 0 then
                table.insert(nearestHunters, {obj = hunter, dist = dist});
            end
        end
    end
    table.sort(nearestHunters, function(a,b) return a.dist < b.dist end )
    for i, val in ipairs(nearestHunters) do
        debug_log("Field:getNearestHunters dist ", val.dist);
    end
    return nearestHunters;
end

--------------------------------
function Field:getNearestHunter(pos)
    -- get all hunter
    local hunters = self:getNearestHunters(pos, true)
    if #hunters == 0 then
        return nil
    end
    return hunters[1].obj;
end

--------------------------------
function Field:onDogFoundPlayer(dog, pos)
    info_log("Field::onDogFoundPlayer ");
    self:resetDogInHunter(dog);
    if pos then
        -- found nearest hunter
        local hunter = self:getNearestHunter(pos);
        debug_log("Field:onDogFoundPlayer hunter ", hunter);
        -- set dog to hunter
        if hunter then
            hunter:onDogFoundPlayer(dog, pos);
        end
    end
end

--------------------------------
function Field:loadCustomProperties(fieldData)
    info_log("Field:loadCustomProperties( ", fieldData.determinedCustomProperties);
    if fieldData.determinedCustomProperties then
        self.mCustomProperties = fieldData.determinedCustomProperties;
    elseif fieldData.customProperties ~= nil then
        local customProperties = require(fieldData.customProperties);
        info_log("Field:loadCustomProperties customProperties ", customProperties);
        self.mCustomProperties = customProperties;
    end
end

--------------------------------
function Field:init(fieldNode, layer, fieldData, game)

	self.mState = Field.IN_GAME;
    self.mScore = 0;
    self.mId = fieldData.id;
    self.mBonusLevel = fieldData.bonusLevel;
    self.mBonusLevelFile = fieldData.BonusLevelFile;
    self.mIsBonusLevel = fieldData.isBonus;
    self.mIsTutorialLevel = fieldData.tutorial;
    info_log("Field:init self.mBonusLevel ", self.mBonusLevel);

	local objectType = _G[fieldData.playerType];
	local mobType = _G[fieldData.mobType];
	info_log(" Game ", game);
	self.mCellSize = fieldData.cellSize * game:getScale();
	self.mGame = game;

	self.mObjects = {}
    self.mBrickObjects = {}
	self.mFreePoints = {};
	self.mPlayerObjects = {};
	self.mEnemyObjects = {};
	self.mFinishTrigger = {};
    self.mObjectsById = {};
    self.mPlayerPosY = {};
    self.mNeedDestroyObjects = {};
	self.mLeftBottom = Vector.new(0, 0);
	self.mFieldNode = FieldNode:create();
	self.mFieldNode:init(fieldNode, layer, self);
    self.mLevelStatistic = {};

	local children = self.mFieldNode:getChildren();
	local count = children:count();
	info_log("Field:init count ", count);
	if count == 0 then
		return;
	end
	
	-- compute size of brick
	local minValue = Vector.new(MAX_NUMBER, MAX_NUMBER);
	local maxValue = Vector.new(MIN_NUMBER, MIN_NUMBER);

	local contentSize = self.mFieldNode:getContentSize();
	info_log("newMaxValue x ", contentSize.width / self.mCellSize, " y ", contentSize.height / self.mCellSize);

	maxValue.x = math.floor(contentSize.width / self.mCellSize + 1);--(maxValue.x - minValue.x) / self.mCellSize;
	maxValue.y = math.floor(contentSize.height / self.mCellSize + 1);--(maxValue.y - minValue.y) / self.mCellSize;

	info_log("maxValue x ", maxValue.x, " y ", maxValue.y);
	self.mArray = {};
    self.mPlayerFreeArray = {};
	self.mSize = maxValue;
	-- fill zero 
	for i = 0, maxValue.x do
		for j = 0, maxValue.y do
			self.mArray[COORD(i, j, maxValue.x)] = 0;
		end
	end

    self:loadCustomProperties(fieldData);
	for i = 1, count do
		local brick = tolua.cast(children:objectAtIndex(i - 1), "cc.Node");

		local object = FactoryObject:createObject(self, brick);
        if object then
            local pos = object:getPosition();
            info_log("create object x ", pos.x, " y ", pos.y);
            local gridPosX, gridPosY = self:positionToGrid(pos);
            info_log("create object grid x ", gridPosX, " y ", gridPosY);
            local tag = brick:getTag();
            info_log("create tag ", tag);
            local properties = self:getCustomProperties(gridPosX, gridPosY, tag);
            if properties then
                object:setCustomProperties(properties);
            end
        end
	end

	self:addArrayBorder();

    -- post init
    for i, obj in ipairs(self.mObjects) do
        obj:postInit();
    end

	-- fill free point it is point where objects can move
    local players = self:getPlayerObjects();
    if #players ~= 0 then
	   self:fillFreePoint(players[1].mGridPosition, self.mFreePoints);
       
    end
	self:printField();

    debug_log("fieldData.time !!! ", fieldData.time);
	if fieldData.time then
		self.mTime = fieldData.time;
	end
    self.mLevelStatistic.startTimeLevel = self.mTime;

end