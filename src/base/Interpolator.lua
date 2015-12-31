require "src/base/Inheritance"

LinearInterpolator = inheritsFrom(nil)
LinearInterpolator.mFrom = nil
LinearInterpolator.mTo = nil
LinearInterpolator.mMaxTime = nil
LinearInterpolator.mCurrent = nil
LinearInterpolator.mCurTime = nil

-------------------------------------
function LinearInterpolator:init(from, to, time)
	self.mFrom = from
	self.mTo = to
	self.mMaxTime = time
	self.mCurrent = from
	self.mCurTime = 0
end

-------------------------------------
function LinearInterpolator:getCurrent()
	return self.mCurrent
end

-------------------------------------
function LinearInterpolator:tick(dt)
	self.mCurTime = (self.mCurTime + dt);
	local t = math.min(self.mCurTime / self.mMaxTime, 1);
	self.mCurrent = (1.0 - t) * self.mFrom + t * self.mTo;
end
