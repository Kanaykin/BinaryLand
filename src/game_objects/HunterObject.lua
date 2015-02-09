require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"

HunterObject = inheritsFrom(MobObject)

HunterObject.mAnimation = nil;

HunterObject.mAnimations = nil;

HunterObject.DIRECTIONS = {
    SIDE = 1,
    FRONT = 2,
    BACK = 3
};

--------------------------------
function HunterObject:getAnimationByDirection()
    if self.mDelta then
        local val = self.mDelta:normalized();
        --print("HunterObject:tick self.mDelta ", val.y);
        if val.y >= 1 then
            return HunterObject.DIRECTIONS.BACK;
        elseif val.y <= -1 then
            return HunterObject.DIRECTIONS.FRONT;
        end
    end
    return HunterObject.DIRECTIONS.SIDE;
end

--------------------------------
function HunterObject:initAnimation()
	print("HunterObject:initAnimation");
    self.mAnimations = {};

	print("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("HunterWalkSide.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

	local sideAnimation = RepeatAnimation:create();
	sideAnimation:init(animation);
	sideAnimation:play();

    self.mAnimation = HunterObject.DIRECTIONS.SIDE;
    self.mAnimations[HunterObject.DIRECTIONS.SIDE] = sideAnimation;

    ------------------------
    -- Front animation
    local animationFront = PlistAnimation:create();
    animationFront:init("HunterWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[HunterObject.DIRECTIONS.FRONT] = frontAnimation;

    ------------------------
    -- Back animation
    local animationBack = PlistAnimation:create();
    animationBack:init("HunterWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[HunterObject.DIRECTIONS.BACK] = backAnimation;
end

--------------------------------
function HunterObject:tick(dt)
    HunterObject:superClass().tick(self, dt);
    local anim = self:getAnimationByDirection();
    if anim ~= self.mAnimation then
        self.mAnimation = anim;
        self.mNode:stopAllActions();
        self.mAnimations[self.mAnimation]:play();
    end
end