require "src/base/Inheritance"
require "src/gui/TouchWidget"

StartSceneTouchWidget = inheritsFrom(TouchWidget);
StartSceneTouchWidget.mScene = nil;
StartSceneTouchWidget.mTouch = nil;

----------------------------------------
function StartSceneTouchWidget:init(bbox, scene)
    StartSceneTouchWidget:superClass().init(self, bbox);
    self.mScene = scene;
end

----------------------------------------
function StartSceneTouchWidget:onDoubleTouch(point)
    debug_log("StartSceneTouchWidget:onDoubleTouch");
    self.mScene:skipMovie();
end

StartMovieStep =  inheritsFrom(nil)
StartMovieStep.LABEL_TAG = 2;
StartMovieStep.LAYER_TAG = 3;

--------------------------------
function StartMovieStep:init(sceneGame, stepName, callback, game, startScene)
	local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile(stepName, reader, false);
    sceneGame:addChild(node);

	local animator = reader:getActionManager();
    animator:retain();

    function loc_callback()
    	info_log("finish Step ")
    	sceneGame:removeChild(node);
    	callback();
    end

    local callFunc = CCCallFunc:create(loc_callback);
    animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finishStep");

    animator:runAnimationsForSequenceNamed("Movie");

    self:initLabel(node, game, stepName);
    self:initDoubleTouch(node, startScene);
end

--------------------------------
function StartMovieStep:initLabel(node, game, stepName)
	local label = tolua.cast(node:getChildByTag(StartMovieStep.LABEL_TAG), "cc.Label");
    info_log("StartMovieStep:loadScene label ", label);

    local localizationManager = game:getLocalizationManager();
    local text = localizationManager:getStringForKey(stepName.."Text");
    debug_log("StartMovieStep:initLabel text ", text);
    if label then
        setDefaultFont(label, game:getScale());
        if text then
            label:setString(text);
        end
    end
end

---------------------------------
function StartMovieStep:tick(dt)
	if self.mTouch then
		self.mTouch:tick(dt)
	end
end

--------------------------------
function StartMovieStep:initDoubleTouch(node, startScene)
	local function onTouchHandler(action, var)
        info_log("StartMovieStep::onTouchHandler ", action);
    --    return self:onTouchHandler(action, var);
        return self.mTouch:onTouchHandler(action, var);
    end

    local layer = tolua.cast(node:getChildByTag(StartMovieStep.LAYER_TAG), "cc.Layer");
    if layer then
        self.mTouch = StartSceneTouchWidget:create();
        self.mTouch:init(layer:getBoundingBox(), startScene);

        layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
        layer:setTouchEnabled(true);
    else
        info_log("ERROR: StartMovieStep:loadScene not found layer !!!");
    end

end
