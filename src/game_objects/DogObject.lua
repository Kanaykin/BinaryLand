require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/animations/RepeatAnimation"

DogObject = inheritsFrom(MobObject)

--------------------------------
function DogObject:initAnimation()
	print("HunterObject:initAnimation");

	print("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("DogWalk.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

	local sideAnimation = RepeatAnimation:create();
	sideAnimation:init(animation);
	sideAnimation:play();

    self.mAnimations = {}
    self.mAnimation = MobObject.DIRECTIONS.SIDE;
    self.mAnimations[MobObject.DIRECTIONS.SIDE] = sideAnimation;

    ------------------------
    -- Front animation
    local animationFront = PlistAnimation:create();
    animationFront:init("DogWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = frontAnimation;

    ------------------------
    -- Back animation
    local animationBack = PlistAnimation:create();
    animationBack:init("DogWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.16);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[MobObject.DIRECTIONS.BACK] = backAnimation;
end

--------------------------------
function DogObject:tick(dt)
	DogObject:superClass().tick(self, dt);
end