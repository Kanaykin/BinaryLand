require "src/game_objects/MobObject"
require "src/game_objects/BulletObject"
require "src/animations/PlistAnimation"
require "src/base/Log"
require "src/game_objects/HunterStates"

HunterObject = inheritsFrom(MobObject)
HunterObject.oldVelocity = nil;
HunterObject.FOUND_PLAYER = MobObject.LAST_STATE + 1;
HunterObject.mGridPosGetTrace = nil;
HunterObject.mFoxGoalPos = nil;
HunterObject.mFoxGridGoalPos = nil;
HunterObject.mCanAttack = false;
HunterObject.mDog = nil;
HunterObject.mIsDead = false;

--shot constants
HunterObject.SHOT_PIXELS_DELTA = 10
HunterObject.SHOT_MIN_GRID_DELTA = 3
HunterObject.SHOT_MAX_GRID_DELTA = 16

HunterObject.DIRECTIONS = {
    CAUTION = MobObject.DIRECTIONS.BACK + 1,
    SHOT_SIDE = MobObject.DIRECTIONS.BACK + 2,
    SHOT_BACK = MobObject.DIRECTIONS.BACK + 3,
    SHOT_FRONT = MobObject.DIRECTIONS.BACK + 4,
    DEAD_SIDE = MobObject.DIRECTIONS.BACK + 5,
    DEAD_BACK = MobObject.DIRECTIONS.BACK + 6,
    DEAD_FRONT = MobObject.DIRECTIONS.BACK + 7
}

--------------------------------
function HunterObject:init(field, node)
    HunterObject:superClass().init(self, field, node);
    info_log("HunterObject:init(", node, " id ", self:getId(), ")");
    self.mStateMachine = HunterStateMachine:create();
    self.mStateMachine:init(self);
    self.mFoxGridGoalPos = nil;
end

--------------------------------
function HunterObject:createRepeateAnimation(nameAnimation, dir)
    local animation = PlistAnimation:create();
    animation:init(nameAnimation, self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local repeateAnimation = RepeatAnimation:create();
    repeateAnimation:init(animation);
    self.mAnimations[dir] = repeateAnimation;
    return repeateAnimation;
end

--------------------------------
function HunterObject:createPlistAnimation(nameAnimation, dir, time)
    local animation = PlistAnimation:create();
    animation:init(nameAnimation, self.mNode, self.mNode:getAnchorPoint(), nil, time);
    self.mAnimations[dir] = animation;
end

--------------------------------
function HunterObject:initAnimation()
	info_log("HunterObject:initAnimation");
    self.mAnimations = {};

	info_log("HunterObject Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());

	local sideAnimation = self:createRepeateAnimation("HunterWalkSide.plist", MobObject.DIRECTIONS.SIDE);
	sideAnimation:play();

    self.mAnimation = MobObject.DIRECTIONS.SIDE;

    ------------------------
    -- Front animation
    self:createRepeateAnimation("HunterWalkFront.plist", MobObject.DIRECTIONS.FRONT);

    ------------------------
    -- Back animation
    self:createRepeateAnimation("HunterWalkBack.plist", MobObject.DIRECTIONS.BACK);

    ------------------------
    -- caution animation
    self:createPlistAnimation("HunterCaution.plist", HunterObject.DIRECTIONS.CAUTION, 0.3);

    ------------------------
    -- Shot animation
    self:createPlistAnimation("HunterShotSide.plist", HunterObject.DIRECTIONS.SHOT_SIDE, 0.15);

    ------------------------
    -- Shot animation
    self:createPlistAnimation("HunterShotFront.plist", HunterObject.DIRECTIONS.SHOT_FRONT, 0.15);

    ------------------------
    -- Shot animation
    self:createPlistAnimation("HunterShotBack.plist", HunterObject.DIRECTIONS.SHOT_BACK, 0.15);

    ------------------------
    -- Dead animation
    self:createPlistAnimation("HunterDieSide.plist", HunterObject.DIRECTIONS.DEAD_SIDE, 0.06);

    ------------------------
    -- Dead animation
    self:createPlistAnimation("HunterDieFront.plist", HunterObject.DIRECTIONS.DEAD_FRONT, 0.06);

    ------------------------
    -- Dead animation
    self:createPlistAnimation("HunterDieBack.plist", HunterObject.DIRECTIONS.DEAD_BACK, 0.06);
end

---------------------------------
function HunterObject:setCustomProperties(properties)
    HunterObject:superClass().setCustomProperties(self, properties);

    info_log("HunterObject:setCustomProperties CanAttack ", properties.CanAttack);
    if properties.CanAttack then
        self.mCanAttack = properties.CanAttack;
    end
end

--------------------------------
function HunterObject:onMoveFinished( )
    info_log ("HunterObject:onMoveFinished #self.mPath ", #self.mPath);
    if self.oldVelocity and #self.mPath == 0 then
        debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
        self.mVelocity = self.oldVelocity;
        self.oldVelocity = nil;
    end
    HunterObject:superClass().onMoveFinished(self);
end

---------------------------------
function HunterObject:onEnterFightTriggerImpl()
    HunterObject:superClass().onEnterFightTriggerImpl(self);
    self.mIsDead = true;
    self.mField:onHunterDead(self);
end

--------------------------------
function HunterObject:isDead()
    return self.mIsDead;
end

--------------------------------
function HunterObject:onDogFoundPlayer(dog, pos)
    if dog then
        self.mStateMachine:onDogPlayerFound(pos);
    elseif self.mDog then
        self.mStateMachine:onDogPlayerRunAway();
    end
    self.mDog = dog;
end

--------------------------------
function HunterObject:getDog()
    return self.mDog
end

--------------------------------
function HunterObject:getFoxGoalPos()
    return self.mFoxGoalPos;
end

--------------------------------
function HunterObject:resetFoxGoalPos()
    self.mFoxGoalPos = nil
end

--------------------------------
function HunterObject:createBullet(goalPos)
    local bullet = BulletObject:create();
    debug_log("HunterObject:createBullet goalPos ", goalPos.x, ", ", goalPos.y)
    local selfPos = self:getPosition();
    --local dir = (goalPos - self.mGridPosition):normalized();-- * self.mField:getCellSize();

    local hubterpos = self.mField:gridPosToReal(self.mGridPosition)
    debug_log("HunterObject:createBullet selfPos ", hubterpos.x, ", ", hubterpos.y)
    bullet:init(self.mField, selfPos, goalPos);
    self.mField:addObject(bullet);

    SimpleAudioEngine:getInstance():playEffect(gSounds.HUNTER_SHOT_SOUND);
end

--------------------------------
function HunterObject:checkShotLine(playerPosGrid, selfPosGrid, delta)
    debug_log("HunterObject:checkShotLine ", playerPosGrid, ", ", selfPosGrid);
    return playerPosGrid == selfPosGrid and delta > HunterObject.SHOT_MIN_GRID_DELTA and delta < HunterObject.SHOT_MAX_GRID_DELTA;
end

--------------------------------
function HunterObject:tryShotGun()
    
    if self.mGridPosGetTrace ~= self.mGridPosition or self.mFoxGridGoalPos == self.mGridPosGetTrace then
        self.mGridPosGetTrace = self.mGridPosition;
        debug_log("self.mField:isFreePoint check trace x ", self.mGridPosGetTrace.x, " y ", self.mGridPosGetTrace.y);
        self.mFoxGoalPos = nil;
        self.mFoxGridGoalPos = nil;

        local players = self.mField:getPlayerObjects();
        for i, player in pairs(players) do
            local pos = player:getGridPosition();

            -- check on the one line
            if not player:isInTrap() then
            if self:checkShotLine(pos.x, self.mGridPosition.x, math.abs(pos.y - self.mGridPosition.y)) then
                -- check barrier
                local all_point_free = true;
                local delta = self.mGridPosition.y > pos.y and 1 or -1;
                for j = pos.y, self.mGridPosition.y, delta do
                    if not self.mField:isFreePointForPlayer( Vector.new(pos.x, j) ) then
                        all_point_free = false;
                    end
                end

                if all_point_free then
                    --debug_log("self.mField:isFreePoint FREE X !!!");
                    --debug_log("self.mField:isFreePoint player postion x ", pos.x, " y ", pos.y);
                    --debug_log("self.mField:isFreePoint hunter postion x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
                    
                    self.mFoxGridGoalPos = self.mGridPosGetTrace;

                    if math.abs(player:getPosition().x - self:getPosition().x) < HunterObject.SHOT_PIXELS_DELTA then
                        self.mFoxGoalPos = pos;
                        local newPos = Vector.new(self.mFoxGoalPos.x, self.mFoxGoalPos.y - delta);
                        while self.mField:isFreePointForPlayer( newPos ) do
                            self.mFoxGoalPos = newPos;
                            newPos = Vector.new(self.mFoxGoalPos.x, self.mFoxGoalPos.y - delta);
                        end

                    end
                    break;
                end

            elseif self:checkShotLine(pos.y, self.mGridPosition.y, math.abs(pos.x - self.mGridPosition.x)) then
                -- check barrier
                local all_point_free = true;
                local delta = self.mGridPosition.x > pos.x and 1 or -1;
                for j = pos.x, self.mGridPosition.x, delta do
                    if not self.mField:isFreePointForPlayer( Vector.new(j, pos.y) ) then
                        all_point_free = false;
                    end
                end

                if all_point_free then
                    --debug_log("self.mField:isFreePoint FREE Y !!!");
                    --debug_log("self.mField:isFreePoint player postion x ", pos.x, " y ", pos.y);
                    --debug_log("self.mField:isFreePoint hunter postion x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
                    self.mFoxGridGoalPos = self.mGridPosGetTrace;

                    if math.abs(player:getPosition().y - self:getPosition().y) < HunterObject.SHOT_PIXELS_DELTA then
                        self.mFoxGoalPos = pos;
                        local newPos = Vector.new(self.mFoxGoalPos.x - delta, self.mFoxGoalPos.y );
                        while self.mField:isFreePointForPlayer( newPos ) do
                            self.mFoxGoalPos = newPos;
                            debug_log("self.mField:isFreePoint self.mFoxGoalPos.x ", self.mFoxGoalPos.x);
                            newPos = Vector.new(self.mFoxGoalPos.x - delta, self.mFoxGoalPos.y );
                        end
                    end
                    break;
                end
                
            end
            end
        end
    end
end

--------------------------------
function HunterObject:tick(dt)
    HunterObject:superClass().tick(self, dt);

    if self.mCanAttack then
        self:tryShotGun();
    end
end