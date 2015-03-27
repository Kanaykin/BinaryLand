require "src/base/Inheritance"
require "src/math/Vector"
require "src/game_objects/FieldNode"
require "src/game_objects/FactoryObject"

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
Field.mIsBonusLevel = nil;
Field.mObjectsById = nil;

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

-- states
Field.PAUSE = 1;
Field.IN_GAME = 2;
Field.WIN = 3;
Field.LOSE = 4;

--------------------------------
function COORD(x, y, width)
	return x + 1 + y * width;
end

--------------------------------
function PRINT_FIELD(array, size)
	print("PRINT_FIELD !");
	for j = 0, size.y do
		local raw = "";
		for i = 0, size.x do
			--print("COORD ", COORD(i, j, size.x))
			raw = raw .. tostring(array[COORD(i, j, size.x)]) .. " ";
		end
		print(raw);
	end
end

---------------------------------
function Field:getState()
	return self.mState;
end

---------------------------------
function Field:destroy()
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
function Field:getObjetcByTag(tag)
	for _, obj in ipairs(self.mObjects) do
		print("Field:getObjetcByTag tag ", obj:getTag())
		if obj:getTag() == tag then
			return obj;
		end
	end
	return nil
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
function Field:updateScrollPos()
	local min = math.huge;
	local max = -math.huge;
	for i, val in ipairs(self.mPlayerObjects) do
		local x, y = val.mNode:getPosition();
		min = math.min(min, y);
		max = math.max(max, y);
	end
	local visibleSize = CCDirector:getInstance():getVisibleSize();
	local pos = max - visibleSize.height / 2;
	pos = math.max(pos, 0);
	--print ("Field:updateScrollPos ", pos); 
	self.mFieldNode:setScrollPos(Vector.new(0, pos));
end

---------------------------------
function Field:checkFinishGame()
	if self.mState ~= Field.IN_GAME then
		return;
	end

	-- check win game
	local allObjectInTrigger = true;
	for _, trigger in ipairs(self.mFinishTrigger) do
		local obj = trigger:getContainedObj();
		if not obj then
			allObjectInTrigger = false;
		end
	end
	
	if allObjectInTrigger then
		print("Field:checkFinishGame WIN");
		self:onStateWin()
		return;
	end

	-- check game over
	local allObjectInTrap = true;
	for _, object in ipairs(self.mPlayerObjects) do
		--print("isInTrap ", object:isInTrap());
		if not object:isInTrap() then
			allObjectInTrap = false;
		end
	end

	if allObjectInTrap or (self.mTime and self.mTime <= 0) then
		print("Field:checkFinishGame LOSE");
		self:onStateLose();
		return;
	end
end

---------------------------------
function Field:onStateLose()
	self.mState = Field.LOSE;
	print("LOSE !!!");
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
    print("Field:restore ");
    if not data.field then
        print("Invalid field data");
        return;
    end
    self.mTime = data.field.time;
    self.mScore = data.field.score;
    print("Field:restore objects ", data.field.objects);
    for id, objectData in pairs(data.field.objects) do
        local object = self:getObjectById(id);
        print("Field:restore id ", id, " object ", object);
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
        data.field.objects[object:getId()] = {};
        print("Field:store obj ", object:getId());
        object:store(data.field.objects[object:getId()]);
    end
end

---------------------------------
function Field:onEnterBonusRoomDoor(player)
    print("Field:onEnterBonusRoomDoor ", player);
    player:onEnterBonusRoomDoor();
    if self.mStateListener then
        self.mStateListener:onEnterBonusRoomDoor(player:isFemale());
    end
    print("Field:onEnterBonusRoomDoor end");
end

---------------------------------
function Field:onStateWin()

	self.mState = Field.WIN;
	print("WIN !!!");
	if self.mStateListener then
        --check bonus level
        if self.mBonusLevel then
            self.mStateListener:onStateBonusStart();
        else
            self.mStateListener:onStateWin();
        end
	end

	for _, object in ipairs(self.mObjects) do
		object:onStateWin();
	end
end

---------------------------------
function Field:onStatePause()
	self.mState = Field.PAUSE;
	print("PAUSE !!!");
end

---------------------------------
function Field:onStateInGame()
	self.mState = Field.IN_GAME;
	print("IN GAME !!!");
end

---------------------------------
function Field:updateState()
	if self.mState ~= Field.PAUSE and self.mState ~= Field.IN_GAME then
		return;
	end
	--print("self.mGame.mDialogManager:hasModalDlg() ", self.mGame.mDialogManager:hasModalDlg());
	if self.mState == Field.IN_GAME and self.mGame.mDialogManager:hasModalDlg() then
		self:onStatePause();
	elseif self.mState == Field.PAUSE and not self.mGame.mDialogManager:hasModalDlg() then
		self:onStateInGame();
	end
end

---------------------------------
function Field:tick(dt)
	self:updateState();

    --print("Field:tick self.mId ", self.mId);
    for i, obj in ipairs(self.mNeedDestroyObjects) do
        self:removeObject(obj);
        self:removeEnemy(obj);
        obj:destroy();
    end
    self.mNeedDestroyObjects = {}

	if self.mState == Field.IN_GAME then
        if self.mTime then
            self.mTime = self.mTime - dt;
        end
    end

    if self.mState ~= Field.PAUSE then
		for i, obj in ipairs(self.mObjects) do
			obj:tick(dt);
		end

		self:updateScrollPos();
		self:checkFinishGame();
	end
end

--------------------------------
function Field:fillFreePoint()
	for j = 0, self.mSize.y do
		for i = 0, self.mSize.x do
			if self.mArray[COORD(i, j, self.mSize.x)] == 0 then 
				table.insert(self.mFreePoints, Vector.new(i, j));
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
	print("Field:removeObject(", object, ")");
	local index = self:findArrayIndex(self.mObjects, object);
	if index then
		table.remove(self.mObjects, index);
	end
	print("Field:removeObject ", index);
end

--------------------------------
function Field:removeEnemy(enemy)
	print("Field:removeEnemy(", enemy, ")");
	local index = self:findArrayIndex(self.mEnemyObjects, enemy);
	if index then
		table.remove(self.mEnemyObjects, index);
	end
	print("Field:removeEnemy ", index);
end

--------------------------------
function Field:createBonus(rect, position, orderPos, bonusVal)
    local texture = cc.Director:getInstance():getTextureCache():addImage("Coin.png");
    print("Field:createBonus texture ", texture, " rect ", rect, "bonus ", bonus);
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
end

--------------------------------
function Field:addTime(score)
    self.mTime = self.mTime + score;
end

--------------------------------
function Field:onEnterBonusTrigger(player)
    print("Field:onEnterBonusTrigger ");
--    self.mScore = self.mScore + 100;
    SimpleAudioEngine:getInstance():playEffect(gSounds.BONUS_SOUND);
end

--------------------------------
function Field:onEnemyEnterTrigger(enemy)
	print("Field:onEnemyEnterTrigger ", enemy);
	SimpleAudioEngine:getInstance():playEffect(gSounds.MOB_DEATH_SOUND)

    if enemy.getBonus then
        local rect = enemy:getBoundingBox();
        local pos = enemy:getPosition();
        local orderPos = enemy:getPrevOrderPos();
        self:createBonus(rect, pos, orderPos - 1, enemy:getBonus());
    end

	self:removeObject(enemy);
	self:removeEnemy(enemy)
	enemy:destroy();
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
			print("Field:collideObject1 x ", boxl.x, " y ", boxl.y);
			print("Field:collideObject1 size x ", boxl.width, " y ", boxl.height);
			local boxr = object:getBoundingBox();
			print("Field:collideObject2 x ", boxr.x, " y ", boxr.y);
			print("Field:collideObject2 size x ", boxr.width, " y ", boxr.height);

			local centerL = Vector.new(boxl.x - boxl.width / 2, boxl.y - boxl.height / 2);
			local centerR = Vector.new(boxr.x - boxr.width / 2, boxr.y - boxr.height / 2);
			local diametr = Vector.distance(centerL, centerR);
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
	print("onPlayerLeaveWeb ");
	player:leaveTrap(nil);
end

--------------------------------
function Field:onPlayerEnterWeb(player, pos)
	print("onPlayerEnterWeb ");
	-- if player is primary then game over
	player:enterTrap(pos);
end

--------------------------------
function Field:onPlayerEnterMob(player, pos)
	print("onPlayerEnterMob ");
	-- if player is primary then game over
	player:enterTrap(nil);
end

--------------------------------
function Field:getFieldNode()
	return self.mFieldNode;
end

--------------------------------
function Field:createSnareTrigger(pos)
	print("Field:createSnareTrigger x= ", pos.x, " y= ", pos.y);
	local node = CCNode:create();
	node:setContentSize(cc.size(self:getCellSize(), self:getCellSize()));
	self:getFieldNode():addChild(node);

	-- #FIXME: anchor point for fox scene
	node:setAnchorPoint(cc.p(0.5, 0.5));
	node:setPosition(cc.p(pos.x, pos.y));

	local web = SnareTrigger:create();
	web:init(self, node, Callback.new(self, Field.onPlayerEnterMob), Callback.new(self, Field.onPlayerLeaveWeb));
	table.insert(self.mObjects, web);
	table.insert(self.mEnemyObjects, web);
end

--------------------------------
function Field:addArrayBorder()
	print("Field:addArrayBorder x ", self.mSize.x, " y ", self.mSize.y);

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
	local x, y = self:getGridPosition(brick);
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
        print("Field:getCustomProperties ", BaseObject:convertToId(gridPosX, gridPosY, tag));
        return self.mCustomProperties[BaseObject:convertToId(gridPosX, gridPosY, tag)];
    end
end

--------------------------------
function Field:loadCustomProperties(fieldData)
    print("Field:loadCustomProperties( ", fieldData.customProperties);
    if fieldData.customProperties ~= nil then
        local customProperties = require(fieldData.customProperties);
        print("Field:loadCustomProperties customProperties ", customProperties);
        self.mCustomProperties = customProperties;
    end
end

--------------------------------
function Field:init(fieldNode, layer, fieldData, game)

	self.mState = Field.IN_GAME;
    self.mScore = 0;
    self.mId = fieldData.id;
    self.mBonusLevel = fieldData.bonusLevel;
    self.mIsBonusLevel = fieldData.isBonus;
    print("Field:init self.mBonusLevel ", self.mBonusLevel);

	local objectType = _G[fieldData.playerType];
	local mobType = _G[fieldData.mobType];
	print(" Game ", game);
	self.mCellSize = fieldData.cellSize * game:getScale();
	self.mGame = game;

	self.mObjects = {}
	self.mFreePoints = {};
	self.mPlayerObjects = {};
	self.mEnemyObjects = {};
	self.mFinishTrigger = {};
    self.mObjectsById = {};
	self.mLeftBottom = Vector.new(0, 0);
	self.mFieldNode = FieldNode:create();
	self.mFieldNode:init(fieldNode, layer, self);

	local children = self.mFieldNode:getChildren();
	local count = children:count();
	print("count ", count);
	if count == 0 then
		return;
	end
	
	-- compute size of brick
	local minValue = Vector.new(MAX_NUMBER, MAX_NUMBER);
	local maxValue = Vector.new(MIN_NUMBER, MIN_NUMBER);

	local contentSize = self.mFieldNode:getContentSize();
	print("newMaxValue x ", contentSize.width / self.mCellSize, " y ", contentSize.height / self.mCellSize);

	maxValue.x = math.floor(contentSize.width / self.mCellSize + 1);--(maxValue.x - minValue.x) / self.mCellSize;
	maxValue.y = math.floor(contentSize.height / self.mCellSize + 1);--(maxValue.y - minValue.y) / self.mCellSize;

	print("maxValue x ", maxValue.x, " y ", maxValue.y);
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
            print("create object x ", pos.x, " y ", pos.y);
            local gridPosX, gridPosY = self:positionToGrid(pos);
            print("create object grid x ", gridPosX, " y ", gridPosY);
            local tag = brick:getTag();
            print("create tag ", tag);
            local properties = self:getCustomProperties(gridPosX, gridPosY, tag);
            if properties then
                object:setCustomProperties(properties);
            end
        end
	end

	self:addArrayBorder();

	-- fill free point it is point where objects can move
	self:fillFreePoint();
	self:printField();

	if fieldData.time then
		self.mTime = fieldData.time;
	end

    self.mNeedDestroyObjects = {};
end