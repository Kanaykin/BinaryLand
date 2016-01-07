require "src/game_objects/MobStates.lua"

HunterStates = {
    HS_CATCH_PLAYER = MobStates.MS_LAST + 1, --5
    HS_FOUND_PLAYER = MobStates.MS_LAST + 2, --6
    HS_SHOT_GUN = MobStates.MS_LAST + 3 --7
}

--[[///////////////////////////]]
ShotGunState = inheritsFrom(BaseMobState)
ShotGunState.mDir = nil;
ShotGunState.mFlip = nil;
ShotGunState.mShoted = nil;
ShotGunState.mFoxPos = nil;

------------------------------------
function ShotGunState:getAnimationByDirection()
    return self.mDir;
end

------------------------------------
function ShotGunState:getFlipByDirection(dir)
    debug_log("ShotGunState:getFlipByDirection self.mFlip ", self.mFlip);
    return self.mFlip;
end

------------------------------------
function ShotGunState:enter(params)
    debug_log("ShotGunState:enter");

    local curPos = self.mObject:getGridPosition();
    local foxPos = params.foxPos;
    self.mFoxPos = foxPos;

    if foxPos.y < curPos.y then
        self.mDir = HunterObject.DIRECTIONS.SHOT_FRONT;
    elseif foxPos.y > curPos.y then
        self.mDir = HunterObject.DIRECTIONS.SHOT_BACK;
    else
        self.mDir = HunterObject.DIRECTIONS.SHOT_SIDE;

        self.mFlip = (foxPos.x - curPos.x) < 0;
        debug_log("ShotGunState:enter foxPos.x ", foxPos.x, " curPos.x ",  curPos.x);
        debug_log("ShotGunState:enter self.mFlip ", self.mFlip);
    end

    self.mObject:resetMovingParams();
end

------------------------------------
function ShotGunState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

------------------------------------
function ShotGunState:onDogPlayerFound(playerPos)
    self.mStateMachine:setState(HunterStates.HS_FOUND_PLAYER, {playerPos = playerPos});
end

------------------------------------
function ShotGunState:leave(state)
    debug_log("ShotGunState:leave");
    if state == MobStates.HS_DEAD then
        return true;
    end
    if self.mObject:getCurrentAnimationDir() == self.mDir then
        return self.mObject:getAnimation(self.mDir):isDone();
    end
    return true;
end

------------------------------------
function ShotGunState:tick(dt)
    ShotGunState:superClass().tick(self, dt);
    debug_log("ShotGunState:tick ");

    if self.mObject:getCurrentAnimationDir() == self.mDir then
        local frame = self.mObject:getAnimation(self.mDir):getCurrentFrameIndex();
        if frame == 7 and not self.mShoted then
            self.mObject:createBullet(self.mFoxPos);
            self.mShoted = true;
        end

        if self.mObject:getAnimation(self.mDir):isDone() then
            self.mStateMachine:setState(MobStates.MS_IDLE);
            self.mObject:resetFoxGoalPos();
        end
    end
end

--[[///////////////////////////]]
CatchState = inheritsFrom(BaseMobState)
CatchState.mTimeWait = nil

------------------------------------
function CatchState:tick(dt)
    info_log("CatchState:tick ");
    CatchState:superClass().tick(self, dt);
    if self.mTimeWait == nil then
        self.mTimeWait = 0.5;
    end
    self.mTimeWait = self.mTimeWait - dt;
    if self.mTimeWait < 0 then
        self.mStateMachine:setState(MobStates.MS_IDLE);
    end
end

------------------------------------
function CatchState:enter(params)
    debug_log("CatchState:enter");

    if not params.player:isInTrap() then
        params.field:createSnareTrigger(Vector.new(params.player.mNode:getPosition()));
    end

    self.mObject:resetMovingParams();
end

------------------------------------
function CatchState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

--[[///////////////////////////]]
HunterMoveState = inheritsFrom(MoveState)

------------------------------------
function HunterMoveState:onPlayerEnter(player, field)
    debug_log("HunterMoveState:onPlayerEnter ");
    self.mStateMachine:setState(HunterStates.HS_CATCH_PLAYER, {player = player, field = field});
end

------------------------------------
function HunterMoveState:onDogPlayerFound(playerPos)
    self.mStateMachine:setState(HunterStates.HS_FOUND_PLAYER, {playerPos = playerPos});
end

------------------------------------
function HunterMoveState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

------------------------------------
function HunterMoveState:tick(dt)
    HunterMoveState:superClass().tick(self, dt);
    local foxPos = self.mObject:getFoxGoalPos();
    if foxPos then
        self.mStateMachine:setState(HunterStates.HS_SHOT_GUN, {foxPos = foxPos});
    end
end

--[[///////////////////////////]]
FoundPlayerState = inheritsFrom(BaseMobState)

------------------------------------
function FoundPlayerState:enter(params)
    debug_log("FoundPlayerState:enter");

    self.mObject.oldVelocity = self.mObject.mVelocity;
    self.mObject.mVelocity = self.mObject.mVelocity * 4;
    self.mObject.mPath = {};
    self.mObject:startMoving(params.playerPos);
end

------------------------------------
function FoundPlayerState:leave(state)
    debug_log("FoundPlayerState:leave");

    self.mObject.mVelocity = self.mObject.oldVelocity;
    self.mObject.oldVelocity = nil;
    return true;
end

------------------------------------
function FoundPlayerState:onMoveFinished()
    if not self.mObject:moveToNextPoint() then
        debug_log("FoundPlayerState:onMoveFinished don't move");
        self.mStateMachine:setState(MobStates.MS_IDLE);
    end
end

------------------------------------
function FoundPlayerState:onPlayerEnter(player, field)
    debug_log("FoundPlayerState:onPlayerEnter ");
    self.mStateMachine:setState(HunterStates.HS_CATCH_PLAYER, {player = player, field = field});
end

------------------------------------
function FoundPlayerState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

------------------------------------
function FoundPlayerState:onDogPlayerRunAway()
    self.mStateMachine:setState(MobStates.MS_MOVE);
end

--[[///////////////////////////]]
HunterIdleState = inheritsFrom(IdleState)
HunterIdleState.mNeedCautionAnim = false;

------------------------------------
function HunterIdleState:enter(params)
    HunterIdleState:superClass().enter(self, params);
    local dirMoving = self.mObject:getCurrentAnimationDir();
    if dirMoving ~= MobObject.DIRECTIONS.BACK and params.prevState == MobStates.MS_MOVE then
        local rand = math.random(100) % 2;
        debug_log("HunterIdleState:enter rand ", rand);
        if rand == 0 then
            self.mNeedCautionAnim = true;
        end
    end
end

------------------------------------
function HunterIdleState:tick(dt)
    if not self.mNeedCautionAnim then
        self.mStateMachine:setState(MobStates.MS_MOVE);
    end
    -- check finish animation
    if self.mObject:getCurrentAnimationDir() == HunterObject.DIRECTIONS.CAUTION 
        and self.mObject:getAnimation(HunterObject.DIRECTIONS.CAUTION):isDone() then
        self.mStateMachine:setState(MobStates.MS_MOVE);
    end
end

------------------------------------
function HunterIdleState:getAnimationByDirection()
    if self.mNeedCautionAnim then
        return HunterObject.DIRECTIONS.CAUTION;
    end
    return nil;
end

------------------------------------
function HunterIdleState:onPlayerEnter(player, field)
    debug_log("HunterIdleState:onPlayerEnter ");
    self.mStateMachine:setState(HunterStates.HS_CATCH_PLAYER, {player = player, field = field});
end

------------------------------------
function HunterIdleState:onDogPlayerFound(playerPos)
    self.mStateMachine:setState(HunterStates.HS_FOUND_PLAYER, {playerPos = playerPos});
end

------------------------------------
function HunterIdleState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

--[[///////////////////////////]]
HunterStateMachine = inheritsFrom(MobStateMachine)

------------------------------------
function HunterStateMachine:init(object)
    info_log("HunterStateMachine:init ");
    HunterStateMachine:superClass().init(self, object);

    self.mFactoryStates[MobStates.MS_MOVE] = HunterMoveState;
    self.mFactoryStates[MobStates.MS_IDLE] = HunterIdleState;
    self.mFactoryStates[HunterStates.HS_CATCH_PLAYER] = CatchState;
    self.mFactoryStates[HunterStates.HS_FOUND_PLAYER] = FoundPlayerState;
    self.mFactoryStates[HunterStates.HS_SHOT_GUN] = ShotGunState;

end

------------------------------------
function HunterStateMachine:onDogPlayerFound(playerPos)
    if self.mActive.onDogPlayerFound then
        self.mActive:onDogPlayerFound(playerPos);
    end
end

------------------------------------
function HunterStateMachine:onDogPlayerRunAway()
    if self.mActive.onDogPlayerRunAway then
        self.mActive:onDogPlayerRunAway();
    end
end
