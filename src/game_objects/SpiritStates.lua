require "src/base/Inheritance"

SpiritStates = {
    MS_FIRST_APPEAR = 1,
    MS_FOLLOW_PLAYER = 2,
    MS_DISAPPEAR = 3
}

--[[///////////////////////////]]
local BaseSpiritState = inheritsFrom(BaseState)

------------------------------------
function BaseSpiritState:onPlayerLeaveWeb(player)
	self.mStateMachine:setState(SpiritStates.MS_DISAPPEAR);
end

--[[///////////////////////////]]
local FirstAppear = inheritsFrom(BaseSpiritState)
FirstAppear.mAnimation = nil

------------------------------------
function FirstAppear:init(object, stateMachine)
    info_log("FirstAppear:init ");
    FirstAppear:superClass().init(self, object, stateMachine);
end

------------------------------------
function FirstAppear:enter(params)
	info_log("FirstAppear:enter ");
	self.mObject:playAnimation(SpiritObject.ANIMATION_STATE.AS_FIRST_APPEAR);

	self.mAnimation = self.mObject:getAnimation(SpiritObject.ANIMATION_STATE.AS_FIRST_APPEAR);
	self.mObject:setPlayerPosition();
	--self.mObject:setPlayerFlip();
end

------------------------------------
function FirstAppear:tick(dt)
	--self.mObject:setPlayerPosition();
	if self.mAnimation:isDone() then
		debug_log("FirstAppear:tick isDone ");
		self.mStateMachine:setState(SpiritStates.MS_FOLLOW_PLAYER);
	end
end

--[[///////////////////////////]]
local FollowPlayer = inheritsFrom(BaseSpiritState)

------------------------------------
function FollowPlayer:init(object, stateMachine)
    info_log("FollowPlayer:init ");
    FollowPlayer:superClass().init(self, object, stateMachine);
end

------------------------------------
function FollowPlayer:enter(params)
	info_log("FollowPlayer:enter ");
	self.mObject:playAnimation(SpiritObject.ANIMATION_STATE.AS_FOLLOW_PLAYER);
	self.mObject:setSourcePosition();
end

------------------------------------
function FollowPlayer:tick(dt)
self.mObject:setSourcePosition();
end

--[[///////////////////////////]]
local Disappear = inheritsFrom(BaseState)
Disappear.mAnimation = nil

------------------------------------
function Disappear:init(object, stateMachine)
    info_log("Disappear:init ");
    Disappear:superClass().init(self, object, stateMachine);
end

------------------------------------
function Disappear:enter(params)
	info_log("Disappear:enter ");
	self.mObject:playAnimation(SpiritObject.ANIMATION_STATE.AS_DISAPPEAR);

	self.mAnimation = self.mObject:getAnimation(SpiritObject.ANIMATION_STATE.AS_DISAPPEAR);
end

------------------------------------
function Disappear:tick(dt)
	if self.mAnimation:isDone() then
		self.mObject:disappear();
	end
end

--[[///////////////////////////]]
SpiritStateMachine = inheritsFrom(StateMachine)

------------------------------------
function SpiritStateMachine:init(object)
    SpiritStateMachine:superClass().init(self, object);
    self.mFactoryStates = {
        [SpiritStates.MS_FIRST_APPEAR] = FirstAppear,
        [SpiritStates.MS_FOLLOW_PLAYER] = FollowPlayer,
        [SpiritStates.MS_DISAPPEAR] = Disappear
    }

    if not self.mCurrent then
        self.mCurrent = self:createState(object, SpiritStates.MS_FIRST_APPEAR);
        self.mActive = self.mCurrent;
        self.mActive:enter({});
    end
end

------------------------------------
function SpiritStateMachine:onPlayerLeaveWeb(player)
	self.mActive:onPlayerLeaveWeb(player);
end

