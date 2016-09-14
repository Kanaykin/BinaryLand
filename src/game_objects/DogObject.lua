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
DogObject.mPlayerFollowAnimations = nil;

DogObject.mFoundPlayerPos = nil;
DogObject.mPlayerTrace = nil;
DogObject.mGridPosGetTrace = nil;
DogObject.mCanSearch = false;

--------------------------------
function DogObject:init(field, node)
    DogObject:superClass().init(self, field, node);
    info_log("DogObject:init(", node, " id ", self:getId(), ")");
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
function DogObject:swapFollowAnimations()
    self:swapAnimation(self.mAnimations, self.mPlayerFollowAnimations, MobObject.DIRECTIONS.SIDE);
    self:swapAnimation(self.mAnimations, self.mPlayerFollowAnimations, MobObject.DIRECTIONS.FRONT);
    self:swapAnimation(self.mAnimations, self.mPlayerFollowAnimations, MobObject.DIRECTIONS.BACK);
    self.mAnimation = nil
end

--------------------------------
function DogObject:createSideAnimationImpl(name, container, direct)
    local animation = PlistAnimation:create();
    animation:init(name, self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local sideAnimation = RepeatAnimation:create();
    sideAnimation:init(animation);

    container[direct] = sideAnimation;
end

--------------------------------
function DogObject:createSideAnimation()
    self:createSideAnimationImpl("DogWalk.plist", self.mAnimations, MobObject.DIRECTIONS.SIDE);
    self:createSideAnimationImpl("DogRun.plist", self.mRunAnimations, MobObject.DIRECTIONS.SIDE);
    self:createSideAnimationImpl("DogPlayerFollow.plist", self.mPlayerFollowAnimations, MobObject.DIRECTIONS.SIDE);
end

--------------------------------
function DogObject:createFrontAnimation()
    self:createSideAnimationImpl("DogWalkFront.plist", self.mAnimations, MobObject.DIRECTIONS.FRONT);
    self:createSideAnimationImpl("DogRunFront.plist", self.mRunAnimations, MobObject.DIRECTIONS.FRONT);
    self:createSideAnimationImpl("DogPlayerFollowFront.plist", self.mPlayerFollowAnimations, MobObject.DIRECTIONS.FRONT);
end

--------------------------------
function DogObject:createBackAnimation()
    self:createSideAnimationImpl("DogWalkBack.plist", self.mAnimations, MobObject.DIRECTIONS.BACK);
    self:createSideAnimationImpl("DogRunBack.plist", self.mRunAnimations, MobObject.DIRECTIONS.BACK);
    self:createSideAnimationImpl("DogPlayerFollowBack.plist", self.mPlayerFollowAnimations, MobObject.DIRECTIONS.BACK);
end

--------------------------------
function DogObject:initAnimation()
	info_log("HunterObject:initAnimation");

	info_log("DogObject Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
    self.mAnimations = {}
    self.mRunAnimations = {};
    self.mPlayerFollowAnimations = {};

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
    -- #todo: valid point for dog
    -- fill array and find point 
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
    -- not found in safe distance
    if #safePoints == 0 then
        for i, point in ipairs(freePoints) do
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
    self.mField:onDogFoundPlayer(self, pos);
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
    local awayPoints = {};

    -- fill grid and find all point on first line
    local cloneArray = self.mField:cloneArray();
    local fieldSize = self.mField:getSize();
    WavePathFinder.fillArray({self.mGridPosition}, Vector.new(-1, -1), cloneArray, fieldSize,
        WavePathFinder.FIRST_INDEX + 1);

    for i = 1, fieldSize.x do
        local val = cloneArray[COORD(i, 1, fieldSize.x)];
        debug_log(" point i= ", i, " y= 1 val= ", val);
        if val > 1 then
            table.insert(awayPoints, Vector.new(i, 1));
        end
    end

    debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
    
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
function DogObject:resetPlayerTrace()
    debug_log("DogObject:resetPlayerTrace ");
    self.mPlayerTrace = nil;
end

--------------------------------
function DogObject:getPlayerTrace()
    return self.mPlayerTrace;
end

---------------------------------
function DogObject:setCustomProperties(properties)
    info_log("DogObject:setCustomProperties ");

    DogObject:superClass().setCustomProperties(self, properties);

    if properties.CanSearch then
        info_log("BonusObject:setCustomProperties CanSearch ", properties.CanSearch);
        self.mCanSearch = properties.CanSearch;
    end
end

--------------------------------
function DogObject:tick(dt)
	DogObject:superClass().tick(self, dt);

    --debug_log("DogObject:tick self.mPlayerTrace ", self.mPlayerTrace)
    --debug_log("DogObject:tick gridPosition.x ", self.mGridPosition.x, " gridPosition.y ", self.mGridPosition.y);
    if self.mGridPosGetTrace ~= self.mGridPosition then
        self.mGridPosGetTrace = self.mGridPosition;
        local players = self.mField:getPlayerObjects();
        for i, player in pairs(players) do
            if not player:isInTrap() and self.mCanSearch then
                local trace = player:getTrace():findTrace(self.mGridPosition);
                -- debug_log("DogObject:tick id ", self:getId(), " trace ", trace)
                --if trace then
                self.mPlayerTrace = trace;
                    --self.mStateMachine:onPlayerTraceFound(trace);
                --end
                if trace then
                    break;
                end
            end
        end
    end
end