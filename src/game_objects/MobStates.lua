require "src/base/Inheritance"

MobStates = {
    MS_MOVE = 1,
    MS_IDLE = 2,
    HS_DEAD = 3,
    MS_LAST = 4,
}


--[[///////////////////////////]]
BaseState = inheritsFrom(nil)
BaseState.mObject = nil
BaseState.mStateMachine = nil
BaseState.mId = nil

------------------------------------
function BaseState:init(object, stateMachine)
    self.mObject = object
    self.mStateMachine = stateMachine;
end

------------------------------------
function BaseState:canChange(state)
    return true
end

------------------------------------
function BaseState:onPlayerEnter(player, field)
end

------------------------------------
function BaseState:leave()
    return true
end

------------------------------------
function BaseState:enter(params)

end

------------------------------------
function BaseState:tick(dt)
end

------------------------------------
function BaseState:onMoveFinished()
end

------------------------------------
function BaseState:onEnterFightTrigger()
end

--[[///////////////////////////]]
MoveState = inheritsFrom(BaseState)

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
IdleState = inheritsFrom(BaseState)

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
StateMachine = inheritsFrom(nil)
StateMachine.mCurrent = nil
StateMachine.mActive = nil
StateMachine.mFactoryStates = nil
StateMachine.mOject = nil
StateMachine.mParams = nil

------------------------------------
function StateMachine:init(object)
    self.mFactoryStates = {
        [MobStates.MS_IDLE] = IdleState,
        [MobStates.MS_MOVE] = MoveState,
        [MobStates.HS_DEAD] = DeadState
    }

    self.mOject = object;
    if not self.mCurrent then
        self.mCurrent = self:createState(object, MobStates.MS_IDLE);
        self.mActive = self.mCurrent;
    end
end

------------------------------------
function StateMachine:tick(dt)
    if self.mCurrent ~= self.mActive then
        if self.mActive:leave() then
            if not self.mParams then
                self.mParams = {}
            end
            self.mParams.prevState = self.mActive.mId;
            self.mActive = self.mCurrent;
            self.mActive:enter(self.mParams);
        end
    end
    self.mActive:tick(dt);
end

------------------------------------
function StateMachine:createState(object, state)
    if not self.mFactoryStates[state] then
        error_log("StateMachine:createState invalid state ", state);
        return nil;
    end
    local stateObj = self.mFactoryStates[state]:create();
    stateObj:init(object, self);
    stateObj.mId = state
    return stateObj;
end

------------------------------------
function StateMachine:onMoveFinished()
    self.mActive:onMoveFinished();
end

------------------------------------
function StateMachine:onPlayerEnter(player, field)
    self.mActive:onPlayerEnter(player, field);
end

------------------------------------
function StateMachine:onEnterFightTrigger()
    self.mActive:onEnterFightTrigger();
end


------------------------------------
function StateMachine:getFlipByDirection(dir)
    if self.mActive.getFlipByDirection then
        return self.mActive:getFlipByDirection(dir);
    else
        return nil;
    end
end

------------------------------------
function StateMachine:getAnimationByDirection()
    if self.mActive.getAnimationByDirection then
        return self.mActive:getAnimationByDirection();
    else
        return nil;
    end
end

------------------------------------
function StateMachine:setState(state, params)
    debug_log("StateMachine:setState ", state, " current ", self.mCurrent.mId, " id ", self.mOject:getId());
    if self.mCurrent:canChange(state) then
        self.mCurrent = self:createState(self.mOject, state);
        self.mParams = params;
    end
end
