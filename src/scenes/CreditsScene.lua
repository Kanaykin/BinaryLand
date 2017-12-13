require "src/scenes/BaseScene"
require "src/gui/TouchWidget"

CreditsSceneTouchWidget = inheritsFrom(TouchWidget);
CreditsSceneTouchWidget.mSceneMan = nil
CreditsSceneTouchWidget.mTouch = nil
 
----------------------------------------
function CreditsSceneTouchWidget:init(bbox, sceneMan)
    EndSceneTouchWidget:superClass().init(self, bbox);
    self.mSceneMan = sceneMan;
end

----------------------------------------
function CreditsSceneTouchWidget:onTouchEnded(point)
    debug_log("EndSceneTouchWidget:onTouchEnded");
    self.mSceneMan:runNextScene(nil, SCENE_TYPE_ID.CHOOSE_LOCATION);
end

CreditsScene = inheritsFrom(BaseScene);
CreditsScene.mNode = nil;

CreditsScene.FIRST_LABEL_TAG = 1
CreditsScene.LAST_LABEL_TAG = 9

CreditsScene.LABELS_CONTAINER_TAG = 100
CreditsScene.LAYER_TAG = 3;

--------------------------------
function CreditsScene:init(sceneMan, params)
	CreditsScene:superClass().init(self, sceneMan, params);
	self:loadScene();
	self:initLabels();
	self:initTouch(self.mNode);
end

--------------------------------
function CreditsScene:loadScene()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("CreditsScene", reader, false);
    self.mNode = node;
    self.mSceneGame:addChild(node);
end

--------------------------------
function CreditsScene:initLabels()
	local container = self.mNode:getChildByTag(CreditsScene.LABELS_CONTAINER_TAG);
	if not container then
		return;
	end

	for i = CreditsScene.FIRST_LABEL_TAG, CreditsScene.LAST_LABEL_TAG do
		local label = tolua.cast(container:getChildByTag(i), "cc.Label");
	    info_log("CreditsScene:initLabels label ", label);

	    if label then
	        setDefaultFont(label, self:getGame():getScale());
	    end
	end
end

---------------------------------
function CreditsScene:destroy()

	info_log("CreditsScene:destroy ");

    local layer = tolua.cast(self.mNode:getChildByTag(CreditsScene.LAYER_TAG), "cc.Layer");
    if layer then
		layer:unregisterScriptTouchHandler();
	end

	CreditsScene:superClass().destroy(self);

	-- self.mTouch:release();
end

--------------------------------
function CreditsScene:initTouch(node)
	local function onTouchHandler(action, var)
        info_log("CreditsScene::onTouchHandler ", action);
    --    return self:onTouchHandler(action, var);
        return self.mTouch:onTouchHandler(action, var);
    end

    local layer = tolua.cast(node:getChildByTag(CreditsScene.LAYER_TAG), "cc.Layer");
    if layer then
        self.mTouch = CreditsSceneTouchWidget:create();
        self.mTouch:init(layer:getBoundingBox(), self.mSceneManager);

        layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
        layer:setTouchEnabled(true);
    else
        info_log("ERROR: StartMovieStep:loadScene not found layer !!!");
    end
end