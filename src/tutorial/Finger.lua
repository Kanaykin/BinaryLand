require "src/base/Inheritance"
require "src/game_objects/MovableObject"
require "src/base/Log"

Finger =  inheritsFrom(BaseObject)

Finger.mVelocity = 60;
Finger.mIsMoving = false;
Finger.mAnimator = nil;
Finger.mDestPos = nil;

--------------------------------
function Finger:init(gameScene, field)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("Finger", reader, false);

	field:getFieldNode():addChild(node);
	--gameScene:addChild(node);
	Finger:superClass().init(self, field, node);

	local animator = reader:getActionManager();
	self.mAnimator = animator;

    self.mVelocity = self.mVelocity * field:getGame():getScale();
	---------
	function callbackHideFinish()
		info_log("Finger callbackHideFinish");
		self.mIsMoving = false;
	end

	local callFuncHide = CCCallFunc:create(callbackHideFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncHide, "0:HideFinish");
	---------

	---------
	function callbackShowFinish()
		info_log("Finger callbackShowFinish");
		self:moveTo(self.mDestPos);
	end

	local callFuncShow = CCCallFunc:create(callbackShowFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncShow, "0:ShowFinish");
	---------

	---------
	function callbackDoubleTapFinish()
		info_log("Finger callbackDoubleTapFinish");
		self.mIsMoving = false;
	end

	local callFuncDoubleTap = CCCallFunc:create(callbackDoubleTapFinish);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFuncDoubleTap, "0:DoubleTapfinish");
	---------
end

--------------------------------
function Finger:playDoubleTapAnimation()
	self.mAnimator:runAnimationsForSequenceNamed("doubleTap");
	self.mIsMoving = true;
end

--------------------------------
function Finger:stop()
	self:stopMoving();
	info_log("Finger:stop ", self.mAnimator:getRunningSequenceName());
	if self:IsMoving() and self.mAnimator:getRunningSequenceName() ~= "Hide" then
		self.mAnimator:runAnimationsForSequenceNamed("Hide");
	end
end

--------------------------------
function Finger:stopMoving()
	if self.mDelta then
		self.mDelta = nil;
		self:onMoveFinished();
	end
end

--------------------------------
function Finger:IsMoving()
	return self.mIsMoving;
end

--------------------------------
function Finger:moveTo(dest)
	local src = Vector.new(self.mNode:getPosition()); --self.mField:gridPosToReal(self.mGridPosition);
	info_log("[Finger:moveTo] src.x ", src.x, " src.y ", src.y);
	info_log("[Finger:moveTo] dest.x ", dest.x, " dest.y ", dest.y);
	local delta = dest - src;
	self.mMoveTime = delta:len() / self.mVelocity;
	self.mDelta = delta;
	info_log("[MovableObject:moveTo] delta.x ", delta.x, " delta.y ", delta.y);
	info_log("[MovableObject:moveTo] moveTime ", self.mMoveTime);
	local x, y = self.mNode:getPosition();
	self.mSrcPos = Vector.new(x, y);
	self.mDestGridPos = posDest;
end

--------------------------------
function Finger:move(from, to)
	self.mIsMoving = true;
	self.mDestPos = to;

	self:setPosition(from);

	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function Finger:onMoveFinished( )
	-- body
	self.mAnimator:runAnimationsForSequenceNamed("Hide");
end

--------------------------------
function Finger:setGrigPos(gridPos)
	local dest = self.mField:gridPosToReal(gridPos);
	dest.x= dest.x + self.mField.mCellSize / 2;
	dest.y= dest.y + self.mField.mCellSize / 2;

	self:setPosition(dest);
end

--------------------------------
function Finger:setPosition(position)
	self.mNode:setPosition(cc.p(position.x, position.y));
	self.mGridPosition = Vector.new(self.mField:getGridPosition(self.mNode));
end

--------------------------------
function Finger:tick(dt)
	Finger:superClass().tick(self, dt);

	if self.mDelta then
		local val = self.mDelta:normalized() * self.mVelocity * self.mMoveTime;
		local cur = self.mSrcPos + self.mDelta - val;
		self.mNode:setPosition(cc.p(cur.x, cur.y));
		self.mMoveTime = self.mMoveTime - dt;
		if self.mMoveTime <= 0 then
			self.mNode:setPosition(cc.p(self.mDestPos.x, self.mDestPos.y));

			self.mDelta = nil;
			self:onMoveFinished();
		end
	end
end

--------------------------------
function Finger:updateOrder()
end