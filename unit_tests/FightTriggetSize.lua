require "lunit"
require "BaseTests"
require "src/game_objects/FightTrigger"
require "src/game_objects/Field"

	local trigger = FightTrigger:create();

	local field = Field:create();
	local game = GameMock:create();
	field.mFieldNode = NodeMock:create();
	field.mCellSize = 32;
	field.mLeftBottom = Vector.new(0, 0);

	field.mGame = game;

	trigger:init(field);
	local posGrid = field:gridPosToReal(Vector.new(2, 2));
	print("posGrid.x ", posGrid.x, " posGrid.y ", posGrid.y);
	trigger:setDateTransform(posGrid, Vector.new(0, 0));

	local posGridCont = field:gridPosToReal(Vector.new(3, 3));
	print("posGridCont.x ", posGridCont.x, " posGridCont.y ", posGridCont.y);
	trigger:contained(posGridCont);


module( "my_testcase", lunit.testcase )

function test_success()
	assert_true( true, "This test never fails.")
end