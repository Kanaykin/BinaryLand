require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/animations/RepeatAnimation"

DogObject = inheritsFrom(MobObject)

DogObject.mAnimation = nil;

--------------------------------
function DogObject:initAnimation()
	print("HunterObject:initAnimation");

	print("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("DogWalk.plist", self.mNode, self.mNode:getAnchorPoint());

	self.mAnimation = RepeatAnimation:create();
	self.mAnimation:init(animation);
	self.mAnimation:play();
end

--------------------------------
function DogObject:tick(dt)
	DogObject:superClass().tick(self, dt);

	self.mAnimation:tick(dt);
end