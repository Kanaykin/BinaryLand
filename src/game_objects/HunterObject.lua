require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/base/Log"

HunterObject = inheritsFrom(MobObject)

--------------------------------
function HunterObject:initAnimation()
	info_log("HunterObject:initAnimation");
    self.mAnimations = {};

	info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("HunterWalkSide.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

	local sideAnimation = RepeatAnimation:create();
	sideAnimation:init(animation);
	sideAnimation:play();

    self.mAnimation = MobObject.DIRECTIONS.SIDE;
    self.mAnimations[MobObject.DIRECTIONS.SIDE] = sideAnimation;

    ------------------------
    -- Front animation
    local animationFront = PlistAnimation:create();
    animationFront:init("HunterWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = frontAnimation;

    ------------------------
    -- Back animation
    local animationBack = PlistAnimation:create();
    animationBack:init("HunterWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[MobObject.DIRECTIONS.BACK] = backAnimation;
end

--------------------------------
function HunterObject:tick(dt)
    HunterObject:superClass().tick(self, dt);
end