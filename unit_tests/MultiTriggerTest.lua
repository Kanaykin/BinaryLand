require "lunit"
require "BaseTests"
require "src/game_objects/MultiTrigger"
require "src/math/Vector"
require "src/game_objects/Field"

local node = NodeMock:create();
local field = Field:create();
field.mLeftBottom = Vector.new(0, 0);
field.mCellSize = 32

local dog = ObjectMock:create();
dog.mNode = NodeMock:create();
print("dog.mNode x ", dog.mNode:getPosition())

field.mEnemyObjects = {dog}
field.mFieldNode = NodeMock:create();

local CallbackListener = inheritsFrom(nil);
CallbackListener.mEnter = nil;
CallbackListener.mLeave = nil;
function CallbackListener:onEnter()
	print("CallbackListener:onEnter ");
	self.mEnter = true;
end
function CallbackListener:onLeave()
	print("CallbackListener:onLeave ");
	self.mLeave = true;
end

local listener = CallbackListener:create();

local trigger = FightTrigger:create();
trigger:init(field);
trigger:setActivated(true);
trigger.mEnterCallback = Callback.new(listener, CallbackListener.onEnter);
trigger.mLeaveCallback = Callback.new(listener, CallbackListener.onLeave);
--trigger:init(field, node, Callback.new(listener, CallbackListener.onEnter), Callback.new(listener, CallbackListener.onLeave));
print("trigger bbox x ",  trigger.mNode:getBoundingBox().x, " y ", trigger.mNode:getBoundingBox().y, " width ", trigger.mNode:getBoundingBox().width);

--dog.mNode:setPosition(Vector.new(-10, -10));
trigger:tick(0.1);
local enterDog = listener.mEnter;
print(" enterDog ", enterDog);
dog.mNode:setPosition(Vector.new(100, 100));
trigger:tick(0.1);
local leaveDog = listener.mLeave;
print(" leaveDog ", leaveDog);

listener.mEnter = false;
listener.mLeave = false;
dog.mNode:setPosition(Vector.new(0, 0));
trigger:tick(0.1);
local enterDog2 = listener.mEnter;
print(" enterDog2 ", enterDog2);
trigger:setActivated(false);
dog.mNode:setPosition(Vector.new(100, 100));
trigger:tick(0.1);
local leaveDog2 = listener.mLeave;
print(" leaveDog2 ", leaveDog2);

listener.mEnter = false;
listener.mLeave = false;
trigger:setActivated(true);
dog.mNode:setPosition(Vector.new(0, 0));
trigger:tick(0.1);
local enterDog3 = listener.mEnter;
print(" enterDog3 ", enterDog3);



module( "MultiTrigger enter callback ", lunit.testcase )
function test_success()
	assert_true( enterDog == true, "enemy enters")
	assert_true( leaveDog == true, "enemy leaves")
	assert_true( enterDog3 == true, "enemy enters")
end