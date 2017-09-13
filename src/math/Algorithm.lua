Algorithm = {}
Algorithm.epsilon = 2.22044604925031308e-16

----------------------------------------
Algorithm.equal = function(Input1, Input2)
	return math.abs(Input1 - Input2) < Algorithm.epsilon;
end

