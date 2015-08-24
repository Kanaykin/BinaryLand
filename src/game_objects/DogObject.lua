require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/animations/RepeatAnimation"
require "src/base/Log"
require "src/game_objects/DogStates.lua"

DogObject = inheritsFrom(MobObject)

DogObject.BARK_ANIMATION = 4;

DogObject.SAFE_DISTANCE = 4;
DogObject.oldVelocity = nil;

DogObject.mHunterDead = false;
DogObject.mRunAnimations = nil;
DogObject.mFoundPlayerPos = nil;

--------------------------------
function DogObject:init(field, node)
    info_log("DogObject:init(", node, ")");
    DogObject:superClass().init(self, field, node);
    self.mStateMachine = DogStateMachine:create();
    self.mStateMachine:init(self);
end

--------------------------------
function DogObject:createBarkAnimation()
    local animationBark = PlistAnimation:create();
    animationBark:init("DogBark.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local repeatAnimation = RepeatAnimation:create();
    repeatAnimation:init(animationBark);
    self.mAnimations[DogObject.BARK_ANIMATION] = repeatAnimation;

end

--------------------------------
function DogObject:swapAnimation(list1, list2, type)
    local tmp = list1[type];
    list1[type] = list2[type];
    list2[type] = tmp;
end

--------------------------------
function DogObject:swapAnimations()
    self:swapAnimation(self.mAnimations, self.mRunAnimations, MobObject.DIRECTIONS.SIDE);
    self:swapAnimation(self.mAnimations, self.mRunAnimations, MobObject.DIRECTIONS.FRONT);
    self:swapAnimation(self.mAnimations, self.mRunAnimations, MobObject.DIRECTIONS.BACK);
    self.mAnimation = nil
end

--------------------------------
function DogObject:createSideAnimation()

    local animation = PlistAnimation:create();
    animation:init("DogWalk.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local sideAnimation = RepeatAnimation:create();
    sideAnimation:init(animation);

    self.mAnimations[MobObject.DIRECTIONS.SIDE] = sideAnimation;

    local animationRun = PlistAnimation:create();
    animationRun:init("DogRun.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local sideRunAnimation = RepeatAnimation:create();
    sideRunAnimation:init(animationRun);

    self.mRunAnimations[MobObject.DIRECTIONS.SIDE] = sideRunAnimation;
end

--------------------------------
function DogObject:createFrontAnimation()
    local animationFront = PlistAnimation:create();
    animationFront:init("DogWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = frontAnimation;

    local animationRunFront = PlistAnimation:create();
    animationRunFront:init("DogRunFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local frontRunAnimation = RepeatAnimation:create();
    frontRunAnimation:init(animationRunFront);
    self.mRunAnimations[MobObject.DIRECTIONS.FRONT] = frontRunAnimation;
end

--------------------------------
function DogObject:createBackAnimation()
    local animationBack = PlistAnimation:create();
    animationBack:init("DogWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[MobObject.DIRECTIONS.BACK] = backAnimation;

    local animationRunBack = PlistAnimation:create();
    animationRunBack:init("DogRunBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local backRunAnimation = RepeatAnimation:create();
    backRunAnimation:init(animationRunBack);
    self.mRunAnimations[MobObject.DIRECTIONS.BACK] = backRunAnimation;

end

--------------------------------
function DogObject:initAnimation()
	info_log("HunterObject:initAnimation");

	info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    self.mAnimations = {}
    self.mRunAnimations = {};

    self:createSideAnimation();
    self.mAnimation = MobObject.DIRECTIONS.SIDE;
    self.mAnimations[MobObject.DIRECTIONS.SIDE]:play();

    ------------------------
    -- Front animation
    self:createFrontAnimation();

    ------------------------
    -- Back animation
    self:createBackAnimation();

    ------------------------
    self:createBarkAnimation();
end

--------------------------------
function DogObject:onPlayerEnterImpl(player, pos)
    info_log("DogObject.onPlayerEnterImpl ", player.mNode:getTag());
    info_log("DogObject.onPlayerEnterImpl self.mState ", self.mState);

    self.mStateMachine:onPlayerEnter(player, pos);
end

--------------------------------
function DogObject:onPlayerLeaveImpl(player)
    info_log("DogObject.onPlayerLeaveImpl");
    
    self.mStateMachine:onPlayerLeave(player, pos);
end

---------------------------------
function DogObject:getSafePlayerPoints()
    info_log("DogObject:getSafePlayerPoints id ", self:getId());
    local freePoints = self.mField:getFreePoints();
    local safePoints = {};

    debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
    for i, point in ipairs(freePoints) do
        if ((point.x - self.mGridPosition.x)*(point.x - self.mGridPosition.x) +
            (point.y - self.mGridPosition.y)*(point.y - self.mGridPosition.y)) > DogObject.SAFE_DISTANCE * DogObject.SAFE_DISTANCE
            and self:inThisHalf(point) then

            debug_log("i ", i, "x ", point.x, "y ", point.y);
            table.insert(safePoints, Vector.new(point.x, point.y));
        end
    end

    return safePoints[math.random(#safePoints)];
end

---------------------------------
function DogObject:setState(state)
end

---------------------------------
function DogObject:setFoundPlayerPos(pos)
    self.mFoundPlayerPos = pos;
end

---------------------------------
function DogObject:getFoundPlayerPos()
    return self.mFoundPlayerPos;
end

---------------------------------
function DogObject:runAway(point)
    if point and not self.oldVelocity then
        self.oldVelocity = self.mVelocity;
        self.mVelocity = self.mVelocity * 4;
    end
    self:resetMovingParams();
    --self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
    self.mPath = {};
    self:startMoving(point);
    --self:setState(DogObject.RUN_AWAY);

end

---------------------------------
function DogObject:onEnterFightTriggerImpl()
    info_log ("DogObject:onEnterFightTriggerImpl self.mState ", self.mState);
    DogObject:superClass().onEnterFightTriggerImpl(self);
end

--------------------------------
function DogObject:getAnimationByDirection()
    local stateAnim = self.mStateMachine:getAnimationByDirection();
    return stateAnim and stateAnim or DogObject:superClass().getAnimationByDirection(self);
end

--------------------------------
function DogObject:onMoveFinished( )
    info_log ("DogObject:onMoveFinished #self.mPath ", #self.mPath);
    DogObject:superClass().onMoveFinished(self);
end

---------------------------------
function DogObject:inThisHalf(point)
    local halfField = math.ceil(self.mField:getSize().x / 2);

    debug_log("DogObject:inThisHalf point x ", point.x, "point y ", point.y, " halfField ", halfField);
    local allRight = self.mGridPosition.x <= halfField and point.x <= halfField;
    local allLeft = self.mGridPosition.x > halfField and point.x > halfField;
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
    debug_log("DogObject:updateRunAwayPath ", #self.mPath);
    local newPath = {};
    if #self.mPath == 0 and self.mGridPosition.y == 1 then
        table.insert(self.mPath, Vector.new(self.mGridPosition.x, self.mGridPosition.y));
    end
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
    self.mStateMachine:onHunterDead();
end

--------------------------------
function DogObject:tick(dt)
	DogObject:superClass().tick(self, dt);

    local players = self.mField:getPlayerObjects();
    for i, player in pairs(players) do
        player:getTrace():findTrace(self.mGridPosition);
    end
end