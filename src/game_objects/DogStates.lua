require "src/game_objects/MobStates.lua"

DogStates = {
    DS_RUN_AWAY = MobStates.MS_LAST,
    DS_HUNTER_DEAD = MobStates.MS_LAST + 1,
    DS_PLAYER_FOUND = MobStates.MS_LAST + 2,
    DS_TOOK_TRACE = MobStates.MS_LAST + 3
}


--[[///////////////////////////]]
DogIdleState = inheritsFrom(IdleState)

------------------------------------
function DogIdleState:onPlayerTraceFound(path)
	debug_log("DogIdleState:onPlayerTraceFound path ", path)
	self.mStateMachine:setState(DogStates.DS_TOOK_TRACE, {path = path});
end

--[[///////////////////////////]]
RunAwayState = inheritsFrom(MoveState)

------------------------------------
function RunAwayState:enter(params)
    debug_log("RunAwayState:enter");
    local point = self.mObject:getSafePlayerPoints();
    info_log ("RunAwayState:enter point.x ", point.x, " point.y ", point.y);
    self.mObject:runAway(point);
    self.mObject:swapAnimations();
end

------------------------------------
function RunAwayState:leave()
    debug_log("RunAwayState:leave");
    self.mObject:swapAnimations();
    return true;
end

------------------------------------
function RunAwayState:onMoveFinished()
    if not self.mObject:moveToNextPoint() then
    	self.mObject.mVelocity = self.mObject.oldVelocity;
        debug_log("RunAwayState:onMoveFinished self.mVelocity " );
        self.mObject.oldVelocity = nil;

        self.mStateMachine:setState(MobStates.MS_IDLE);
    end
end

------------------------------------
function RunAwayState:onHunterDead()
	self.mStateMachine:setState(DogStates.DS_HUNTER_DEAD);
end

--[[///////////////////////////]]
HunterDeadState = inheritsFrom(RunAwayState)

------------------------------------
function HunterDeadState:enter(params)
    debug_log("HunterDeadState:enter");
    local awayPoint = self.mObject:getAwayPoint();
    self.mObject:runAway(awayPoint);
    self.mObject:swapAnimations();
    self.mObject:updateRunAwayPath();
end

------------------------------------
function HunterDeadState:onMoveFinished()
    if not self.mObject:moveToNextPoint() then
        self.mStateMachine:setState(MobStates.HS_DEAD);
    end
end

--[[///////////////////////////]]
DogMoveState = inheritsFrom(MoveState)

function DogMoveState:onPlayerEnter(player, pos)
	if not player:isInTrap() then
		self.mStateMachine:setState(DogStates.DS_PLAYER_FOUND, {player = player});
	end
end

------------------------------------
function DogMoveState:onEnterFightTrigger()
    self.mStateMachine:setState(DogStates.DS_RUN_AWAY);
end

------------------------------------
function DogMoveState:onHunterDead()
	self.mStateMachine:setState(DogStates.DS_HUNTER_DEAD);
end

------------------------------------
function DogMoveState:onPlayerTraceFound(path)
	debug_log("DogMoveState:onPlayerTraceFound path ", path)
	self.mStateMachine:setState(DogStates.DS_TOOK_TRACE, {path = path});
end

--[[///////////////////////////]]
TookTrace = inheritsFrom(DogMoveState)

------------------------------------
function TookTrace:enter(params)
	debug_log("TookTrace:enter params.path ", params.path)
	WavePathFinder.printPath(params.path);
	self.mObject:resetMovingParams();
	self.mObject:swapFollowAnimations();
	self.mObject:moveByPath(params.path);
end

------------------------------------
function TookTrace:leave()
    local res = TookTrace:superClass().leave(self);
    self.mObject:resetPlayerTrace();
    self.mObject:swapFollowAnimations();
    return res;
end

------------------------------------
function TookTrace:tick(dt)
	TookTrace:superClass().tick(self, dt);
	--debug_log("TookTrace:tick gridPosition.x ", self.mObject.mGridPosition.x, " gridPosition.y ", self.mObject.mGridPosition.y);
end

--[[///////////////////////////]]
DogPlayerFoundState = inheritsFrom(BaseState)
DogPlayerFoundState.mFoundPlayer = nil

------------------------------------
function DogPlayerFoundState:enter(params)
    debug_log("DogPlayerFoundState:enter");
    self.mFoundPlayer = params.player;
    self.mObject:resetMovingParams();
    self.mObject:setFoundPlayerPos(self.mObject.mGridPosition);
end

------------------------------------
function DogPlayerFoundState:leave()
    debug_log("DogPlayerFoundState:leave");
    self.mObject:setFoundPlayerPos(nil);
    return true;
end

------------------------------------
function DogPlayerFoundState:tick(dt)
	if self.mFoundPlayer:isInTrap() then
		self.mStateMachine:setState(MobStates.MS_IDLE);
	end
end

------------------------------------
function DogPlayerFoundState:onPlayerLeave(player)
	debug_log("DogPlayerFoundState:onPlayerLeave");
	self.mStateMachine:setState(MobStates.MS_IDLE);
end

------------------------------------
function DogPlayerFoundState:onHunterDead()
	self.mStateMachine:setState(DogStates.DS_HUNTER_DEAD);
end

------------------------------------
function DogPlayerFoundState:getAnimationByDirection()
	return DogObject.BARK_ANIMATION;
end

------------------------------------
function DogPlayerFoundState:onEnterFightTrigger()
    self.mStateMachine:setState(DogStates.DS_RUN_AWAY);
end

--[[///////////////////////////]]
DogStateMachine = inheritsFrom(StateMachine)

------------------------------------
function DogStateMachine:init(object)
    info_log("DogStateMachine:init ");
    DogStateMachine:superClass().init(self, object);

    self.mFactoryStates[DogStates.DS_PLAYER_FOUND] = DogPlayerFoundState;
    self.mFactoryStates[MobStates.MS_MOVE] = DogMoveState;
    self.mFactoryStates[DogStates.DS_RUN_AWAY] = RunAwayState;
    self.mFactoryStates[DogStates.DS_HUNTER_DEAD] = HunterDeadState;
    self.mFactoryStates[DogStates.DS_TOOK_TRACE] = TookTrace;
    self.mFactoryStates[MobStates.MS_IDLE] = DogIdleState;
end

------------------------------------
function DogStateMachine:onPlayerEnter(player, pos)
	if self.mActive.onPlayerEnter then
        self.mActive:onPlayerEnter(player, pos);
    end
end

------------------------------------
function DogStateMachine:getAnimationByDirection()
	if self.mActive.getAnimationByDirection then
        return self.mActive:getAnimationByDirection();
    else
    	return nil;
    end
end

------------------------------------
function DogStateMachine:onPlayerTraceFound(path)
	debug_log("DogStateMachine:onPlayerTraceFound ")
	if self.mActive.onPlayerTraceFound then
        self.mActive:onPlayerTraceFound(path);
    end
end

------------------------------------
function DogStateMachine:onHunterDead()
	if self.mActive.onHunterDead then
        self.mActive:onHunterDead(player);
    end
end

------------------------------------
function DogStateMachine:onPlayerLeave(player)
	if self.mActive.onPlayerLeave then
        self.mActive:onPlayerLeave(player);
    end
end