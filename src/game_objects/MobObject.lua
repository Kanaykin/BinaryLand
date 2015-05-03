require "src/game_objects/MovableObject"
require "src/algorithms/WavePathFinder"
require "src/game_objects/SnareTrigger"
require "src/game_objects/PlayerObject"
require "src/base/Log"

MobObject = inheritsFrom(MovableObject)

MobObject.IDLE = 1;
MobObject.MOVING = 2;
MobObject.DEAD = 3;

MobObject.mState = MobObject.IDLE;
MobObject.mPath = nil;
MobObject.mTrigger = nil;

MobObject.DIRECTIONS = {
    SIDE = 1,
    FRONT = 2,
    BACK = 3
};

MobObject.mAnimation = nil;

MobObject.mAnimations = nil;
MobObject.mTimeDestroy = nil;

--------------------------------
function MobObject:getAnimationByDirection()
    if self.mDelta then
        local val = self.mDelta:normalized();
        if val.y >= 0.9 then
            return MobObject.DIRECTIONS.BACK;
        elseif val.y <= -0.9 then
            return MobObject.DIRECTIONS.FRONT;
        end
    end
    return MobObject.DIRECTIONS.SIDE;
end

---------------------------------
function MobObject:isMob()
    return true;
end

--------------------------------
function MobObject:initAnimation()
	info_log("MobObject:initAnimation");

	local animation = CCAnimation:create();
	info_log("animation ", animation);
	animation:addSpriteFrameWithFileName("spider_frame1.png"); 
	animation:addSpriteFrameWithFileName("spider_frame2.png"); 

	animation:setDelayPerUnit(1 / 2);
	animation:setRestoreOriginalFrame(true);

	local action = CCAnimate:create(animation);
	local repeatForever = CCRepeatForever:create(action);
	self.mNode:runAction(repeatForever);
end

--------------------------------
function MobObject:onPlayerEnter(player, pos)
	info_log("MobObject.onPlayerEnter ", player.mNode:getTag());
    if self.mState ~= MobObject.DEAD then
        self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()));
    end
end

--------------------------------
function MobObject:getBonus()
    return 100;
end

--------------------------------
function MobObject:onPlayerLeave(player)
	info_log("MobObject.onPlayerLeave");
	--player:leaveTrap(nil);
end

---------------------------------
function MobObject:onStateWin()
	info_log("MobObject:onStateWin ", self.mTrigger);
	MobObject:superClass().onStateWin(self);
	self.mTrigger:setEnterCallback(nil);
end

--------------------------------
function MobObject:init(field, node)
	info_log("MobObject:init(", node, ")");
	MobObject:superClass().init(self, field, node);

	self.mState = MobObject.IDLE;
	self.mTrigger = SnareTrigger:create();
	self.mVelocity = self.mVelocity * field.mGame:getScale();

	-- set size of cell
	self.mNode:setContentSize(cc.size(self.mField:getCellSize(), self.mField:getCellSize()));

	self.mTrigger:init(self.mField, self.mNode, Callback.new(self, MobObject.onPlayerEnter), Callback.new(self, MobObject.onPlayerLeave));

	-- create animation
	self:initAnimation();
end

--------------------------------
function MobObject:getDestPoint()
	local freePoints = self.mField:getFreePoints();
	return freePoints[math.random(#freePoints)];
end

--------------------------------
function MobObject:moveToNextPoint( )
	if #self.mPath == 0 then
		self.mState = MobObject.IDLE;
		return;
	end
	self:moveTo(self.mPath[1]);
	table.remove(self.mPath, 1);
end

--------------------------------
function MobObject:onMoveFinished( )
	self:moveToNextPoint();
end

---------------------------------
function MobObject:onEnterFightTrigger()
    self.mTimeDestroy = 0.5;
    self.mState = MobObject.DEAD;
--    self.mNode:stopAllActions();
end

--------------------------------
function MobObject:tick(dt)
    if self.mState == MobObject.DEAD then
        if self.mTimeDestroy then
            self.mTimeDestroy = self.mTimeDestroy - dt;
            if self.mTimeDestroy <= 0 then
                self.mField:addBonus(self);
                self.mField:removeObject(self);
                self.mField:removeEnemy(self)
                self:destroy();
            end
        end
--        return;
    end

	MobObject:superClass().tick(self, dt);

	if self.mTrigger then
		self.mTrigger:tick(dt);
	end

	if self.mDelta then
		local val = self.mDelta:normalized();
		--info_log("MobObject:tick mDestGridPos ", val.x, ":", val.y);
		tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(val.x < 0);
	end

	if self.mState == MobObject.IDLE then
		-- find free point on field and move to this point
		local destPoint = self:getDestPoint();
		-- clone field
		local cloneArray = self.mField:cloneArray();
		print ("MobObject:tick destPoint ", destPoint.x, "y ", destPoint.y);
		self.mState = MobObject.MOVING;
		self.mPath = WavePathFinder.buildPath(self.mGridPosition, destPoint, cloneArray, self.mField.mSize);
		table.remove(self.mPath, 1);
		self:moveToNextPoint();
	end

    local anim = self:getAnimationByDirection();
    if anim ~= self.mAnimation then
        self.mAnimation = anim;
        self.mNode:stopAllActions();
        self.mAnimations[self.mAnimation]:play();
    end

end
