require "src/game_objects/MobObject"
require "src/game_objects/TornadoStates.lua"

TornadoObject = inheritsFrom(MobObject)
TornadoObject.mPoints = nil;
TornadoObject.mDestIndex = 2;
TornadoObject.mVelocity = 40;

--------------------------------
function TornadoObject:init(field, node)
    TornadoObject:superClass().init(self, field, node);
    info_log("TornadoObject:init(", node, " id ", self:getId(), ")");
    self.mStateMachine = TornadoStateMachine:create();
    self.mStateMachine:init(self);

	self.mPoints = {}
    self.mPoints[1] = Vector.new(self.mGridPosition.x, self.mGridPosition.y);
    self.mPoints[2] = Vector.new(self.mGridPosition.x, self.mGridPosition.y - 3);
    debug_log("TornadoObject:init ", self.mPoints[1].x, " ", self.mPoints[1].y);

	tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(true);
    tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(false);
end

--------------------------------
function TornadoObject:getDestPoint()
	if self.mPoints[self.mDestIndex].x == self.mGridPosition.x and 
		self.mPoints[self.mDestIndex].y == self.mGridPosition.y then
		self.mDestIndex = self.mDestIndex == 1 and 2 or 1;
	end
	debug_log("TornadoObject:getDestPoint ", self.mDestIndex)
	tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(false);
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
        --self:resetMovingParams();
        --self:startMoving(self:getDestPoint());
    end
end

--------------------------------
function TornadoObject:onMoveFinished()
	debug_log("TornadoObject:onMoveFinished ", self.mGridPosition.x, ", ", self.mGridPosition.y);
	--self.mDestIndex = self.mDestIndex == 1 and 2 or 1;
	debug_log("TornadoObject:onMoveFinished self.mDestIndex ", self.mDestIndex)
    TornadoObject:superClass().onMoveFinished(self);
end

--------------------------------
function TornadoObject:onPlayerEnterImpl(player, pos)
	info_log("TornadoObject.onPlayerEnterImpl ", player.mNode:getTag());
	TornadoObject:superClass().onPlayerEnterImpl(self, player, pos);
end