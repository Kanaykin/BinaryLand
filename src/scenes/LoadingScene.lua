require "src/scenes/BaseScene"

local LOADSCEENIMAGE = "Loading.png"
local TIME_SHOWING = 3.0
--[[
loading scene - loading screen
--]]
LoadingScene = inheritsFrom(BaseScene)
LoadingScene.mTimer = TIME_SHOWING;

---------------------------------
function LoadingScene:destroy()
	self:superClass().destroy(self);
end

--------------------------------
function LoadingScene:init(sceneMan, params)
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});
	print("LoadingScene:init");

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "LoadingScene");
end

---------------------------------
function LoadingScene:tick(dt)
	self:superClass().tick(self, dt);
    self.mTimer = self.mTimer - dt;
    if self.mTimer <= 0 then
        self.mSceneManager:runNextScene();
    end
end
