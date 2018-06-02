require "src/scenes/BaseScene"
require "src/animations/MultyPlistAnimation"
require "src/gui/TouchWidget"

EndSceneTouchWidget = inheritsFrom(TouchWidget);
EndSceneTouchWidget.mEnabled = false
EndSceneTouchWidget.mSceneMan = nil


----------------------------------------
function EndSceneTouchWidget:init(bbox, sceneMan)
    EndSceneTouchWidget:superClass().init(self, bbox);
    self.mSceneMan = sceneMan;
end

----------------------------------------
function EndSceneTouchWidget:onTouchEnded(point)
    debug_log("EndSceneTouchWidget:onTouchEnded");
    -- self.mScene:skipMovie();
    if self.mEnabled then
    	self.mSceneMan:runNextScene(nil, SCENE_TYPE_ID.CREDITS_SCENE);
    end
end

----------------------------------------
function EndSceneTouchWidget:enableTouch()
	self.mEnabled = true;
end

EndScene = inheritsFrom(BaseScene)
EndScene.mAnimation1 = nil
EndScene.mNodeStep1 = nil
EndScene.mNodeStep2 = nil
EndScene.mTouch = nil
EndScene.mNode = nil;

EndScene.SPRITE1_TAG = 10
EndScene.SPRITE2_TAG = 12

EndScene.LABEL_TAG = 2;
EndScene.LAYER_TAG = 3;


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
    local ccpproxy = cc.CCBProxy:create();
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
    	self:initLabel(node, self.mSceneManager.mGame, "EndStep2");
    	if self.mTouch then
    		self.mTouch:enableTouch();
    	end
    end

    local callFunc = cc.CallFunc:create(loc_callback);
    animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finishStep");

    animator:runAnimationsForSequenceNamed("Animation");

    self:initLabel(node, self.mSceneManager.mGame, "EndStep1");

    self:initTouch(node);
    self.mNode = node;
end

--------------------------------
function EndScene:initAnimationStep2()
	-- local sequence = SequenceAnimation:create();
 --    sequence:init();

	local animation = MultyPlistAnimation:create();
	animation:init("EndMovieAnim2{n}.plist", self.mNodeStep2, nil, nil, 0.1, 2);

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
function EndScene:initLabel(node, game, stepName)
	local label = tolua.cast(node:getChildByTag(EndScene.LABEL_TAG), "cc.Label");
    info_log("EndScene:loadScene label ", label);

    local localizationManager = game:getLocalizationManager();
    local text = localizationManager:getStringForKey(stepName.."Text");
    debug_log("EndScene:initLabel text ", text);
    if label then
        setDefaultFont(label, game:getScale());
        if text then
            label:setString(text);
        end
    end
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

---------------------------------
function EndScene:destroy()
	info_log("EndScene:destroy ");

	-- self.mTouch:release();

	local layer = tolua.cast(self.mNode:getChildByTag(EndScene.LAYER_TAG), "cc.Layer");
    if layer then
		layer:unregisterScriptTouchHandler();
	end

	EndScene:superClass().destroy(self);
end

--------------------------------
function EndScene:initTouch(node)
	local function onTouchHandler(action, var)
        info_log("EndScene::onTouchHandler ", action);
    --    return self:onTouchHandler(action, var);
        return self.mTouch:onTouchHandler(action, var);
    end

    local layer = tolua.cast(node:getChildByTag(EndScene.LAYER_TAG), "cc.Layer");
    if layer then
        self.mTouch = EndSceneTouchWidget:create();
        self.mTouch:init(layer:getBoundingBox(), self.mSceneManager);

        layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
        layer:setTouchEnabled(true);
    else
        info_log("ERROR: StartMovieStep:loadScene not found layer !!!");
    end
end
