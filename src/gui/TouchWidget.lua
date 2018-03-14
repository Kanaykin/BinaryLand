require "src/base/Inheritance"
require "src/math/Vector"
require "src/base/Log"

TouchWidget = inheritsFrom(nil)
TouchWidget.mTouchId = nil;
TouchWidget.mBBox = nil;
TouchWidget.mDeltaTime = nil;

TouchWidget.DOUBLE_TOUCH_DELTA = 0.3;

----------------------------------------
function TouchWidget:convertToPoints(var)
	local array_points = {};
	if type(var) ~= "table" then
		return array_points;
	end
	
	for i = 1, #var, 3 do
		--info_log("onTouchHandler [", var[i + 2], "]=", var[i], ", ", var[i + 1]);
		array_points[var[i + 2]] = Vector.new(var[i], var[i + 1]);
	end

	return array_points;
end

----------------------------------------
function TouchWidget:onTouchBegan(point)
	info_log("TouchWidget:onTouchBegan ");
end

----------------------------------------
function TouchWidget:onDoubleTouch(point)
	info_log("TouchWidget:onDoubleTouch ");
end

----------------------------------------
function TouchWidget:onTouchMoved(point)
	info_log("TouchWidget:onTouchMoved ");
end

----------------------------------------
function TouchWidget:onTouchEnded(point)
	info_log("TouchWidget:onTouchEnded ");
end

--------------------------------
function findContainPoint(box, arrayPoints)
	for i, point in pairs(arrayPoints) do
		if Rect.new(box):containsPoint(cc.p(point.x, point.y)) then
			return i;
		end
	end
	return nil;
end

----------------------------------------
function TouchWidget:release()
	self.mTouchId = nil;
	self:onTouchEnded({0,0});
end

----------------------------------------
function TouchWidget:onTouchHandler(action, var)
    info_log("TouchWidget:onTouchHandler ", action, " var ", var, " self ", self);

	local arrayPoints = self:convertToPoints(var);

	info_log("TouchWidget.mTouchId 1 ", self.mTouchId, " var ", var);

	if self.mTouchId ~= nil and not arrayPoints[self.mTouchId] then
		return;
	end

	local oldTouchId = self.mTouchId;

	if action == "began" then
		if self.mTouchId == nil then
			local indx = findContainPoint(self.mBBox, arrayPoints);
			self.mTouchId = indx;
		end
	elseif action == "moved" then
		-- oldTouchId = nil;
		if self.mTouchId == nil then
			local indx = findContainPoint(self.mBBox, arrayPoints);
			self.mTouchId = indx;
		else
			if not Rect.new(self.mBBox):containsPoint(cc.p(arrayPoints[self.mTouchId].x, arrayPoints[self.mTouchId].y)) then
				self.mTouchId = nil;
			end
		end
	else
		self.mTouchId = nil;
	end

	info_log("TouchWidget.mTouchId 2 ", self.mTouchId, " var ", var);

	if not oldTouchId and self.mTouchId then 
		self:onTouchBegan(arrayPoints[self.mTouchId]);
	elseif oldTouchId and self.mTouchId then
		self:onTouchMoved(arrayPoints[self.mTouchId]);
	elseif oldTouchId and not self.mTouchId then
		info_log("TouchWidget.mTouchId double touch ", self.mDeltaTime);
		self:onTouchEnded(arrayPoints[self.mTouchId]);
		if self.mDeltaTime > 0 and self.mDeltaTime < TouchWidget.DOUBLE_TOUCH_DELTA then
			self:onDoubleTouch();
		end
		self.mDeltaTime = 0;
	end

end

---------------------------------
function TouchWidget:tick(dt)
	self.mDeltaTime = self.mDeltaTime + dt;
	--info_log("TouchWidget:tick ", self.mDeltaTime);
end

--------------------------------
function TouchWidget:init(bbox)
	self.mBBox = bbox;
	self.mDeltaTime = 99999;
end