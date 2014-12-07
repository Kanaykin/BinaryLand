require "src/game_objects/BaseObject"
require "src/base/Callback"
require "src/animations/SequenceAnimation"

FinishObject = inheritsFrom(BaseObject)

FinishObject.mFinishAnimation = nil;
FinishObject.mAnimation = nil;

--------------------------------
function FinishObject:createAnimation(nameAnimation)
	local texture = cc.Director:getInstance():getTextureCache():addImage(nameAnimation);
	texture:retain();

	local anim1 = EmptyAnimation:create(); 
	anim1:init(texture, self.mNode, self.mNode:getAnchorPoint());

	local delayAnim = DelayAnimation:create();
	delayAnim:init(anim1, 1);


	self.mFinishAnimation:addAnimation(delayAnim);
end

--------------------------------
function FinishObject:createIdleAnimation(animation, nameAnimation, node, texture, textureSize, textureName)
    local idle = PlistAnimation:create();
    idle:init(nameAnimation, node, node:getAnchorPoint());
    --local delayAnim = DelayAnimation:create();
    --delayAnim:init(idle, math.random(2, 5), texture, textureSize, textureName);
    --animation:addAnimation(delayAnim);
    animation:addAnimation(idle);
end

--------------------------------
function FinishObject:init(field, node)
	print("FinishObject:init ");
	FinishObject:superClass().init(self, field, node);

    local texture = tolua.cast(node, "cc.Sprite"):getTexture();

	local randomAnim = RandomAnimation:create();
    randomAnim:init();
	self:createIdleAnimation(randomAnim, "BabyIdle1.plist", node, texture, contentSize, textureName);
    self:createIdleAnimation(randomAnim, "BabyIdle2.plist", node, texture, contentSize, textureName);
    self.mAnimation = randomAnim;
    self.mAnimation:play();

	self.mFinishAnimation = SequenceAnimation:create();
	self.mFinishAnimation:init();
	self:createAnimation("love_cage_fox_free.png");
	self:createAnimation("love_cage_fox_free_litle.png");
end

--------------------------------
function FinishObject:tick(dt)
	FinishObject:superClass().tick(self, dt);

	self.mFinishAnimation:tick(dt);

    self.mAnimation:tick(dt);
end

---------------------------------
function FinishObject:onStateWin()
	FinishObject:superClass().onStateWin(self);

	self.mFinishAnimation:play();
end