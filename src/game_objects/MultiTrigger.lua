require "src/game_objects/BaseObject"
require "src/base/Callback"
require "src/base/Log"

MultiTrigger = inheritsFrom(BaseObject)
MultiTrigger.mEnterCallback = nil;
MultiTrigger.mLeaveCallback = nil;
MultiTrigger.mContainedObjects = nil;

--------------------------------
function MultiTrigger:getContainedObjects()
	return self.mContainedObjects;
end

--------------------------------
function MultiTrigger:setEnterCallback(callback)
	self.mEnterCallback = callback;
end

--------------------------------
function MultiTrigger:init(field, node, enterCallback, leaveCallback)
	MultiTrigger:superClass().init(self, field, node);

    self.mContainedObjects = {}
	self.mEnterCallback = enterCallback;
	self.mLeaveCallback = leaveCallback;
end

---------------------------------
function MultiTrigger:onEnter(player)
	info_log("MultiTrigger:onEnter ", self.mEnterCallback);
	if self.mEnterCallback then
		self.mEnterCallback(player, Vector.new(self.mNode:getPosition()));
	end
	table.insert(self.mContainedObjects, player);
end

---------------------------------
function MultiTrigger:leaveAll()
    if self.mLeaveCallback and self.mContainedObjects then
        for i, player in ipairs(self.mContainedObjects) do
            self.mLeaveCallback(player);
        end
    end
    self.mContainedObjects = {};
end

---------------------------------
function MultiTrigger:destroy()
	MultiTrigger:superClass().destroy(self);

    self:leaveAll();
end

--------------------------------
function MultiTrigger:getCollisionObjects()
	return self.mField:getPlayerObjects();
end

--------------------------------
function MultiTrigger:contained(point)
    return Rect.new(self.mNode:getBoundingBox()):containsPoint(cc.p(point.x, point.y));
end

--------------------------------
function MultiTrigger:isContainedObject(player_in)
    for i, player in ipairs(self.mContainedObjects) do
        if player == player_in then
            return true;
        end
    end
    return false;
end

--------------------------------
function MultiTrigger:updateContainedObjects(dt)
    print("MultiTrigger:updateContainedObjects ");
    local containedObjects = {}
    for i, player in ipairs(self.mContainedObjects) do
        print("MultiTrigger:updateContainedObjects i ", i);
        local contained = false;
        if player.mNode then
            local pointX, pointY = player.mNode:getPosition();
            print("MultiTrigger:updateContainedObjects pointX ", pointX, " pointX ", pointY);
            contained = self:contained(Vector.new(pointX, pointY));
            print(" contained ", contained, " self.mLeaveCallback ", self.mLeaveCallback);
        end
        if not contained then
            if self.mLeaveCallback then
                info_log("MultiTrigger:updateContainedObjects leave ", player:getId());
                self.mLeaveCallback(player);
            end
        else
            table.insert(containedObjects, player);
        end
    end
    self.mContainedObjects = containedObjects
end

--------------------------------
function MultiTrigger:findCollisionObjects(dt)
    local players = self:getCollisionObjects()
    for i, player in ipairs(players) do
        info_log("MultiTrigger:findCollisionObjects ", player:getId(), " contained ", self:isContainedObject(player));
        if not self:isContainedObject(player) then
            local pointX, pointY = player.mNode:getPosition();
            --info_log("Trigger:tick obj x ", pointX, " y ", pointY);
            --info_log("Trigger:tick x ", self.mNode:getBoundingBox().x, " y ", self.mNode:getBoundingBox().y );
            local contained = self:contained(Vector.new(pointX, pointY));
            info_log("contained ", contained);
            if contained then
                info_log("self:onEnter begin ");
                self:onEnter(player)
                info_log("self:onEnter end ");
            end
        end
    end

end

--------------------------------
function MultiTrigger:tick(dt)
    info_log("MultiTrigger:tick");
	MultiTrigger:superClass().tick(self, dt);

	-- check bbox contain player or not
	if self.mNode then 
        self:updateContainedObjects(dt);
        self:findCollisionObjects(dt);
	end
end