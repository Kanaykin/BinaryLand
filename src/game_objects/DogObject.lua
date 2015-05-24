require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/animations/RepeatAnimation"
require "src/base/Log"

DogObject = inheritsFrom(MobObject)

DogObject.FOUND_PLAYER  = MobObject.LAST_STATE + 1;
DogObject.RUN_AWAY      = MobObject.LAST_STATE + 2;
DogObject.HUNTER_DEAD   = MobObject.LAST_STATE + 3;
DogObject.BARK_ANIMATION = 4;

DogObject.SAFE_DISTANCE = 2;
DogObject.oldVelocity = nil;

DogObject.mFoundPlayer = nil;
DogObject.mHunterDead = false;

--------------------------------
function DogObject:createBarkAnimation()
    local animationBark = PlistAnimation:create();
    animationBark:init("DogBark.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local repeatAnimation = RepeatAnimation:create();
    repeatAnimation:init(animationBark);
    self.mAnimations[DogObject.BARK_ANIMATION] = repeatAnimation;

end

--------------------------------
function DogObject:initAnimation()
	info_log("HunterObject:initAnimation");

	info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("DogWalk.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

	local sideAnimation = RepeatAnimation:create();
	sideAnimation:init(animation);
	sideAnimation:play();

    self.mAnimations = {}
    self.mAnimation = MobObject.DIRECTIONS.SIDE;
    self.mAnimations[MobObject.DIRECTIONS.SIDE] = sideAnimation;

    ------------------------
    -- Front animation
    local animationFront = PlistAnimation:create();
    animationFront:init("DogWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = frontAnimation;

    ------------------------
    -- Back animation
    local animationBack = PlistAnimation:create();
    animationBack:init("DogWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[MobObject.DIRECTIONS.BACK] = backAnimation;

    ------------------------
    self:createBarkAnimation();
end

--------------------------------
function DogObject:onPlayerEnterImpl(player, pos)
    info_log("DogObject.onPlayerEnterImpl ", player.mNode:getTag());
    if not player:isInTrap() and self.mState ~= MobObject.DEAD and self.mState ~= DogObject.RUN_AWAY then
        self.mState = DogObject.FOUND_PLAYER;
        self:resetMovingParams();
        self.mFoundPlayer = player;
    end
end

--------------------------------
function DogObject:onPlayerLeaveImpl(player)
    info_log("DogObject.onPlayerLeaveImpl");
    if self.mState == DogObject.FOUND_PLAYER then
        self.mState = MobObject.IDLE;
        self.mFoundPlayer = nil;
    end
end

---------------------------------
function DogObject:getSafePlayerPoints()
    info_log("DogObject:getSafePlayerPoints id ", self:getId());
    local freePoints = self.mField:getFreePoints();
    local safePoints = {};

    debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
    for i, point in ipairs(freePoints) do
        if (math.abs(point.x - self.mGridPosition.x) > DogObject.SAFE_DISTANCE) and
            (math.abs(point.y - self.mGridPosition.y) > DogObject.SAFE_DISTANCE) and
            self:inThisHalf(point) then

            debug_log("i ", i, "x ", point.x, "y ", point.y);
            table.insert(safePoints, Vector.new(point.x, point.y));
        end
    end

return safePoints[math.random(#safePoints)];
end

---------------------------------
function DogObject:getFoundPlayerPos()
    if self.mState == DogObject.FOUND_PLAYER then
        return self.mGridPosition;
    end
    return nil;
end

---------------------------------
function DogObject:runAway(point)
    if point and not self.oldVelocity then
        self:resetMovingParams();
        self.oldVelocity = self.mVelocity;
        self.mVelocity = self.mVelocity * 4;
        --self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
        self.mPath = {};
        self:startMoving(point);
        self.mState = DogObject.RUN_AWAY;
    end
end

---------------------------------
function DogObject:onEnterFightTriggerImpl()
    if self.mState ~= DogObject.RUN_AWAY then
        -- move to safe for player point
        local point = self:getSafePlayerPoints();
        self:runAway(point);
    end
end

--------------------------------
function DogObject:getAnimationByDirection()
    if self.mState == DogObject.FOUND_PLAYER then
        return DogObject.BARK_ANIMATION;
    else
        return DogObject:superClass().getAnimationByDirection(self);
    end
end

--------------------------------
function DogObject:onMoveFinished( )
    info_log ("DogObject:onMoveFinished #self.mPath ", #self.mPath);
    if self.oldVelocity and #self.mPath == 0 then
        debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
        self.mVelocity = self.oldVelocity;
        self.oldVelocity = nil;
    end
    if self.mHunterDead and #self.mPath == 0 then
        self.mTimeDestroy = 0.0;
        self.mState = MobObject.DEAD;
    end
    DogObject:superClass().onMoveFinished(self);
end

---------------------------------
function DogObject:inThisHalf(point)
    local allRight = self.mGridPosition.x <= 7 and point.x <= 7;
    local allLeft = self.mGridPosition.x > 7 and point.x > 7;
    return allRight or allLeft;
end

---------------------------------
function DogObject:getAwayPoint()
    info_log("DogObject:getAwayPoint id ", self:getId());
    local freePoints = self.mField:getFreePoints();
    local awayPoints = {};

    debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
    for i, point in ipairs(freePoints) do
        if point.y == 1 and self:inThisHalf(point) then
            debug_log("i ", i, "x ", point.x, "y ", point.y);
            table.insert(awayPoints, Vector.new(point.x, point.y));
        end
    end

    return awayPoints[math.random(#awayPoints)];
end

--------------------------------
function DogObject:getBonus()
    return nil;
end

--------------------------------
function DogObject:updateRunAwayPath()
    local newPath = {};
    for i, point in ipairs(self.mPath) do
        debug_log("DogObject:updateRunAwayPath i ", i, " point x ", point.x, " y ", point.y);
        table.insert(newPath, Vector.new(point.x, point.y));
        if point.y == 1 then
            table.insert(newPath, Vector.new(point.x, point.y - 1));
            break;
        end
    end
    self.mPath = newPath;
end

--------------------------------
function DogObject:onHunterDead()
    info_log ("DogObject:onHunterDead ");
    local awayPoint = self:getAwayPoint();
    if self.oldVelocity then
        self.mVelocity = self.oldVelocity;
        self.oldVelocity = nil;
    end
    self:runAway(awayPoint);
    self:updateRunAwayPath();
    self.mHunterDead = true;
end

--------------------------------
function DogObject:checkFoundPlayer()
    if self.mFoundPlayer and self.mFoundPlayer:isInTrap() then
        self.mState = MobObject.IDLE;
        self.mFoundPlayer = nil;
    end
end

--------------------------------
function DogObject:tick(dt)
    --debug_log("DogObject:tick x ", self.mGridPosition.x, " y ", self.mGridPosition.y, " id ", self:getId());
    self:checkFoundPlayer();
	DogObject:superClass().tick(self, dt);
end