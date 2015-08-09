require "lunit"
require "BaseTests"
require "src/game_objects/DogObject"
require "src/algorithms/WavePathFinder"
require "src/game_objects/Field"

local size = Vector.new(6, 21);
local array = {1, 1,1,1,1,1,1,
1, 0, 0, 1, 0, 0, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 1, 0, 1, 0, 1, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 0, 1, 1, 1, 0, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 1, 0, 1, 0, 1, 1, 
1, 0, 0, 0, 0, 0, 1, 
1, 1, 1, 0, 1, 1, 1, 
1, 0, 0, 0, 0, 0, 1, 
1, 1, 0, 1, 0, 0, 1, 
1, 1, 0, 1, 0, 0, 1, 
1, 1, 0, 1, 1, 0, 1, 
1, 0, 0, 1, 0, 0, 1, 
1, 0, 0, 1, 0, 1, 1, 
1, 0, 0, 0, 0, 0, 1, 
1, 1, 1, 1, 1, 1, 1, 
1, 0, 0, 0, 0, 0, 1, 
1, 1, 1, 1, 1, 1, 1 
};

print("!!!! ", array[COORD(1, 20, size.x)]);

PRINT_FIELD(array, size)

--local path = WavePathFinder.buildPath(Vector.new(3, 10), Vector.new(1, 20), array, size);

--local path1 = WavePathFinder.buildPath(Vector.new(1, 6), Vector.new(2, 20), array, size);

local field = Field:create();
field.mSize = size;
field.mFreePoints = {}
field.mArray = array;
field.mPlayerObjects = {{mGridPosition = Vector.new(1, 5)}}
field:fillFreePoint();

local invalid_point = Vector.new(2, 20);
local valid_point = Vector.new(1, 18);

local found_invalid_pointer = false;
local found_valid_pointer = false;
for i, point in ipairs(field.mFreePoints) do
	if point.x == invalid_point.x and point.y == invalid_point.y then
		found_invalid_pointer = true;
	end
	if point.x == valid_point.x and point.y == valid_point.y then
		found_valid_pointer = true;
	end
end

module( "Free points ", lunit.testcase )

function test_success()
	assert_true( not found_invalid_pointer, "Invalid free points ")
	assert_true( found_valid_pointer, "Valid free points ")
end

--[[
local mob = DogObject:create();
local node = NodeMock:create();
node.mParent = NodeMock:create();
node.mTexture = TextureMock:create();

local field = FieldMock:create();
local game = GameMock:create();

field.mGame = game;

mob:init(field, node);

module( "my_testcase", lunit.testcase )

function test_success()
  assert_false( false, "This test never fails.")
end

function test_failure()
  fail( "This test always fails!" )
end]]