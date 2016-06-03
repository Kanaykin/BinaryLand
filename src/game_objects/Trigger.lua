require "src/game_objects/BaseObject"
require "src/base/Callback"
require "src/base/Log"

Trigger = inheritsFrom(BaseObject)
Trigger.mEnterCallback = nil;
Trigger.mLeaveCallback = nil;
Trigger.mContainedObj = nil;
Trigger.mSize = nil;
Trigger.mDebugBox = nil;
Trigger.mNeedDebugBox = false;

--------------------------------
function Trigger:getContainedObj()
	return self.mContainedObj;
end

--------------------------------
function Trigger:setEnterCallback(callback)
	self.mEnterCallback = callback;
end

--------------------------------
function Trigger:init(field, node, enterCallback, leaveCallback)
	Trigger:superClass().init(self, field, node);

	self.mEnterCallback = enterCallback;
	self.mLeaveCallback = leaveCallback;

	self.mSize = node:getBoundingBox();

	if self.mNeedDebugBox then
        local nodeBox = cc.DrawNode:create();
        self.mNode:addChild(nodeBox);
        self.mDebugBox = nodeBox;
        self:updateDebugBox();
    end
end

--------------------------------
function Trigger:updateDebugBox()
    if self.mDebugBox then
        local box = self:getBoundingBox();
        local size = self.mNode:getBoundingBox();
        local anchor = self.mNode:getAnchorPoint();
        box.x = 0;
        box.y = 0;
        self.mDebugBox:clear();
        
        self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x + box.width, box.y), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y), cc.p(box.x, box.y + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x + box.width, box.y), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});
        self.mDebugBox:drawLine(cc.p(box.x, box.y + box.height), cc.p(box.x + box.width, box.y  + box.height), {r = 0, g = 0, b = 0, a = 100});
    end
end

---------------------------------
function Trigger:getBoundingBox()
    --debug_log("Trigger:getBoundingBox");
    local pos = self:getPosition();
    local anchor = self.mNode:getAnchorPoint();

    return cc.rect(pos.x - self.mSize.width * anchor.x, pos.y - self.mSize.height * anchor.y, self.mSize.width, self.mSize.height);
end

---------------------------------
function Trigger:getTrapPosition()
	return self.mNode:getPosition();
end

---------------------------------
function Trigger:onLeave()
	info_log("Trigger:onLeave ", self.mLeaveCallback);
	if self.mLeaveCallback then
		self.mLeaveCallback(self.mContainedObj);
	end
	self.mContainedObj = nil;
end

---------------------------------
function Trigger:onEnter(player)
	info_log("Trigger:onEnter ", self.mEnterCallback);
	if self.mEnterCallback then
		self.mEnterCallback(player, Vector.new(self:getTrapPosition()), self);
	end
	self.mContainedObj = player;
end

---------------------------------
function Trigger:destroy()
	Trigger:superClass().destroy(self);

	if self.mLeaveCallback and self.mContainedObj then
		self.mLeaveCallback(self.mContainedObj);
	end
	self.mContainedObj = nil;
end

--------------------------------
function Trigger:getCollisionObjects()
	return self.mField:getPlayerObjects();
end

--------------------------------
function Trigger:contained(point)
    --debug_log("Trigger:contained point.x ", point.x, " point.y ", point.y);
    local rect = Rect.new(self:getBoundingBox());
    --debug_log("Trigger:contained box x ", rect.x, " y ", rect.y);
    --debug_log("Trigger:contained box w ", rect.width, " h ", rect.height);
    return rect:containsPoint(cc.p(point.x, point.y));
end

--------------------------------
function Trigger:tick(dt)
	Trigger:superClass().tick(self, dt);

	-- check bbox contain player or not
	if self.mNode then 
		if self.mContainedObj then
			local contained = false;
			if self.mContainedObj.mNode then
				local pointX, pointY = self.mContainedObj.mNode:getPosition();
                contained = self:contained(Vector.new(pointX, pointY));
			end
			if not contained then
				self:onLeave();
			end
		else
			local players = self:getCollisionObjects()
			for i, player in ipairs(players) do
				local pointX, pointY = player.mNode:getPosition();
				--info_log("Trigger:tick obj x ", pointX, " y ", pointY);
				--info_log("Trigger:tick x ", self.mNode:getBoundingBox().x, " y ", self.mNode:getBoundingBox().y );
                local contained = self:contained(Vector.new(pointX, pointY));
				--info_log("contained ", contained);
				if contained then
                    info_log("self:onEnter begin ");
					self:onEnter(player)
                    info_log("self:onEnter end ");
				end
			end
		end
	end
end