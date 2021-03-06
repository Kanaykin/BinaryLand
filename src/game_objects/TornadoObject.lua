require "src/game_objects/MobObject"
require "src/game_objects/TornadoStates"
require "src/math/Algorithm"

TornadoObject = inheritsFrom(MobObject)
TornadoObject.mPoints = nil;
TornadoObject.mDestIndex = 2;
TornadoObject.mVelocity = 40;
TornadoObject.mPlayerContained = false;

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
function TornadoObject:releaseNode()
	local node = self.mNode;
	self.mNode = nil;
	return node;
end

--------------------------------
function TornadoObject:isFireTornado()
	return false;
end

--------------------------------
function TornadoObject:getDestPoint()
	--debug_log("TornadoObject:getDestPoint dest x ", self.mPoints[self.mDestIndex].x);
	--debug_log("TornadoObject:getDestPoint dest y ", self.mPoints[self.mDestIndex].y);

	--debug_log("TornadoObject:getDestPoint cur x ", self.mGridPosition.x);
	--debug_log("TornadoObject:getDestPoint cur y ", self.mGridPosition.y);

	--debug_log("TornadoObject:getDestPoint dest index ", self.mPoints[self.mDestIndex].x == self.mGridPosition.x);
	--debug_log("TornadoObject:getDestPoint dest index ", self.mPoints[self.mDestIndex].y == self.mGridPosition.y);
	if Algorithm.equal(self.mPoints[self.mDestIndex].x, self.mGridPosition.x) and 
		Algorithm.equal(self.mPoints[self.mDestIndex].y, self.mGridPosition.y) then
		self.mDestIndex = self.mDestIndex == 1 and 2 or 1;
	end
	debug_log("TornadoObject:getDestPoint ", self.mDestIndex)
	tolua.cast(self.mNode, "cc.Sprite"):setFlippedX(false);
	return self.mPoints[self.mDestIndex];
end

--------------------------------
function TornadoObject:createAnimation()
	local textureEmpty = cc.Director:getInstance():getTextureCache():getFileNameForTexture(tolua.cast(self.mNode, "cc.Sprite"):getTexture());
	local _, file = string.match(textureEmpty, '(.+)/(.+)%..+');

	local animation = PlistAnimation:create();
    animation:init(file.."Animation.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.18);

    local sideAnimation = RepeatAnimation:create();
    sideAnimation:init(animation);

    return sideAnimation;
end

--------------------------------
function TornadoObject:initAnimation()
	debug_log("TornadoObject:initAnimation ");
	self.mAnimations = {};

    self.mAnimations[MobObject.DIRECTIONS.SIDE] = self:createAnimation();
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = self:createAnimation();
    self.mAnimations[MobObject.DIRECTIONS.BACK] = self:createAnimation();
    debug_log("TornadoObject:initAnimation 2");
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
	info_log("TornadoObject.onPlayerEnterImpl ", player:getId(), " ", self.mPlayerContained);
	if not self.mPlayerContained then
		TornadoObject:superClass().onPlayerEnterImpl(self, player, pos);
		self.mPlayerContained = true;
	end
end