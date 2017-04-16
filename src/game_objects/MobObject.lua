require "src/game_objects/MovableObject"
require "src/algorithms/WavePathFinder"
require "src/game_objects/SnareTrigger"
require "src/game_objects/PlayerObject"
require "src/base/Log"

MobObject = inheritsFrom(MovableObject)

MobObject.IDLE = 1;
MobObject.MOVING = 2;
MobObject.DEAD = 3;
MobObject.LAST_STATE = 4;

MobObject.mState = MobObject.IDLE;
MobObject.mPath = nil;
MobObject.mTrigger = nil;
MobObject.mStateMachine = nil;
MobObject.mFreePoints = nil;

MobObject.DIRECTIONS = {
    SIDE = 1,
    FRONT = 2,
    BACK = 3
};

MobObject.mAnimation = nil;

MobObject.mAnimations = nil;
MobObject.mTimeDestroy = nil;
MobObject.mSize = nil;

---------------------------------
function MobObject:destroy()
    info_log("MobObject:destroy ");

    MobObject:superClass().destroy(self);

    self:destroyAnimation();
end

---------------------------------
function MobObject:destroyAnimation()
    if self.mAnimations then
        for i, animation in pairs(self.mAnimations) do
            if animation then
                animation:destroy();
            end
        end
    end
end

--------------------------------
function MobObject:getCurrentAnimationDir()
    return self.mAnimation;
end

--------------------------------
function MobObject:getAnimation(dir)
    return self.mAnimations[dir];
end

--------------------------------
function MobObject:getAnimationByDirection()
    if self.mStateMachine then
        local stateAnim = self.mStateMachine:getAnimationByDirection();
        if stateAnim then
            return stateAnim;
        end
    end

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

	local action = cc.Animate:create(animation);
	local repeatForever = CCRepeatForever:create(action);
	self.mNode:runAction(repeatForever);
end

--------------------------------
function MobObject:onPlayerEnterImpl(player, pos)
	info_log("MobObject.onPlayerEnterImpl ", player.mNode:getTag());

    if self.mStateMachine then
        self.mStateMachine:onPlayerEnter(player, self.mField);
    end
end

--------------------------------
function MobObject:onPlayerEnter(player, pos)
    self:onPlayerEnterImpl(player, pos);
end

--------------------------------
function MobObject:getBonus()
    return 100;
end

--------------------------------
function MobObject:onPlayerLeave(player)
    self:onPlayerLeaveImpl(player);
end

--------------------------------
function MobObject:onPlayerLeaveImpl(player)
    info_log("MobObject.onPlayerLeaveImpl");
    --player:leaveTrap(nil);
end

---------------------------------
function MobObject:onStateInGame()
    MobObject:superClass().onStateInGame(self);
    self.mAnimations[self.mAnimation]:play();
end

---------------------------------
function MobObject:onStatePause()
    info_log("MobObject:onStatePause");
    MobObject:superClass().onStatePause(self);
    if self.mAnimation then
        self.mAnimations[self.mAnimation]:stop();
    end
end

---------------------------------
function MobObject:onStateWin()
	info_log("MobObject:onStateWin ", self.mTrigger);
	MobObject:superClass().onStateWin(self);
    if self.mTrigger then
        self.mTrigger:setEnterCallback(nil);
    end
end

--------------------------------
function MobObject:createTrigger()
    self.mTrigger = SnareTrigger:create();
    self.mTrigger:init(self.mField, self.mNode, Callback.new(self, MobObject.onPlayerEnter), Callback.new(self, MobObject.onPlayerLeave));
end

--------------------------------
function MobObject:init(field, node)
	info_log("MobObject:init(", node, ")");
	MobObject:superClass().init(self, field, node);

	self.mState = MobObject.IDLE;
	self.mVelocity = self.mVelocity * field.mGame:getScale();

	-- set size of cell
	self.mNode:setContentSize(cc.size(self.mField:getCellSize(), self.mField:getCellSize()));

    self:createTrigger();

    -- create animation
	self:initAnimation();

    --self:fillFreePoint();
end

--------------------------------
function MobObject:postInit()
    self:fillFreePoint();
end

--------------------------------
function MobObject:fillFreePoint()
    self.mFreePoints = {};
    self.mField:fillFreePoint(self.mGridPosition, self.mFreePoints);
    info_log("MobObject:fillFreePoint id ", self:getId(), " free points ", #self.mFreePoints);
end


--------------------------------
function MobObject:getDestPoint()
    local points = {}
	local freePoints = self.mFreePoints; --self.mField:getFreePoints();

    for i, point in ipairs(freePoints) do
        if point ~= self.mGridPosition then
            table.insert(points, Vector.new(point.x, point.y));
        end
    end

	return points[math.random(#points)];
end

--------------------------------
function MobObject:resetMovingParams()
    MobObject:superClass().resetMovingParams(self);
    self.mPath = {}
end

--------------------------------
function MobObject:moveToNextPoint()
	if #self.mPath == 0 then
        info_log("MobObject:moveToNextPoint empty path ", " id ", self:getId());
        self:resetMovingParams();
		return false;
	end
	self:moveTo(self.mPath[1]);
	table.remove(self.mPath, 1);
    return true;
end

--------------------------------
function MobObject:onMoveFinished()
    if self.mStateMachine then
        self.mStateMachine:onMoveFinished();
    end
end

---------------------------------
function MobObject:onEnterFightTrigger()
    info_log ("MobObject:onEnterFightTrigger");
    self:onEnterFightTriggerImpl();
end

---------------------------------
function MobObject:onEnterFightTriggerImpl()
    --self.mTimeDestroy = 0.5;
    --self.mState = MobObject.DEAD;
    self.mStateMachine:onEnterFightTrigger();
--    self.mNode:stopAllActions();
end

--------------------------------
function MobObject:moveByPath(path)
    self.mPath = path;
    if #self.mPath > 0 then
        table.remove(self.mPath, 1);
    end
    self:moveToNextPoint();
end

--------------------------------
function MobObject:startMoving(destPoint)
    -- clone field
    local cloneArray = self.mField:cloneArray();
    info_log ("MobObject:startMoving destPoint ", destPoint.x, "y ", destPoint.y, " id ", self:getId());
    self.mPath = WavePathFinder.buildPath(self.mGridPosition, destPoint, cloneArray, self.mField.mSize);
    if #self.mPath > 0 then
        table.remove(self.mPath, 1);
    end
    info_log ("MobObject:startMoving end");
    return self:moveToNextPoint();
end

--------------------------------
function MobObject:getFlipByDirection()

    if self.mStateMachine then
        local flip = self.mStateMachine:getFlipByDirection(self.mDelta);
        if flip ~= nil then
            return flip;
        end
    end

    if not self.mDelta then
        return nil;
    end

    local val = self.mDelta:normalized();
    return val.x < 0;
end

--------------------------------
function MobObject:updateFlip()
    local flip = self:getFlipByDirection();
    if flip ~= nil then
        tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(flip);
    end
end

--------------------------------
function MobObject:tick(dt)
	MobObject:superClass().tick(self, dt);

	if self.mTrigger then
		self.mTrigger:tick(dt);
	end

    if self.mAnimation and self.mAnimations[self.mAnimation] then
        self.mAnimations[self.mAnimation]:tick(dt);
    end

    self:updateFlip();

    local anim = self:getAnimationByDirection();
    if anim ~= self.mAnimation and self.mAnimations ~= nil then
        self.mAnimation = anim;
        self.mNode:stopAllActions();
        self.mAnimations[self.mAnimation]:play();
    end

    if self.mStateMachine then
        self.mStateMachine:tick(dt);
    end

end
