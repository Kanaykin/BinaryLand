require "src/scenes/BaseScene"
require "src/base/Log"

local LOADSCEENIMAGE = "StartScene.png"
--[[
start scene - loading screen
--]]
StartScene = inheritsFrom(BaseScene)
StartScene.LABEL_TAG = 2;

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

    function callback2()
        info_log("movie frame 1")
    end

    local callFunc = CCCallFunc:create(callback2);
    animator:setCallFuncForLuaCallbackNamed(callFunc, "0:frame4");

    animator:runAnimationsForSequenceNamed("Movie");
end

--------------------------------
function StartScene:createMenuElements()
	
	self:createGuiLayer();

	-- play button
	local menuToolsItem = CCMenuItemImage:create("menu1.png", "menu2.png");
    menuToolsItem:setPosition(0, 0);

    local startScene = self;

    local function onPlayGamePressed(val, val2)
    	info_log("onPlayGame ", val, val2);
        menuToolsItem:unregisterScriptTapHandler();
    	startScene.mSceneManager:runNextScene();
    end

    menuToolsItem:registerScriptTapHandler(onPlayGamePressed);
    local menuTools = cc.Menu:createWithItem(menuToolsItem);
    
    self.mGuiLayer:addChild(menuTools);
end

---------------------------------
function StartScene:tick(dt)
	self:superClass().tick(self, dt);
end
