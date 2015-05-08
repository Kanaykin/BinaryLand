require "src/scenes/BaseScene"
require "src/gui/ScrollView"
require "src/base/AlignmentHelper"
require "src/scenes/GameConfigs"
require "src/scenes/SoundConfigs"
require "src/base/Log"

local LOADSCEENIMAGE = "choseLevel.png"

--[[
start scene - loading screen
]]
ChooseLocation = inheritsFrom(BaseScene)
ChooseLocation.mScrollView = nil;

--------------------------------
function ChooseLocation:createLocationImages()
	local locations = self.mSceneManager.mGame:getLocations();
	for i, location in pairs(locations) do
        local menuToolsItem = CCMenuItemImage:create(location:getImage(), location:getImage());

        local function onLocationPressed()
            info_log("onLocationPressed");
            menuToolsItem:unregisterScriptTapHandler();
            location:onLocationPressed();
        end

        menuToolsItem:registerScriptTapHandler(onLocationPressed);

        local menuTools = cc.Menu:createWithItem(menuToolsItem);

        self.mScrollView:addChild(menuTools);

        menuTools:setPosition(getPosition(menuTools, location:getPosition()));

        --[[local locationImage = CCSprite:create(location:getImage());
		--self.mScrollView:addClickableChild(locationImage, location, "onLocationPressed");
		--setPosition(locationImage, location:getPosition());
		]]
		-- if location is locked
		if not location:isOpened() then
			local lock = CCSprite:create("lock.png");
			menuToolsItem:addChild(lock);
			setPosition(lock, Coord(0.5, 0.5, 0, 0));
			lock:setScaleX(2);
			lock:setScaleY(2);
		end
	end
end

---------------------------------
function ChooseLocation:destroy()
	ChooseLocation:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
end

--------------------------------
function ChooseLocation:initScene()
	self.mScrollView = ScrollView:create();
	self.mScrollView:init(cc.size(2.5, 1), {LOADSCEENIMAGE, LOADSCEENIMAGE, LOADSCEENIMAGE, LOADSCEENIMAGE});
	self.mScrollView:setClickable(true);
	self.mSceneGame:addChild(self.mScrollView.mScroll);

	self:createLocationImages();

	--parallax
	local parallax = CCParallaxNode:create();
	self.mScrollView:addChild(parallax);

	local count = 5;
	local delta = 2 / (count + 1);
	local position = 0;
	for i=1,count do
		-- grass images
		local pos = Coord(position, 0, 50, 50);
		local grass = CCSprite:create("grass.png");
		parallax:addChild(grass, 1, cc.p(0.4, 1.0), getPosition(grass, pos));
		-- cloud images
		local posCloud = Coord(position, 0.8, 50, 50);
		local cloud = CCSprite:create("cloud1.png");
		parallax:addChild(cloud, 1, cc.p(0.4, 1.0), getPosition(cloud, posCloud));
		position = position + delta;
	end

end

--------------------------------
function ChooseLocation:initGui()
	local visibleSize = CCDirector:getInstance():getVisibleSize();
    
    self:createGuiLayer();

	-- play button
	local menuToolsItem = CCMenuItemImage:create("back_normal.png", "back_pressed.png");
    menuToolsItem:setPosition(- visibleSize.width / 3, - visibleSize.height / 3);

    local choseLevel = self;

    local function onReturnPressed()
    	info_log("onReturnPressed");
    	choseLevel.mSceneManager:runPrevScene();
    end

    menuToolsItem:registerScriptTapHandler(onReturnPressed);

    local menuTools = cc.Menu:createWithItem(menuToolsItem);
    
    self.mGuiLayer:addChild(menuTools);
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
