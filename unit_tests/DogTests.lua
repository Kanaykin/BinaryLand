package.path = package.path .. os.getenv("BINARY_LAND_PATH")
cc = {
	p = function (x_in, y_in)
		return {x = x_in, y = y_in}
	end
}
require "lunit"
require "src/game_objects/DogObject"

module( "my_testcase", lunit.testcase )

function test_success()
  assert_false( false, "This test never fails.")
end

function test_failure()
  fail( "This test always fails!" )
end