require "src/scenes/BaseScene"
require "src/base/Log"

local LOADSCEENIMAGE = "StartScene.png"
--[[
start scene - loading screen
--]]
StartScene = inheritsFrom(BaseScene)

--------------------------------
function StartScene:init(sceneMan, params)
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});
	info_log("StartScene:init");

	-- create menu elements
	self:createMenuElements();

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "StartScene");
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
