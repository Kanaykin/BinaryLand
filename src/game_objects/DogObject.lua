require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/animations/RepeatAnimation"
require "src/base/Log"

DogObject = inheritsFrom(MobObject)

DogObject.FOUND_PLAYER = MobObject.LAST_STATE + 1;
DogObject.RUN_AWAY = DogObject.FOUND_PLAYER + 1;
DogObject.BARK_ANIMATION = 4;

DogObject.SAFE_DISTANCE = 2;
DogObject.oldVelocity = nil;

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
    if self.mState ~= MobObject.DEAD and self.mState ~= DogObject.RUN_AWAY then
        self.mState = DogObject.FOUND_PLAYER;
        self.mDelta = nil;
        self.mMoveTime = 0;
    end
end

--------------------------------
function DogObject:onPlayerLeaveImpl(player)
    info_log("DogObject.onPlayerLeaveImpl");
    if self.mState == DogObject.FOUND_PLAYER then
        self.mState = MobObject.IDLE;
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
            (math.abs(point.y - self.mGridPosition.y) > DogObject.SAFE_DISTANCE) then

            debug_log("i ", i, "x ", point.x, "y ", point.y);
            table.insert(safePoints, Vector.new(point.x, point.y));
        end
    end

    return safePoints[math.random(#safePoints)];
end

---------------------------------
function DogObject:onEnterFightTriggerImpl()
    if self.mState ~= DogObject.RUN_AWAY then
        -- move to safe for player point
        local point = self:getSafePlayerPoints();
        if point and not self.oldVelocity then
            self.oldVelocity = self.mVelocity;
            self.mVelocity = self.mVelocity * 4;
            --self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
            self.mPath = {};
            self:startMoving(point);
            self.mState = DogObject.RUN_AWAY;
        end
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
    DogObject:superClass().onMoveFinished(self);
end

--------------------------------
function DogObject:tick(dt)
    --debug_log("DogObject:tick x ", self.mGridPosition.x, " y ", self.mGridPosition.y, " id ", self:getId());
	DogObject:superClass().tick(self, dt);
end