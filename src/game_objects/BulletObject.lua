require "src/game_objects/MobObject"

BulletObject = inheritsFrom(MobObject)
BulletObject.ANCHOR_BY_DIR = {}
BulletObject.mAnimationNode = nil;


--------------------------------
function BulletObject:init(field, pos, goalPos, dir)
	local position = pos + dir * field:getCellSize() * 2;
	local animationNode = CCSprite:create("Bullet.png");
	self.mAnimationNode = animationNode;
	--self.mAnimationNode:setAnchorPoint(cc.p(-2.5, 0.5));
	--node:setPosition(position.x, position.y);

	local node = CCNode:create();
    node:setContentSize(cc.size(field:getCellSize(), field:getCellSize()));
    node:setPosition(position.x, position.y);
    node:addChild(animationNode);
    --self.mAnimationNode:setAnchorPoint({-2.5, 0.5});

	debug_log("BulletObject:getAnchorByDir goalPos y ", goalPos.y, " x ", goalPos.x);
	debug_log("BulletObject:getAnchorByDir  y ", field:getGridPosition(node));
	local anchor = self:getAnchorByDir((goalPos - Vector.new(field:getGridPosition(node))):normalize());

	--node:setAnchorPoint(anchor);
	node:setContentSize(cc.size(field:getCellSize(), field:getCellSize()));

	field:getFieldNode():addChild(node);

	debug_log("BulletObject:getAnchorByDir dir y ", dir.y, " x ", dir.x);
	--self.mAnimationNode:setAnchorPoint(cc.p(0.5 + dir.x, 0.5 + dir.y) );
	self.mAnimationNode:setAnchorPoint(cc.p(anchor.x + dir.x * 2, anchor.y + dir.y * 2) );

	BulletObject:superClass().init(self, field, node);

	self.mVelocity = 400;
end

--------------------------------
function BulletObject:createAnimation(nameAnimation, dir, time)

	local sequence = SequenceAnimation:create();
    sequence:init();

	local anchor = self.mAnimationNode:getAnchorPoint();

    local animation = PlistAnimation:create();
    animation:init(nameAnimation, self.mAnimationNode, anchor, nil, time);
    sequence:addAnimation(animation);

    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mAnimationNode, anchor);
    emptyAnim:setFrame(animation:getLastFrame());
    sequence:addAnimation(emptyAnim);

    self.mAnimations[dir] = sequence
end

--------------------------------
function BulletObject:initAnimation()
	info_log("BulletObject:initAnimation ")
	self.mAnimations = {}
	self:createAnimation("BulletAnimation.plist", MobObject.DIRECTIONS.SIDE, 0.06)
	self:createAnimation("BulletTopAnimation.plist", MobObject.DIRECTIONS.FRONT, 0.06)
	self:createAnimation("BulletTopAnimation.plist", MobObject.DIRECTIONS.BACK, 0.06)
end

--------------------------------
function BulletObject:getVerticalFlipByDirection()

    if not self.mDelta then
        return nil;
    end

    local val = self.mDelta:normalized();
    return val.y < 0;
end

--------------------------------
function BulletObject:getAnchorByDir(dir)
	debug_log("BulletObject:getAnchorByDir dir y ", dir.y, " x ", dir.x);
    if dir then
        if dir.y >= 0.9 then
            return cc.p(0.5, 0.0);
        elseif dir.y <= -0.9 then
            return cc.p(0.5, 0.5);
        elseif dir.x >= 0.9 then
            return cc.p(-0.2, 0.0);
        elseif dir.x <= -0.9 then
            return cc.p(1.4, 0.33);
        end
    end
    return cc.p(0.7, 0.2);
end

---------------------------------
function BulletObject:getBoundingBox()
	local box = BulletObject:superClass().getBoundingBox(self);
	info_log("BulletObject:getBoundingBox x ", box.x, " y ", box.y);
	local anchor = self.mNode:getAnchorPoint();
	info_log("BulletObject:getBoundingBox anchor x ", anchor.x, " y ", anchor.y);
	return box;
end

--------------------------------
function BulletObject:onMoveFinished()
	BulletObject:superClass().onMoveFinished(self);
	self.mField:delayDelete(self);
end

--------------------------------
function BulletObject:onPlayerEnterImpl(player, pos)
	info_log("BulletObject.onPlayerEnterImpl ", player.mNode:getTag());
	BulletObject:superClass().onPlayerEnterImpl(self, player, pos);

	if not player:isInTrap() then
		self.mField:createSnareTrigger(Vector.new(player.mNode:getPosition()), true);
		self.mField:delayDelete(self);
	end
end

--------------------------------
function BulletObject:updateFlip()
    local flip = self:getFlipByDirection();
    if flip ~= nil then
        tolua.cast(self.mAnimationNode, "cc.Sprite"):setFlippedX(flip);
    end

    local flipY = self:getVerticalFlipByDirection();
    if flipY ~= nil then
        tolua.cast(self.mAnimationNode, "cc.Sprite"):setFlippedY(flip);
    end
end

--------------------------------
function BulletObject:tick(dt)
	BulletObject:superClass().tick(self, dt);

end
