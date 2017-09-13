require "src/game_objects/BaseObject"
require "src/base/Log"

MovableObject = inheritsFrom(BaseObject)
MovableObject.mVelocity = 15;
MovableObject.mMoveTime = nil;
MovableObject.mDelta = nil;
MovableObject.mDestMovePos = nil;
MovableObject.mSrcPos = nil;
MovableObject.mPrevOrderPos = nil;

MovableObject.mDebugBox = nil;
MovableObject.mNeedDebugBox = false;
MovableObject.mMoveFinishCallback = nil;

--------------------------------
function MovableObject:init(field, node)
	MovableObject:superClass().init(self, field, node);

	self:createDebugBox();

    self:updateOrder();
end

---------------------------------
function MovableObject:createDebugBox()
	if self.mNeedDebugBox then
        local nodeBox = cc.DrawNode:create();
        self.mNode:addChild(nodeBox);
        self.mDebugBox = nodeBox;
    end
end

--------------------------------
function MovableObject:updateDebugBox()
    if self.mDebugBox then
        local box = self:getBoundingBox();
        local size = self.mNode:getBoundingBox();
        local anchor = self.mNode:getAnchorPoint();
        box.x = 0;
        box.y = 0;
        self.mDebugBox:clear();
        --local center = cc.p(box.x + box.height / 2.0, box.y + box.width / 2.0);
        --self.mDebugBox:drawCircle(center, box.width / 2.0 * 0.7,
        --    360, 360, false, {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x + box.width, box.y), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x, box.y + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x + box.width, box.y), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y + box.height), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});
	end
end


---------------------------------
function MovableObject:store(data)
    MovableObject:superClass().store(self, data);
    data.nodePosition = Vector.new(self.mNode:getPosition());
    return true
end

---------------------------------
function MovableObject:restore(data)
    MovableObject:superClass().restore(self, data);
    self.mNode:setPosition(cc.p(data.nodePosition.x, data.nodePosition.y));
	self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
    self:updateOrder();
end

--------------------------------
function MovableObject:resetMovingParams()
    self.mDelta = nil;
    self.mMoveTime = 0;
end

--------------------------------
function MovableObject:stopMoving()
	if self.mDelta then
        self:resetMovingParams();
		self:onMoveFinished();
	end
end

--------------------------------
function MovableObject:moveToFieldPos(dest, moveFinishCallback)
	self.mMoveFinishCallback = moveFinishCallback;

	local src = Vector.new(self.mNode:getPosition()); --self.mField:gridPosToReal(self.mGridPosition);
	--info_log("[MovableObject:moveTo] src.x ", src.x, " src.y ", src.y);
	--info_log("[MovableObject:moveTo] dest.x ", dest.x, " dest.y ", dest.y);
	local delta = dest - src;
	self.mMoveTime = delta:len() / self.mVelocity;
	self.mDelta = delta;
	--info_log("[MovableObject:moveTo] delta.x ", delta.x, " delta.y ", delta.y);
	--info_log("[MovableObject:moveTo] moveTime ", self.mMoveTime);
	local x, y = self.mNode:getPosition();
	self.mSrcPos = Vector.new(x, y);

	self.mDestMovePos = dest;
end

--------------------------------
function MovableObject:moveTo(posDest, moveFinishCallback)
	-- compute real position
	--info_log("[MovableObject:moveTo] posDest.x ", posDest.x, "posDest.y ", posDest.y);
	
	local dest = self.mField:gridPosToReal(posDest);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	self:moveToFieldPos(dest, moveFinishCallback);
end

--------------------------------
function MovableObject:getPrevOrderPos()
    return self.mPrevOrderPos;
end

--------------------------------
function MovableObject:updateOrder()
	local newOrderPos = -self.mGridPosition.y * 2;
	if self.mPrevOrderPos ~= newOrderPos then
		self.mPrevOrderPos = newOrderPos;
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, false);
		parent:addChild(self.mNode, self.mPrevOrderPos);
	end
end

--------------------------------
function MovableObject:onMoveFinished( )
	-- body
	if self.mMoveFinishCallback then
		self.mMoveFinishCallback()
	end
end

--------------------------------
function MovableObject:IsMoving()
	return self.mDelta ~= nil;
end

--------------------------------
function MovableObject:setVelocity(velocity)
	--debug_log("MovableObject:setVelocity ", velocity)
	self.mVelocity = velocity * self.mField.mGame:getScale();
end

--------------------------------
function MovableObject:tick(dt)
	MovableObject:superClass().tick(self, dt);
	if self.mDelta then
		local val = self.mDelta:normalized() * self.mVelocity * self.mMoveTime;
		--debug_log("[MovableObject:moveTo] tick val ", val, "id ", self:getId());
		local cur = self.mSrcPos + self.mDelta - val;
		--debug_log("[MovableObject:moveTo] tick cur.x ", cur.x, " y ", cur.y, "id ", self:getId());
		self.mNode:setPosition(cc.p(cur.x, cur.y));
		self.mMoveTime = self.mMoveTime - dt;
		--debug_log("[MovableObject:moveTo] tick mMoveTime ", self.mMoveTime, "id ", self:getId());
		--debug_log("[MovableObject:moveTo] tick mDestMovePos ", self.mDestMovePos);

		self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
		self:updateOrder();
		if self.mMoveTime <= 0 then
			self.mNode:setPosition(cc.p(self.mDestMovePos.x, self.mDestMovePos.y));

			self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
			--debug_log("[MovableObject:moveTo] grid pos ", self.mGridPosition.x, " y ", self.mGridPosition.y);
			self.mDelta = nil;
			self:onMoveFinished();
			--self.mDestMovePos = nil;
			--self:updateOrder();
		end
	end

	self:updateDebugBox();
end
