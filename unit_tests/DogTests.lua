require "lunit"
require "BaseTests"
require "src/game_objects/DogObject"

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
end