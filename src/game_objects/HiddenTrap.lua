require "src/game_objects/SnareTrigger"

HiddenTrap = inheritsFrom(SnareTrigger)
HiddenTrap.mOpenAnimation = nil;

--------------------------------
function HiddenTrap:init(field, node, enterCallback, leaveCallback)
	HiddenTrap:superClass().init(self, field, node, enterCallback, leaveCallback);

	self:initAnimation();
	self:updateOrder();
end

--------------------------------
function HiddenTrap:updateOrder()
	local gridPosition = Vector.new(self.mField:getGridPosition(self.mNode));

	local newOrderPos = - gridPosition.y * 3;
	local parent = self.mNode:getParent();
	parent:removeChild(self.mNode, false);
	parent:addChild(self.mNode, newOrderPos);
end
---------------------------------
function HiddenTrap:destroy()
	HiddenTrap:superClass().destroy(self);
	self.mOpenAnimation:destroy();
end

---------------------------------
function HiddenTrap:tick(dt)
    HiddenTrap:superClass().tick(self, dt);
    self.mOpenAnimation:tick(dt);
end

---------------------------------
function HiddenTrap:getTrapPosition()
	local pos = self:getPosition();
    local anchor = self.mNode:getAnchorPoint();

    debug_log("HiddenTrap:getTrapPosition pos.y ", pos.y);
    debug_log("HiddenTrap:getTrapPosition pos.y ", self.mSize.height / 2);

    return pos.x, pos.y-- + self.mSize.height;
end

---------------------------------
function HiddenTrap:initAnimation()
	local textureEmpty = cc.Director:getInstance():getTextureCache():getFileNameForTexture(tolua.cast(self.mNode, "cc.Sprite"):getTexture());
	local _, file = string.match(textureEmpty, '(.+)/(.+)%..+');
	local animationName = file .. "Animation.plist"
	debug_log("HiddenTrap:init animationName ", animationName);

	local animation = PlistAnimation:create();
	animation:init(animationName, self.mNode, self.mNode:getAnchorPoint(), nil, 0.2);

	local sequence = SequenceAnimation:create();
    sequence:init();
    sequence:addAnimation(animation);

	debug_log("HiddenTrap:init emptyAnim ");
    local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNode, self.mNode:getAnchorPoint());
    emptyAnim:setFrame(animation:getLastFrame());

	sequence:addAnimation(emptyAnim);

	self.mOpenAnimation = sequence;
end

---------------------------------
function HiddenTrap:onEnter(player)
	HiddenTrap:superClass().onEnter(self, player);
	self.mOpenAnimation:play();
end