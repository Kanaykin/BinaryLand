require "src/game_objects/MobObject"
require "src/game_objects/BulletObject"
require "src/animations/PlistAnimation"
require "src/base/Log"
require "src/game_objects/HunterStates"

HunterObject = inheritsFrom(MobObject)
HunterObject.mDogId = nil;
HunterObject.mDog = nil;
HunterObject.oldVelocity = nil;
HunterObject.FOUND_PLAYER = MobObject.LAST_STATE + 1;
HunterObject.mFoundPlayerPos = nil;
HunterObject.mGridPosGetTrace = nil;
HunterObject.mFoxGoalPos = nil;

HunterObject.DIRECTIONS = {
    CAUTION = MobObject.DIRECTIONS.BACK + 1,
    SHOT_SIDE = MobObject.DIRECTIONS.BACK + 2,
    SHOT_BACK = MobObject.DIRECTIONS.BACK + 3,
    SHOT_FRONT = MobObject.DIRECTIONS.BACK + 4
}

--------------------------------
function HunterObject:init(field, node)
    HunterObject:superClass().init(self, field, node);
    info_log("HunterObject:init(", node, " id ", self:getId(), ")");
    self.mStateMachine = HunterStateMachine:create();
    self.mStateMachine:init(self);
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

	info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());

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
end

---------------------------------
function HunterObject:setCustomProperties(properties)
    info_log("HunterObject:setCustomProperties ");

    HunterObject:superClass().setCustomProperties(self, properties);

    if properties.dog_id then
        info_log("HunterObject:setCustomProperties dog_id ", properties.dog_id);
        self.mDogId = properties.dog_id;
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

    if self.mDog then
        self.mDog:onHunterDead();
    end
end

--------------------------------
function HunterObject:updateDog()
    -- get dog by id
    if self.mDogId and not self.mDog then
        self.mDog = self.mField:getObjectById(self.mDogId);
        info_log("HunterObject:updateDog self.mDog ", self.mDog);
    end

    if self.mDog then
        local playerPos = self.mDog:getFoundPlayerPos();
        if playerPos and not self.mFoundPlayerPos then
            debug_log("self.mStateMachine:onDogPlayerFound");
            self.mStateMachine:onDogPlayerFound(playerPos);
            self.mFoundPlayerPos = playerPos;
        elseif not playerPos and self.mFoundPlayerPos then
            debug_log("self.mStateMachine:onDogPlayerRunAway");
            self.mStateMachine:onDogPlayerRunAway();
            self.mFoundPlayerPos = nil;
        end
    end
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
function HunterObject:createBullet()
    local bullet = BulletObject:create();
    bullet:init(self.mField, self:getPosition());
    self.mField:addObject(bullet);
    bullet:moveTo(self.mFoxGoalPos);
end

--------------------------------
function HunterObject:tryShotGun()
    if self.mGridPosGetTrace ~= self.mGridPosition then
        self.mGridPosGetTrace = self.mGridPosition;
        debug_log("self.mField:isFreePoint check trace x ", self.mGridPosGetTrace.x, " y ", self.mGridPosGetTrace.y);
        self.mFoxGoalPos = nil;
        local players = self.mField:getPlayerObjects();
        for i, player in pairs(players) do
            -- check on the one line
            local pos = player:getGridPosition();
            if pos.x == self.mGridPosition.x and not player:isInTrap() then
                -- check barrier
                local all_point_free = true;
                for j = pos.y, self.mGridPosition.y, self.mGridPosition.y > pos.y and 1 or -1 do
                    if not self.mField:isFreePoint( Vector.new(pos.x, j) ) then
                        all_point_free = false;
                    end
                end

                if all_point_free then
                    debug_log("self.mField:isFreePoint FREE X !!!");
                    debug_log("self.mField:isFreePoint player postion x ", pos.x, " y ", pos.y);
                    debug_log("self.mField:isFreePoint hunter postion x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
                    self.mFoxGoalPos = pos;
                    break;
                end

            elseif pos.y == self.mGridPosition.y and not player:isInTrap() then
                -- check barrier
                local all_point_free = true;
                for j = pos.x, self.mGridPosition.x, self.mGridPosition.x > pos.x and 1 or -1 do
                    if not self.mField:isFreePoint( Vector.new(j, pos.y) ) then
                        all_point_free = false;
                    end
                end

                if all_point_free then
                    debug_log("self.mField:isFreePoint FREE Y !!!");
                    debug_log("self.mField:isFreePoint player postion x ", pos.x, " y ", pos.y);
                    debug_log("self.mField:isFreePoint hunter postion x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
                    self.mFoxGoalPos = pos;
                    break;
                end
                
            end
        end
    end
end

--------------------------------
function HunterObject:tick(dt)
    self:updateDog();
    HunterObject:superClass().tick(self, dt);

    self:tryShotGun();
end