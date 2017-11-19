require "src/scenes/BaseScene"
require "src/animations/MultyPlistAnimation"

EndScene = inheritsFrom(BaseScene)
EndScene.mAnimation1 = nil
EndScene.mNodeStep1 = nil
EndScene.mNodeStep2 = nil

EndScene.SPRITE1_TAG = 10
EndScene.SPRITE2_TAG = 12

--------------------------------
function EndScene:init(sceneMan, params)
	EndScene:superClass().init(self, sceneMan, params);

	local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("EndScene");

    self:loadScene();

    self:initAnimationStep1();
    self:initAnimationStep2();
end

--------------------------------
function EndScene:loadScene()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("EndMovieStep1", reader, false);
    self.mSceneGame:addChild(node);

    self.mNodeStep1 = node:getChildByTag(EndScene.SPRITE1_TAG);
    info_log("EndScene:loadScene ", self.mNodeStep1);
    self.mNodeStep2 = node:getChildByTag(EndScene.SPRITE2_TAG);
    info_log("EndScene:loadScene ", self.mNodeStep2);

    local animator = reader:getActionManager();
    animator:retain();

    function loc_callback()
    	info_log("EndScene finish Step ")
    	-- self:initAnimationStep2();
    	-- sceneGame:removeChild(node);
    	-- callback();
    	self.mAnimation2:play();
    end

    local callFunc = CCCallFunc:create(loc_callback);
    animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finishStep");

    animator:runAnimationsForSequenceNamed("Animation");
end

--------------------------------
function EndScene:initAnimationStep2()
	-- local sequence = SequenceAnimation:create();
 --    sequence:init();

	local animation = MultyPlistAnimation:create();
	animation:init("EndMovieAnim2{n}.plist", self.mNodeStep2, nil, nil, 0.2, 2);

	-- local delay = DelayAnimation:create();
	-- delay:init(animation, 0.2);
	-- sequence:addAnimation(delay);
	-- sequence:addAnimation(animation);

	-- local emptyAnim = EmptyAnimation:create();
 --    emptyAnim:init(nil, self.mNodeStep2, nil);
 --    emptyAnim:setFrame(animation:getLastFrame());

 --    sequence:addAnimation(emptyAnim);

 	local repeate = RepeatAnimation:create();
 	repeate:init(animation, true);
	self.mAnimation2 = repeate;

	-- self.mAnimation2:play();
end

--------------------------------
function EndScene:initAnimationStep1()
	local sequence = SequenceAnimation:create();
    sequence:init();

	local animation = MultyPlistAnimation:create();
	animation:init("EndMovieAnim{n}.plist", self.mNodeStep1, nil, nil, 0.2, 6);

	local delay = DelayAnimation:create();
	delay:init(animation, 2);
	sequence:addAnimation(delay);

	local emptyAnim = EmptyAnimation:create();
    emptyAnim:init(nil, self.mNodeStep1, nil);
    emptyAnim:setFrame(animation:getLastFrame());

    sequence:addAnimation(emptyAnim);

	self.mAnimation1 = sequence;

	self.mAnimation1:play();
end

---------------------------------
function EndScene:tick(dt)
	EndScene:superClass().tick(self, dt);

	if self.mAnimation1 then
		self.mAnimation1:tick(dt);
	end

	if self.mAnimation2 then
		self.mAnimation2:tick(dt);
	end
end