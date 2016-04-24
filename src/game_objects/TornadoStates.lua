require "src/game_objects/MobStates.lua"

TornadoStates = {
    TS_CATCH_PLAYER = MobStates.MS_LAST + 1 --5
}

--[[///////////////////////////]]
TornadoCatchState = inheritsFrom(BaseMobState)

------------------------------------
function TornadoCatchState:tick(dt)
    info_log("TornadoCatchState:tick ");
    TornadoCatchState:superClass().tick(self, dt);
    -- if self.mTimeWait == nil then
    --     self.mTimeWait = 0.5;
    -- end
    -- self.mTimeWait = self.mTimeWait - dt;
    -- if self.mTimeWait < 0 then
    --     self.mStateMachine:setState(MobStates.MS_IDLE);
    -- end
end

------------------------------------
function TornadoCatchState:enter(params)
    debug_log("TornadoCatchState:enter");

    if not params.player:isInTrap() then
        params.field:createSnareTrigger(Vector.new(params.player.mNode:getPosition()));
    end

    self.mObject:resetMovingParams();
end

------------------------------------
function TornadoCatchState:onEnterFightTrigger()
    self.mStateMachine:setState(MobStates.HS_DEAD);
end

--[[///////////////////////////]]
TornadoIdleState = inheritsFrom(IdleState)

------------------------------------
function TornadoIdleState:onEnterFightTrigger()
    --self.mStateMachine:setState(MobStates.HS_DEAD);
end


--[[///////////////////////////]]
TornadoMoveState = inheritsFrom(MoveState)

------------------------------------
function TornadoMoveState:onPlayerEnter(player, field)
    debug_log("TornadoMoveState:onPlayerEnter ");
    self.mStateMachine:setState(TornadoStates.TS_CATCH_PLAYER, {player = player, field = field});
end

------------------------------------
function TornadoMoveState:onEnterFightTrigger()
    --self.mStateMachine:setState(MobStates.HS_DEAD);
end

--[[///////////////////////////]]
TornadoStateMachine = inheritsFrom(MobStateMachine)

------------------------------------
function TornadoStateMachine:init(object)
    TornadoStateMachine:superClass().init(self, object);

	self.mFactoryStates[MobStates.MS_MOVE] = TornadoMoveState;
	self.mFactoryStates[MobStates.MS_IDLE] = TornadoIdleState;

    self.mFactoryStates[TornadoStates.TS_CATCH_PLAYER] = TornadoCatchState;
    --self.mFactoryStates[MobStates.HS_DEAD] = IdleState;
end