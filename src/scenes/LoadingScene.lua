require "src/scenes/BaseScene"
require "src/base/Log"
require "src/gui/GuiHelper"

local LOADSCEENIMAGE = "Loading.png"
local TIME_SHOWING = 3.0

--[[
loading scene - loading screen
--]]
LoadingScene = inheritsFrom(BaseScene)
LoadingScene.mTimer = TIME_SHOWING;
LoadingScene.mProgress = nil;
LoadingScene.mTimeLabel = nil;
LoadingScene.PROGRESS_TAG = 31;
LoadingScene.LABEL_TAG = 32;
LoadingScene.PERCENT_IMAGE_TAG = 33;
LoadingScene.PROGRESS_PARENT_TAG = 30;

---------------------------------
function LoadingScene:destroy()
	self:superClass().destroy(self);
end

--------------------------------
function LoadingScene:loadScene()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("LoadingScene", reader, false);
    self.mSceneGame:addChild(node);

    local parent = node:getChildByTag(LoadingScene.PROGRESS_PARENT_TAG);
    local parentSize = CCDirector:getInstance():getVisibleSize();
    parent:setPositionX(parentSize.width / 2);
    self.mProgress = tolua.cast(parent:getChildByTag(LoadingScene.PROGRESS_TAG), "ccui.Scale9Sprite");
    self.mProgress:setScaleX(0);

    self.mTimeLabel = node:getChildByTag(LoadingScene.LABEL_TAG);
    self.mTimeLabel:setPositionX(parentSize.width / 2);
    setDefaultFont(self.mTimeLabel, self.mSceneManager.mGame:getScale());
    
    local percent_image = node:getChildByTag(LoadingScene.PERCENT_IMAGE_TAG);
    local labelSize = self.mTimeLabel:getContentSize();
    percent_image:setPositionX(parentSize.width / 2 + labelSize.width);
end

--------------------------------
function LoadingScene:init(sceneMan, params)
	self:superClass().init(self, sceneMan, {});
	info_log("LoadingScene:init");

    local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("LoadingScene");

    self:loadScene();
end

---------------------------------
function LoadingScene:tick(dt)
	self:superClass().tick(self, dt);
    self.mTimer = self.mTimer - dt;
    if self.mTimer <= 0 then
        self.mSceneManager:runNextScene();
    end
    local percent = ( TIME_SHOWING - self.mTimer) / TIME_SHOWING;
    self.mProgress:setScaleX(percent);

    local textLabel = tostring(math.floor(percent * 100 / 5) * 5);
    self.mTimeLabel:setString(textLabel.."%");
end
