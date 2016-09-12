require "src/math/Vector"
require "src/base/Log"

WavePathFinder = {

	DIRECTIONS = {
		Vector.new(0, 1),
		Vector.new(1, 0),
		Vector.new(0, -1),
		Vector.new(-1, 0)
	},

	FIRST_INDEX = 2,

	-----------------------------------
	isValidPoint = function ( point,  sizeArray)
		if point.x < 1 or point.y < 1 or point.x > sizeArray.x or point.y > sizeArray.y then
			return false;
		end
		return true;
	end,

	-----------------------------------
	isFree = function ( point,  array, sizeArray)
		if not WavePathFinder.isValidPoint(point, sizeArray) then
			return false;
		end
		return array[COORD(point.x, point.y, sizeArray.x)] == 0;
	end,

	-----------------------------------
	fillArray = function(srcPoints, pointTo, array, sizeArray, index)
		if #srcPoints == 0 then
			return;
		end

		local srcNewPoints = {};
		for i, point in ipairs(srcPoints) do
			-- find nearest
			for iDir, dir in ipairs(WavePathFinder.DIRECTIONS) do
				local near = point + dir;
				if WavePathFinder.isFree(near, array, sizeArray) then
					--info_log("near x ", near.x, " y ", near.y);
					table.insert(srcNewPoints, near);
					array[COORD(near.x, near.y, sizeArray.x)] = index;
					if near.x == pointTo.x and near.y == pointTo.y then
						return;
					end
				end
			end
		end
		WavePathFinder.fillArray(srcNewPoints, pointTo, array, sizeArray, index + 1);
	end,

	-----------------------------------
	findPathExt = function(path, array, sizeArray, finishPoint)
		--WavePathFinder.printPath(path);
		local point = path[#path];
		if point == finishPoint then
			return;
		end
		info_log("point.x ", point.x, "point.y ", point.y);
		local index = array[COORD(point.x, point.y, sizeArray.x)];
		info_log("index ", index);
		if index == WavePathFinder.FIRST_INDEX then
			return;
		end

		--local inserted = false;
		local found_index = index;
		local found_point = nil;
		--and array[COORD(near.x, near.y, sizeArray.x)] > index

		for iDir, dir in ipairs(WavePathFinder.DIRECTIONS) do
			local near = point + dir;
			if WavePathFinder.isValidPoint(near, sizeArray) and array[COORD(near.x, near.y, sizeArray.x)] ~= 1
				and array[COORD(near.x, near.y, sizeArray.x)] ~= 0  then
				--table.insert(path, near);
				--inserted = true;
				if found_index < array[COORD(near.x, near.y, sizeArray.x)] then
					found_index = array[COORD(near.x, near.y, sizeArray.x)];
					found_point = near;
				end
				--break;
			end
		end
		if found_point then
			table.insert(path, found_point);
			WavePathFinder.findPathExt(path, array, sizeArray, finishPoint);
            --PRINT_FIELD(array, sizeArray);
		end
	end,

	-----------------------------------
	normalizePath = function(path)
		debug_log("normalizePath ", #path);
		if #path < 2 then
			return path
		end
		local result = {};
		local lastDir = Vector.new(0, 0);
		for i = 2, #path do
			debug_log("normalizePath i ", i);
			local first = path[i - 1];
			local second = path[i];
			local dir = (second - first):normalized();
			for iDir, dirConst in ipairs(WavePathFinder.DIRECTIONS) do
				if dir == dirConst then
					if lastDir ~= dir then
						lastDir = dir;
						table.insert(result, first);
					end
					break;
				end
			end
		end
		table.insert(result, path[#path]);
		return result;
	end,

	-----------------------------------
	findPath = function(path, array, sizeArray)
		--WavePathFinder.printPath(path);
		local point = path[#path];
		--info_log("point.x ", point.x, "point.y ", point.y);
		local index = array[COORD(point.x, point.y, sizeArray.x)];
		--info_log("index ", index);
		if index == WavePathFinder.FIRST_INDEX then
			return;
		end

		local inserted = false;
		for iDir, dir in ipairs(WavePathFinder.DIRECTIONS) do
			local near = point + dir;
			if WavePathFinder.isValidPoint(near, sizeArray) and array[COORD(near.x, near.y, sizeArray.x)] ~= 1
				and array[COORD(near.x, near.y, sizeArray.x)] ~= 0 
				and array[COORD(near.x, near.y, sizeArray.x)] < index then
				table.insert(path, near);
				inserted = true;
				break;
			end
		end
		if inserted then
			WavePathFinder.findPath(path, array, sizeArray);
            --PRINT_FIELD(array, sizeArray);
		end
	end,

	-----------------------------------
	printPath = function(path)
        info_log("printPath ");
		for i, val in ipairs(path) do
			info_log(" i = ", i, "val.x ", val.x , "val.y ", val.y);
		end
	end,

	-----------------------------------
	reversePath = function(path)
		local pathReversed = {};
		local size = #path;
		for i, val in ipairs(path) do
			pathReversed[size - i + 1] = val;
		end
		return pathReversed;
	end,

	-----------------------------------
	buildPath = function (pointFrom, pointTo, array, sizeArray)
		info_log("buildPath ( pF.x ", pointFrom.x, " pF.y ", pointFrom.y, "pF.x ", pointTo.x, " pF.y ", pointTo.y);
		local srcPoints = {pointFrom};
		array[COORD(pointFrom.x, pointFrom.y, sizeArray.x)] = WavePathFinder.FIRST_INDEX;
		WavePathFinder.fillArray(srcPoints, pointTo, array, sizeArray, WavePathFinder.FIRST_INDEX + 1);
		PRINT_FIELD(array, sizeArray);
        info_log("!!!111 ", array[COORD(pointTo.x, pointTo.y, sizeArray.x)]);
		local path = {pointTo};
		WavePathFinder.findPath(path, array, sizeArray);

		local pathReversed = WavePathFinder.reversePath(path);
        info_log("buildPath final path 1 ", path[1].x, " y ", path[1].y);
        info_log("buildPath final path 2 ", path[#path].x, " y ", path[#path].y);
        info_log("buildPath final dist ", #path);
        if(path[#path].x ~= pointFrom.x or path[#path].y ~= pointFrom.y ) then
        	info_log("not found path !!! ");
        	return {}
        end
		WavePathFinder.printPath(pathReversed);
		return pathReversed;
	end

}