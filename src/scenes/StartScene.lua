require "src/scenes/BaseScene"
require "src/base/Log"
require "src/gui/TouchWidget"

StartSceneTouchWidget = inheritsFrom(TouchWidget)
StartSceneTouchWidget.mScene = nil

----------------------------------------
function StartSceneTouchWidget:init(bbox, scene)
    self:superClass().init(self, bbox);
    self.mScene = scene;
end

----------------------------------------
function StartSceneTouchWidget:onDoubleTouch(point)
    debug_log("StartSceneTouchWidget:onDoubleTouch");
    self.mScene:skipMovie();
end

local LOADSCEENIMAGE = "StartScene.png"
--[[
start scene - loading screen
--]]
StartScene = inheritsFrom(BaseScene)
StartScene.mTouch = nil;
StartScene.LABEL_TAG = 2;
StartScene.LAYER_TAG = 3;

StartScene.COUNT_FRAME = 5;

local MovieTexts = {"  Далеко-далеко, на краю мира, раскинулся Вечный Лес... место, где до сих пор жива магия природы.",
"Здесь, под сенью древних деревьев, живёт дивный народ волшебных лис.",
"Тысячи лет они охраняли Вечный Лес и его обитателей от посягательств извне.",
"Но злые охотники хитростью проникли в зачарованную чащу и похитили всех беззащитных лисят.",
"Теперь клетки с ними разбросаны и по Вечному Лесу, и далеко за его пределами...",
"Пришло время помочь взрослым лисам вернуть своё потомство!"
}

--------------------------------
function StartScene:init(sceneMan, params)
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});
	info_log("StartScene:init");

	-- create menu elements
	self:createMenuElements();

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "StartScene");

    self:loadScene(sceneMan.mGame);
end

--------------------------------
function StartScene:skipMovie()
    self.mSceneManager:runNextScene();
end


--------------------------------
function StartScene:loadScene(game)
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("StartMovie", reader, false);
    self.mSceneGame:addChild(node);

    local animator = reader:getActionManager();
    animator:retain();

    local label = tolua.cast(node:getChildByTag(StartScene.LABEL_TAG), "cc.Label");
    info_log("StartScene:loadScene label ", label);

    if label then
        setDefaultFont(label, game:getScale());
        label:setString(MovieTexts[1]);
    end

    for i = 1, StartScene.COUNT_FRAME do
        function callback()
            info_log("movie frame ".. i)
            label:setString(MovieTexts[i + 1]);
        end

        local callFunc = CCCallFunc:create(callback);
        animator:setCallFuncForLuaCallbackNamed(callFunc, "0:frame"..i);
    end

    function callback_finish()
        info_log("callback_finish ")
        self.mSceneManager:runNextScene({fromTutorial = true});
    end

    local callFunc = CCCallFunc:create(callback_finish);
    local locationId = 1;
    local isLevelOpened = game:isLevelOpened(locationId, 1);
    animator:setCallFuncForLuaCallbackNamed(callFunc, isLevelOpened and "0:frame"..StartScene.COUNT_FRAME or "0:finish");

    animator:runAnimationsForSequenceNamed("Movie");

    local function onTouchHandler(action, var)
        --info_log("StartScene::onTouchHandler ", action);
    --    return self:onTouchHandler(action, var);
        return self.mTouch:onTouchHandler(action, var);
    end

    local layer = tolua.cast(node:getChildByTag(StartScene.LAYER_TAG), "cc.Layer");
    if layer then
        self.mTouch = StartSceneTouchWidget:create();
        self.mTouch:init(layer:getBoundingBox(), self);

        layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
        layer:setTouchEnabled(true);
    else
        info_log("ERROR: StartScene:loadScene not found layer !!!");
    end
end

--------------------------------
function StartScene:createMenuElements()
	
	self:createGuiLayer();

	-- play button
	--[[local menuToolsItem = CCMenuItemImage:create("menu1.png", "menu2.png");
    menuToolsItem:setPosition(0, 0);

    local startScene = self;

    local function onPlayGamePressed(val, val2)
    	info_log("onPlayGame ", val, val2);
        menuToolsItem:unregisterScriptTapHandler();
    	startScene.mSceneManager:runNextScene();
    end

    menuToolsItem:registerScriptTapHandler(onPlayGamePressed);
    local menuTools = cc.Menu:createWithItem(menuToolsItem);
    
    self.mGuiLayer:addChild(menuTools);]]
end

---------------------------------
function StartScene:tick(dt)
	self:superClass().tick(self, dt);
    if self.mTouch then
        self.mTouch:tick(dt);
    end
end
