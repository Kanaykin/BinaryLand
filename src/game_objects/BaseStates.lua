require "src/base/Inheritance"

--[[///////////////////////////]]
BaseState = inheritsFrom(nil)
BaseState.mObject = nil
BaseState.mStateMachine = nil

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
function BaseState:leave(state)
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
StateMachine = inheritsFrom(nil)
StateMachine.mCurrent = nil
StateMachine.mActive = nil
StateMachine.mFactoryStates = nil
StateMachine.mOject = nil
StateMachine.mParams = nil

------------------------------------
function StateMachine:init(object)
    self.mOject = object;
end

------------------------------------
function StateMachine:tick(dt)
    if self.mCurrent ~= self.mActive then
        if self.mActive:leave(self.mCurrent.mId) then
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
function StateMachine:setState(state, params)
    debug_log("StateMachine:setState ", state, " current ", self.mCurrent.mId, " id ", self.mOject:getId());
    if self.mCurrent:canChange(state) then
        self.mCurrent = self:createState(self.mOject, state);
        self.mParams = params;
    end
end

