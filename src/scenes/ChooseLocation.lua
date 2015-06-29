require "src/scenes/BaseScene"
require "src/gui/ScrollView"
require "src/base/AlignmentHelper"
require "src/scenes/GameConfigs"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/gui/GuiHelper"

local LOADSCEENIMAGE = "GlobalMapBack.png"
local GLOBALMAP = "GlobalMap.png"

--[[
start scene - loading screen
]]
ChooseLocation = inheritsFrom(BaseScene)
ChooseLocation.mScrollView = nil;
ChooseLocation.LABEL_BEGIN = 1;
ChooseLocation.LABEL_ENG = 5;

ChooseLocation.LOCATION_BEGIN = 10;
ChooseLocation.LOCATION_FOX_FREE_DELTA = 5;
ChooseLocation.LOCATION_SPRITE_BEGIN = 100;

ChooseLocation.BACK_MENU = 7;
ChooseLocation.BACK_MENU_ITEM = 8;

--------------------------------
function ChooseLocation:createLocationImages(node)
    info_log("ChooseLocation:createLocationImages node ", node);

    local locations = self.mSceneManager.mGame:getLocations();
    local locationNum = 1;

	for i, location in ipairs(locations) do
        local function onLocationPressed()
            info_log("onLocationPressed");
            --menuToolsItem:unregisterScriptTapHandler();
            location:onLocationPressed();
        end

        local sprite = node:getChildByTag(ChooseLocation.LOCATION_SPRITE_BEGIN * locationNum);
        info_log("ChooseLocation:createLocationImages location ID ", location:getId(), " isOpened ", location:isOpened());
        -- TODO: check all opened
        if #locations >= (i + 1) then
            info_log("ChooseLocation:createLocationImages next opened ", locations[i + 1]:isOpened());
            if locations[i + 1]:isOpened() then
                local foxInTrap = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * locationNum);
                foxInTrap:setVisible(false);

                local foxFree = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * locationNum + ChooseLocation.LOCATION_FOX_FREE_DELTA);
                foxFree:setVisible(true);

                setMenuCallback(sprite, ChooseLocation.LOCATION_BEGIN * locationNum + ChooseLocation.LOCATION_FOX_FREE_DELTA,
                    ChooseLocation.LOCATION_BEGIN * locationNum + ChooseLocation.LOCATION_FOX_FREE_DELTA + 1, onLocationPressed);
            end
        end

        setMenuCallback(sprite, ChooseLocation.LOCATION_BEGIN * locationNum , ChooseLocation.LOCATION_BEGIN * locationNum + 1, onLocationPressed);

		-- if location is locked
		if not location:isOpened() then
            sprite:setVisible(false);
		end

        locationNum = locationNum + 1;
	end
end

---------------------------------
function ChooseLocation:destroy()
	ChooseLocation:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
end

--------------------------------
function ChooseLocation:initScene()

    local globalMap = CCSprite:create(GLOBALMAP);
    local imageMapSize = globalMap:getContentSize();
    local visibleSize = CCDirector:getInstance():getVisibleSize();

	self.mScrollView = ScrollView:create();
	self.mScrollView:init(cc.size(imageMapSize.width / visibleSize.width, 1), {});
	self.mScrollView:setClickable(true);
	self.mSceneGame:addChild(self.mScrollView.mScroll);

	--parallax
	local parallax = CCParallaxNode:create();
	self.mScrollView:addChild(parallax);

	local pos = Coord(0.8, 0.5, 0, 0);
	local grass = CCSprite:create(LOADSCEENIMAGE);

    local imageSize = grass:getContentSize();
    local scale = visibleSize.height / imageSize.height;
    grass:setScaleY(scale);
    grass:setScaleX(scale);

	parallax:addChild(grass, 1, cc.p(0.4, 1.0), getPosition(grass, pos));

    globalMap:setAnchorPoint(cc.p(0, 0));
    self.mScrollView:addChild(globalMap);

    self:createLocations();
end

--------------------------------
function ChooseLocation:createLocations()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("ChooseLocation", reader, false);
    self.mScrollView:addChild(node);

    self:updateLabels(node);
    self:createLocationImages(node);
end

--------------------------------
function ChooseLocation:updateLabels(node)
    for i = ChooseLocation.LABEL_BEGIN, ChooseLocation.LABEL_ENG, 1 do
        local label = tolua.cast(node:getChildByTag(i), "cc.Label");
        info_log("ChooseLocation:updateLabels label ", label);

        if label then
            setDefaultFont(label, self.mSceneManager.mGame:getScale());
        end
    end
end

--------------------------------
function ChooseLocation:initGui()
    self:createGuiLayer();

    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("ChooseLocationUI", reader, false);
    self.mGuiLayer:addChild(node);

    local choseLevel = self;

    local function onReturnPressed()
    	info_log("onReturnPressed");
    	choseLevel.mSceneManager:runPrevScene();
    end

    setMenuCallback(node, ChooseLocation.BACK_MENU, ChooseLocation.BACK_MENU_ITEM, onReturnPressed);
end

--------------------------------
function ChooseLocation:init(sceneMan, params)
	info_log("ChooseLocation:init ");
	self:superClass().init(self, sceneMan, params);

	-- init scene
	self:initScene();

	-- init gui
	self:initGui();

	SimpleAudioEngine:getInstance():playMusic(gSounds.CHOOSE_LOCATION_MUSIC, true)

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "ChooseLocation");
end
