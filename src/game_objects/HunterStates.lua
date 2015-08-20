require "src/game_objects/MobStates.lua"

HunterStates = {
    HS_DEAD = MobStates.MS_LAST + 1,
    HS_CATCH_PLAYER = MobStates.MS_LAST + 2,
    HS_FOUND_PLAYER = MobStates.MS_LAST + 3
}

--[[///////////////////////////]]
DeadState = inheritsFrom(BaseState)
DeadState.mTimeWait = nil

------------------------------------
function DeadState:tick(dt)
    info_log("DeadState:tick ");
    DeadState:superClass().tick(self, dt);
    if self.mTimeWait == nil then
        self.mTimeWait = 0.5;
    end
    self.mTimeWait = self.mTimeWait - dt;
    if self.mTimeWait < 0 then
        --self.mStateMachine:setState(MobStates.MS_IDLE);

        self.mObject.mField:addBonus(self.mObject);
        self.mObject.mField:removeObject(self.mObject);
        self.mObject.mField:removeEnemy(self.mObject)
        self.mObject:destroy();

    end
end

------------------------------------
function DeadState:enter(params)
    debug_log("DeadState:enter");
    self.mObject:resetMovingParams();
end

--[[///////////////////////////]]
CatchState = inheritsFrom(BaseState)
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
    self.mStateMachine:setState(HunterStates.HS_DEAD);
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
    self.mStateMachine:setState(HunterStates.HS_DEAD);
end

--[[///////////////////////////]]
FoundPlayerState = inheritsFrom(BaseState)

------------------------------------
function FoundPlayerState:enter(params)
    debug_log("FoundPlayerState:enter");

    self.mObject.oldVelocity = self.mObject.mVelocity;
    self.mObject.mVelocity = self.mObject.mVelocity * 4;
    self.mObject.mPath = {};
    self.mObject:startMoving(params.playerPos);
end

------------------------------------
function FoundPlayerState:leave()
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
    self.mStateMachine:setState(HunterStates.HS_DEAD);
end

------------------------------------
function FoundPlayerState:onDogPlayerRunAway()
    self.mStateMachine:setState(MobStates.MS_MOVE);
end

--[[///////////////////////////]]
HunterStateMachine = inheritsFrom(StateMachine)

------------------------------------
function HunterStateMachine:init(object)
    info_log("HunterStateMachine:init ");
    HunterStateMachine:superClass().init(self, object);

    self.mFactoryStates[HunterStates.HS_DEAD] = DeadState;
    self.mFactoryStates[MobStates.MS_MOVE] = HunterMoveState;
    self.mFactoryStates[HunterStates.HS_CATCH_PLAYER] = CatchState;
    self.mFactoryStates[HunterStates.HS_FOUND_PLAYER] = FoundPlayerState;

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
