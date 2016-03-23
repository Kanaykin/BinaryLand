require "src/base/Inheritance"
require "src/game_objects/BaseStates"

MobStates = {
    MS_MOVE = 1,
    MS_IDLE = 2,
    HS_DEAD = 3,
    MS_LAST = 4,
}


--[[///////////////////////////]]
BaseMobState = inheritsFrom(BaseState)
BaseMobState.mId = nil

------------------------------------
function BaseMobState:onPlayerEnter(player, field)
end

------------------------------------
function BaseMobState:onMoveFinished()
end

------------------------------------
function BaseMobState:onEnterFightTrigger()
end

--[[///////////////////////////]]
MoveState = inheritsFrom(BaseMobState)

------------------------------------
function MoveState:init(object, stateMachine)
    info_log("MoveState:init ");
    MoveState:superClass().init(self, object, stateMachine);
end

------------------------------------
function MoveState:enter(params)
    info_log("MoveState:enter");
    local destPoint = self.mObject:getDestPoint();
    info_log("MoveState:enter dest x ", destPoint.x, " y ", destPoint.y);
    self.mObject:startMoving(destPoint);
end

------------------------------------
function MoveState:onMoveFinished()
    if not self.mObject:moveToNextPoint() then
        self.mStateMachine:setState(MobStates.MS_IDLE);
    end
end

--[[///////////////////////////]]
IdleState = inheritsFrom(BaseMobState)

------------------------------------
function IdleState:init(object, stateMachine)
    info_log("IdleState:init ");
    IdleState:superClass().init(self, object, stateMachine);
end

------------------------------------
function IdleState:tick(dt)
    debug_log("IdleState:tick ");
    self.mStateMachine:setState(MobStates.MS_MOVE);
end

--[[///////////////////////////]]
DeadState = inheritsFrom(BaseMobState)
DeadState.mTimeWait = nil

------------------------------------
function DeadState:removeObject()
    self.mObject.mField:addBonus(self.mObject);
    self.mObject.mField:removeObject(self.mObject);
    self.mObject.mField:removeEnemy(self.mObject)
    self.mObject:destroy();
end

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

        self:removeObject();

    end
end

------------------------------------
function DeadState:enter(params)
    debug_log("DeadState:enter");
    self.mObject:resetMovingParams();
end


--[[///////////////////////////]]
MobStateMachine = inheritsFrom(StateMachine)

------------------------------------
function MobStateMachine:init(object)
    MobStateMachine:superClass().init(self, object);
    self.mFactoryStates = {
        [MobStates.MS_IDLE] = IdleState,
        [MobStates.MS_MOVE] = MoveState,
        [MobStates.HS_DEAD] = DeadState
    }

    if not self.mCurrent then
        self.mCurrent = self:createState(object, MobStates.MS_IDLE);
        self.mActive = self.mCurrent;
    end
end

------------------------------------
function MobStateMachine:onMoveFinished()
    self.mActive:onMoveFinished();
end

------------------------------------
function MobStateMachine:onPlayerEnter(player, field)
    self.mActive:onPlayerEnter(player, field);
end

------------------------------------
function MobStateMachine:onEnterFightTrigger()
    self.mActive:onEnterFightTrigger();
end


------------------------------------
function MobStateMachine:getFlipByDirection(dir)
    if self.mActive.getFlipByDirection then
        return self.mActive:getFlipByDirection(dir);
    else
        return nil;
    end
end

------------------------------------
function MobStateMachine:getAnimationByDirection()
    if self.mActive.getAnimationByDirection then
        return self.mActive:getAnimationByDirection();
    else
        return nil;
    end
end

