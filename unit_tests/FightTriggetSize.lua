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

	local posGridCont = Vector.new(posGrid.x + field.mCellSize * 0.7, posGrid.y + field.mCellSize * 0.7);
	print("posGridCont.x ", posGridCont.x, " posGridCont.y ", posGridCont.y);

	local diametr = Vector.distance(posGrid, posGridCont);
	print("diametr ", diametr);

	local contained = trigger:contained(posGridCont);
	print("contained ", contained);


module( "FightTrigger size", lunit.testcase )

function test_success()
	assert_true( contained, "This test never fails.")
end