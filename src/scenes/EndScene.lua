require "src/scenes/BaseScene"
require "src/animations/MultyPlistAnimation"

EndScene = inheritsFrom(BaseScene)
EndScene.mAnimation = nil
EndScene.mNode = nil

EndScene.SPRITE_TAG = 10

--------------------------------
function EndScene:init(sceneMan, params)
	EndScene:superClass().init(self, sceneMan, params);

	local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("EndScene");

    self:loadScene();

    self:initAnimation();
end

--------------------------------
function EndScene:loadScene()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("EndMovieStep1", reader, false);
    self.mSceneGame:addChild(node);

    self.mNode = node:getChildByTag(EndScene.SPRITE_TAG);
    info_log("EndScene:loadScene ", self.mNode);
end

--------------------------------
function EndScene:initAnimation()
	local sequence = SequenceAnimation:create();
    sequence:init();

	local animation = MultyPlistAnimation:create();
	animation:init("EndMovieAnim{n}.plist", self.mNode, nil, nil, 0.2, 5);

	local delay = DelayAnimation:create();
	delay:init(animation, 0.1);
	sequence:addAnimation(delay);

	local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNode, nil);
    emptyAnim:setFrame(animation:getLastFrame());

    sequence:addAnimation(emptyAnim);

	self.mAnimation = sequence;

	self.mAnimation:play();
end

---------------------------------
function EndScene:tick(dt)
	EndScene:superClass().tick(self, dt);

	if self.mAnimation then
		self.mAnimation:tick(dt);
	end
end