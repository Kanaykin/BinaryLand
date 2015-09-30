require "src/game_objects/MovableObject"
require "src/game_objects/FightTrigger"
require "src/animations/EmptyAnimation"
require "src/animations/FramesAnimation"
require "src/base/Log"

PlayerObject = inheritsFrom(MovableObject)
PlayerObject.mJoystick = nil;
PlayerObject.mFightButton = nil;
PlayerObject.mVelocity = 40;
PlayerObject.mReverse = Vector.new(1, 1);
PlayerObject.mAnimations = nil;
PlayerObject.mFightButtonOffset = 5;
PlayerObject.mLastButtonPressed = nil;
PlayerObject.mNameTexture = "penguin";
PlayerObject.mIsFemale = false;
PlayerObject.mFightTrigger = nil;
PlayerObject.mInTrap = false;
PlayerObject.mBonusRoomDoorPosition = nil;

PlayerObject.MALE_PREFIX = "penguin";
PlayerObject.FEMALE_PREFIX = "penguin_girl";

DIRECTIONS = {
		Vector.new(-1, 0),
		Vector.new(1, 0),
		Vector.new(0, 1),
		Vector.new(0, -1)
	}
PlayerObject.mLastDir = 3;

PlayerObject.PLAYER_STATE = {
	PS_LEFT = 1,
	PS_RIGHT = 2,
	PS_TOP = 3,
	PS_BOTTOM = 4,
	PS_OBJECT_IN_TRAP = 5,
	PS_FIGHT_LEFT = 6,
	PS_FIGHT_RIGHT = 7,
	PS_FIGHT_UP = 8,
	PS_FIGHT_DOWN = 9,
	PS_WIN_STATE = 10,
	PS_LAST = 11,
	NONE = nil	
};

PlayerObject.mStateInTrap = PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP;

ANIMATION_MALE = {
		{name = "_left", frames = 2, anchorFight = cc.p(0.5, 0.5), anchorFightFemale = cc.p(0.5, 0.5)},
		{name = "_right", frames = 2, anchorFight = cc.p(0.5, 0.5), anchorFightFemale = cc.p(0.5, 0.5)},
		{name = "_up", frames = 2, anchorFight = cc.p(0.5, 0.5), anchorFightFemale = cc.p(0.5, 0.5)},
		{name = "_down", frames = 2, anchorFight = cc.p(0.5, 0.5), anchorFightFemale = cc.p(0.5, 0.5)},
		{name = "_trap", frames = 2, anchorFight = cc.p(0.5, 0.5), anchorFightFemale = cc.p(0.5, 0.5)},
		{name = "_fight_left", frames = 2, anchorFight = cc.p(0.75, 0.5), anchorFightFemale = cc.p(0.25, 0.5)},
		{name = "_fight_right", frames = 2, anchorFight = cc.p(0.25, 0.5), anchorFightFemale = cc.p(0.75, 0.5)},
		{name = "_fight_up", frames = 2, anchorFight = cc.p(0.45, 0.25), anchorFightFemale = cc.p(0.45, 0.25)},
		{name = "_fight_down", frames = 2, anchorFight = cc.p(0.48, 0.75), anchorFightFemale = cc.p(0.48, 0.75)}
	}

---------------------------------
function PlayerObject:store(data)
    PlayerObject:superClass().store(self, data);
    --data.lastButtonPressed = self.mLastButtonPressed;
    if self.mBonusRoomDoorPosition then
        data.nodePosition = self.mBonusRoomDoorPosition;
    end
end

---------------------------------
function PlayerObject:getLastButtonPressed()
    return self.mLastButtonPressed
end

---------------------------------
function PlayerObject:restore(data)
    PlayerObject:superClass().restore(self, data);
    --self.mLastButtonPressed = data.lastButtonPressed;
end

---------------------------------
function PlayerObject:setCustomProperties(properties)
    info_log("PlayerObject:setCustomProperties properties.state ", properties.state);

    PlayerObject:superClass().setCustomProperties(self, properties);

    if properties.isFemale ~= nil then
        info_log("PlayerObject:setCustomProperties ", properties.isFemale)
        self.mIsFemale = properties.isFemale;
        self.mReverse = self.mIsFemale and Vector.new(-1, 1) or Vector.new(1, 1);
        self.mNameTexture = self.mIsFemale and PlayerObject.FEMALE_PREFIX or PlayerObject.FEMALE_PREFIX;
        self.mLastButtonPressed = -1;
        self:destroyAnimation();
        self:initAnimation();
        self:playAnimation(nil);
    end
end

---------------------------------
function PlayerObject:destroyAnimation()
    for i, animation in pairs(self.mAnimations) do
        if animation then
            animation:destroy();
        end
    end
end

---------------------------------
function PlayerObject:destroy()
	PlayerObject:superClass().destroy(self);

    self:destroyAnimation();
end

---------------------------------
function PlayerObject:isInTrap()
	return self.mInTrap;
end

---------------------------------
function PlayerObject:leaveTrap(pos)
	info_log("PlayerObject:leaveTrap");
	self:playAnimation(nil);
	self.mInTrap = false;
end

---------------------------------
function PlayerObject:enterTrap(pos, stateInTrap)
	
	self.mStateInTrap = stateInTrap and stateInTrap or PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP;
	self.mInTrap = true;

    if self.mLastButtonPressed ~= self.mStateInTrap then
        self:playAnimation(nil);
    end

	if pos then
		info_log("PlayerObject:enterTrap x= ", pos.x, " y= ", pos.y);
		local posTo = Vector.new(self.mField:positionToGrid(pos));
		self:moveTo(posTo);
	else
		self:playAnimation(self.mStateInTrap);
	end

    info_log("PlayerObject:enterTrap ???");
end

--------------------------------
function PlayerObject:onMoveFinished( )
	info_log("PlayerObject:onMoveFinished ", self.mStateInTrap)
	PlayerObject:superClass().onMoveFinished(self);
	self:playAnimation(self.mStateInTrap);
	self.mDelta = nil;
end

--------------------------------
function PlayerObject:initAnimation()
	local texture = tolua.cast(self.mNode, "cc.Sprite"):getTexture();

	self.mAnimations = {}
	self.mAnimations[-1] = EmptyAnimation:create();
	self.mAnimations[-1]:init(texture, self.mNode, self.mNode:getAnchorPoint());

	-- create empty animation
	for i, info in ipairs(ANIMATION_MALE) do
		if info.name then
			self.mAnimations[i] = FramesAnimation:create();
			self.mAnimations[i]:init(self.mNameTexture..info.name, info.frames, self.mNode, texture,
				self.mIsFemale and ANIMATION_MALE[i].anchorFightFemale or 
				ANIMATION_MALE[i].anchorFight);
		end
	end
	self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE] = EmptyAnimation:create();
	self.mAnimations[PlayerObject.PLAYER_STATE.PS_WIN_STATE]:init(texture, self.mNode, self.mNode:getAnchorPoint());
end

--------------------------------
function PlayerObject:isFemale()
    return self.mIsFemale;
end

--------------------------------
function PlayerObject:getAnimationNode()
	return self.mNode;
end

--------------------------------
function PlayerObject:playAnimation(button)
	--debug_log("PlayerObject:playAnimation ", self.mLastButtonPressed);
	if self.mLastButtonPressed ~= button and self.mNode then
		self.mLastButtonPressed = button;
		info_log("PlayerObject:playAnimation2 ", self.mLastButtonPressed, " button ", button);
		self:getAnimationNode():stopAllActions();
		button = (button == nil) and -1 or button;
		self.mAnimations[button]:play();
	end
end

--------------------------------
function PlayerObject:getReverse()
	return self.mReverse;
end

--------------------------------
function PlayerObject:init(field, node, needReverse)
	PlayerObject:superClass().init(self, field, node);

	self.mFightTrigger = FightTrigger:create();
	self.mFightTrigger:init(field);

	if needReverse then 
		self.mReverse = Vector.new(-1, 1);
		self.mNameTexture = PlayerObject.FEMALE_PREFIX;
		self.mIsFemale = true;
	end
	self:initAnimation();
	self:playAnimation(nil);
	self:updateOrder();
end

--------------------------------
function PlayerObject:setFightButton(fightButton)
	self.mFightButton = fightButton;
end

--------------------------------
function PlayerObject:setJoystick(joystick)
	self.mJoystick = joystick;
end

--------------------------------
function PlayerObject:collisionDetect(delta, newDir)
	local currentPos = Vector.new(self.mNode:getPosition());
	--debug_log("currentPos ", currentPos.x, " ", currentPos.y);
	local anchor = self.mNode:getAnchorPoint();
	delta = delta * (self.mField:getCellSize() * 0.5);
	local destPos = currentPos + delta --[[Vector.new(anchor.x, anchor.y))]];
	--debug_log("destPos ", destPos.x, " ", destPos.y);

	local destGrid = Vector.new(self.mField:positionToGrid(destPos));
	--debug_log("destGrid ", destGrid.x, " ", destGrid.y);

	if self.mField:isFreePointForPlayer(destGrid) then
		local centerCell = self.mField:gridPosToReal(destGrid) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		local centerSelf = self.mField:gridPosToReal(Vector.new(self.mField:positionToGrid(currentPos))) + Vector.new(self.mField:getCellSize() / 2, self.mField:getCellSize() / 2);
		--debug_log("centerCell ", centerCell.x, " ", centerCell.y);
		--debug_log("centerSelf ", centerSelf.x, " ", centerSelf.y);
		local dir = centerCell - currentPos;
		if (centerCell - centerSelf):len() <= 1 then
			return true;
		end
		dir:normalize();
		newDir.x = dir.x;
		newDir.y = dir.y;
		--debug_log("newDir ", newDir.x, " ", newDir.y);
		return true;
	end
	return false;
end

--------------------------------
function PlayerObject:weakfight()
	-- if is fight animation playing
	if self.mLastButtonPressed and self.mLastButtonPressed > PlayerObject.mFightButtonOffset and
		not self.mAnimations[self.mLastButtonPressed]:isDone() then
		return true;
	end
	return false;
end

--------------------------------
function PlayerObject:setFightActivated(activated)
	self.mFightTrigger:setActivated(activated);
end

--------------------------------
function PlayerObject:fight()
	if not self.mFightButton then
		return false;
	end
	if self.mFightButton:isPressed() then

		if not self.mFightTrigger:isActivated() then 
			self:playAnimation(self.mLastDir + PlayerObject.mFightButtonOffset);

			self:setFightActivated(true);
			local selfPosX, selfPosY = self.mNode:getPosition();
			
			local newDir = DIRECTIONS[self.mLastDir]:clone() * self.mReverse;

            self.mFightTrigger:setDateTransform(Vector.new(selfPosX, selfPosY), Vector.new(self.mField:getCellSize() * newDir.x, self.mField:getCellSize() * newDir.y));
		end

		return true;
	end

	--self.mFightTrigger:setActivated(false);
	
	return false;
end

--------------------------------
function PlayerObject:IsMoving()
	local button = self.mJoystick:getButtonPressed();
	return button ~= nil;
end

---------------------------------
function PlayerObject:onEnterBonusRoomDoor()
    info_log("PlayerObject:onEnterBonusRoomDoor");
    info_log("PlayerObject:onEnterBonusRoomDoor mGridPosition ", self.mGridPosition.x, "y ", self.mGridPosition.y);
    info_log("PlayerObject:onEnterBonusRoomDoor mDelta ", self.mDelta);
    if self.mDestGridPos then
        info_log("PlayerObject:onEnterBonusRoomDoor mDestGridPos ", self.mDestGridPos.x, "y ", self.mDestGridPos.y);
    end
    if self.mLastDir then
        info_log("PlayerObject:onEnterBonusRoomDoor self.mLastDir ", self.mLastDir);

        local curPosition = Vector.new(self.mNode:getPosition());

        local newDir = DIRECTIONS[self.mLastDir]:clone() * self.mReverse;
        info_log("PlayerObject:onEnterBonusRoomDoor curPosition ", curPosition.x, " y ", curPosition.y);
        curPosition = curPosition - newDir * self.mField:getCellSize() * 0.5;
        info_log("PlayerObject:onEnterBonusRoomDoor curPosition ", curPosition.x, " y ", curPosition.y);
        --self.mNode:setPosition(cc.p(curPosition.x, curPosition.y));
        self.mBonusRoomDoorPosition = curPosition;
    end
end

--------------------------------
function PlayerObject:move(dt)
	if not self.mJoystick then
		return;
	end
	
	local button = self.mJoystick:getButtonPressed();
	--debug_log("button pressed ", );
	if button and button ~= PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP then

		self:playAnimation(button);
		self.mLastDir = button;

		if self.mFightTrigger:isActivated() then 
			self:setFightActivated(false);
		end

		local newGridPos = self.mGridPosition + DIRECTIONS[button];
		
		local curPosition = Vector.new(self.mNode:getPosition());
		--curPosition = curPosition + DIRECTIONS[button] * self.mVelocity;
		--local pos = self.mField:gridPosToReal(newGridPos);
		local newDir = DIRECTIONS[button]:clone() * self.mReverse;
		self.mLastButton = button;
		if self:collisionDetect(DIRECTIONS[button] * self.mReverse, newDir) then --self.mField:isFreePoint(newGridPos) then
			curPosition = curPosition + newDir * self.mVelocity * dt;
			if not self.mField:collideObject(self, curPosition) then
				self.mNode:setPosition(cc.p(curPosition.x, curPosition.y));
				self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
				info_log("PlayerObject:move x ", self.mGridPosition.x, ", y", self.mGridPosition.y);
				self:updateOrder();
			end
		end
	elseif not self:weakfight() then
		self:playAnimation(button);

		if self.mFightTrigger:isActivated() then 
			self:setFightActivated(false);
		end
	end
end

--------------------------------
function PlayerObject:getCurrentAnimation()
    local animationButton = (self.mLastButtonPressed == nil) and -1 or self.mLastButtonPressed;
    return self.mAnimations[animationButton];
end

--------------------------------
function PlayerObject:animationTick(dt)
	local animationButton = (self.mLastButtonPressed == nil) and -1 or self.mLastButtonPressed;
--    info_log("PlayerObject:animationTick ", animationButton);
	self.mAnimations[animationButton]:tick(dt);
end

--------------------------------
function PlayerObject:tick(dt)
	PlayerObject:superClass().tick(self, dt);
	
	self.mFightTrigger:tick(dt);

	if PlayerObject.PLAYER_STATE.PS_WIN_STATE == self.mLastButtonPressed or PlayerObject.PLAYER_STATE.PS_OBJECT_IN_TRAP == self.mLastButtonPressed or self.mDelta then
		-- do nothing object is in trap
	elseif not self:fight() then 
		self:move(dt);
	end

	self:animationTick(dt);
end
