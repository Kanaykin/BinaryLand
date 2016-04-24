require "src/game_objects/MobObject"
require "src/game_objects/TornadoStates.lua"

TornadoObject = inheritsFrom(MobObject)
TornadoObject.mPoints = nil;
TornadoObject.mDestIndex = 2;

--------------------------------
function TornadoObject:init(field, node)
    TornadoObject:superClass().init(self, field, node);
    info_log("TornadoObject:init(", node, " id ", self:getId(), ")");
    self.mStateMachine = TornadoStateMachine:create();
    self.mStateMachine:init(self);

	self.mPoints = {}
    self.mPoints[1] = Vector.new(self.mGridPosition.x, self.mGridPosition.y);
    self.mPoints[2] = Vector.new(self.mGridPosition.x, self.mGridPosition.y - 3);
end

--------------------------------
function TornadoObject:getDestPoint()
	debug_log("TornadoObject:getDestPoint ", self.mDestIndex)
	return self.mPoints[self.mDestIndex];
end

--------------------------------
function TornadoObject:initAnimation()
end

---------------------------------
function TornadoObject:setCustomProperties(properties)
    info_log("TornadoObject:setCustomProperties ");

    TornadoObject:superClass().setCustomProperties(self, properties);

    if properties.DestPoint then
		local one, two = properties.DestPoint:match("([^,]+),([^,]+)")
		self.mPoints[2] = Vector.new(one, two);
        --self.mCanAttack = properties.CanAttack;
    end
end

--------------------------------
function TornadoObject:onMoveFinished()
	self.mDestIndex = self.mDestIndex == 1 and 2 or 1;
	debug_log("TornadoObject:onMoveFinished self.mDestIndex ", self.mDestIndex)
    TornadoObject:superClass().onMoveFinished(self);
end

--------------------------------
function TornadoObject:onPlayerEnterImpl(player, pos)
	info_log("TornadoObject.onPlayerEnterImpl ", player.mNode:getTag());
	TornadoObject:superClass().onPlayerEnterImpl(self, player, pos);
end