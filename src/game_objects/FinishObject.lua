require "src/game_objects/BaseObject"
require "src/base/Callback"
require "src/animations/SequenceAnimation"

FinishObject = inheritsFrom(BaseObject)

FinishObject.mFinishAnimation = nil;
FinishObject.mAnimation = nil;
FinishObject.mWinState = false;

--------------------------------
function FinishObject:createAnimation(nameAnimation)
	local texture = cc.Director:getInstance():getTextureCache():addImage(nameAnimation);
	texture:retain();

	local anim1 = EmptyAnimation:create(); 
	anim1:init(texture, self.mNode, self.mNode:getAnchorPoint());

	local delayAnim = DelayAnimation:create();
	delayAnim:init(anim1, 1);


	--self.mFinishAnimation:addAnimation(delayAnim);
end

--------------------------------
function FinishObject:createIdleAnimation(animation, nameAnimation, node, texture, textureSize, textureName,
                                        times, delayPerUnit)
    local repeat_idle = RepeatAnimation:create();

    local idle = PlistAnimation:create();
    idle:init(nameAnimation, node, node:getAnchorPoint(), nil, delayPerUnit);
    repeat_idle:init(idle, false, times);
    animation:addAnimation(repeat_idle);
end

--------------------------------
function FinishObject:init(field, node)
	print("FinishObject:init ");
	FinishObject:superClass().init(self, field, node);

    local texture = tolua.cast(node, "cc.Sprite"):getTexture();

	local randomAnim = RandomAnimation:create();
    randomAnim:init();
	self:createIdleAnimation(randomAnim, "BabyIdle1.plist", node, texture, contentSize, textureName, 3);
    self:createIdleAnimation(randomAnim, "BabyIdle2.plist", node, texture, contentSize, textureName, 1, 0.15);
    self.mAnimation = randomAnim;
    self.mAnimation:play();

    local textureName = "save_baby.png"
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    local anim = PlistAnimation:create();
    local anchor = {x=0.47, y=0.158};
    anim:init("SaveBaby.plist", node, anchor, texture, 0.06);

    local texture_end = cc.Director:getInstance():getTextureCache():addImage("save_baby_end.png");
    local empty = EmptyAnimation:create();
    empty:init(texture_end, node, anchor);

    local sequence = SequenceAnimation:create();
    sequence:init();

    sequence:addAnimation(anim);
    sequence:addAnimation(empty);

    self.mFinishAnimation = sequence;
end

--------------------------------
function FinishObject:tick(dt)
	FinishObject:superClass().tick(self, dt);

    if self.mWinState then
        self.mFinishAnimation:tick(dt);
    else
        self.mAnimation:tick(dt);
    end
end

---------------------------------
function FinishObject:onStateWin()
	FinishObject:superClass().onStateWin(self);

    self.mNode:stopAllActions();
    self.mWinState = true;
    --self.mAnimation:stop();
	self.mFinishAnimation:play();
    self.mFinishAnimation:tick(0);
end