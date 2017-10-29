require "src/scenes/SceneManager"
require "src/scenes/GameConfigs"
require "src/scenes/Location"
require "src/gui/DialogManager"
require "CCBReaderLoad"
require "src/base/Log"
require "src/LocalizationManager"
require "src/sound/SimpleAudioEngineAdapter"
require "src/sound/ExpAudioEngineAdapter"
require "src/sound/EmptyAudioEngineAdapter"

--[[
It is main class for game.
--]]
Game =  inheritsFrom(nil)
Game.mSceneMan = nil
Game.mDialogManager = nil
Game.mGameTime = 0
Game.mScale = 1
Game.mLocations = nil
Game.mLastVisitLocation = nil
Game.mLocalizationManager = nil
Game.mSoundManager = nil

local SUPPORTED_RESOLUTION = {
	{ size = cc.size(480, 320), scale = 1, searchPath = "resources-iphone"},
	{ size = cc.size(700, 350), scale = 2, searchPath = "resources-iphonehd"}, -- for android 480x800
	{ size = cc.size(960, 640), scale = 2, searchPath = "resources-iphonehd"},
	{ size = cc.size(1024, 768), scale = 2, searchPath = "resources-iphonehd"},
	{ size = cc.size(1024 * 2, 768 * 2), scale = 2, searchPath = "resources-iphonehd"}
}

local RESOURCE_DIRECTORIES = {
	"Published-iOS", "Maps"
}

local DESIGN_RESOLUTION_SIZE = cc.size(480, 320);

---------------------------------
function Game:getLocations()
	return self.mLocations;
end

---------------------------------
function Game:getLocation(idLocation)
    return self.mLocations[idLocation];
end

---------------------------------
function Game:tick(dt)
	--if not self.mDialogManager:hasModalDlg() then
		self.mGameTime = self.mGameTime + dt;
		self.mSceneMan:tick(dt);
		self.mDialogManager:tick(dt);
	--end
end

---------------------------------
function Game:onBackPressed()
    if not self.mSceneMan then
        return 0;
    end
    return self.mSceneMan:onBackPressed();
end

---------------------------------
function Game:createLocation()
	for i, location in ipairs(gLocations) do
		local locat = Location:create();
		locat:init(location, self);
		self.mLocations[location.id] = locat;
		info_log("location.id ", location.id);
	end
end

---------------------------------
function Game:getScale()
	return self.mScale;
end

---------------------------------
function Game:setLastVisitLocation(locationId)
	self.mLastVisitLocation = locationId;
end

---------------------------------
function Game:getLastVisitLocation()
	return self.mLastVisitLocation;
end

---------------------------------
function Game:isLevelOpened(locationId, level)
    return CCUserDefault:getInstance():getBoolForKey(tostring(locationId) .. tostring(level));
end

---------------------------------
function Game:openLevel(locationId, level)
	CCUserDefault:getInstance():setBoolForKey(tostring(locationId) .. tostring(level), true);
end

---------------------------------
function Game:openLocation(locationId)
    CCUserDefault:getInstance():setBoolForKey(tostring(locationId), true);
end

---------------------------------
function Game:isLocationOpened(locationId)
    return CCUserDefault:getInstance():getBoolForKey(tostring(locationId));
end

---------------------------------
function Game:getLevelStar(locationId, level)
	return self.mLocations[locationId].mLevels[level]:getCountStar();
end

---------------------------------
function Game:setLevelStar(locationId, level, star)
	local old_stars = self:getLevelStar(locationId, level); 
	if old_stars then
		star = math.max(star, old_stars);
	end
    self.mLocations[locationId]:getLevel(level):setCountStar(star);
	CCUserDefault:getInstance():setIntegerForKey(locationId .. tostring(level) .. "_star", star);
end

---------------------------------
function Game:setLevelStarShowed(locationId, level, count)
    CCUserDefault:getInstance():setIntegerForKey(locationId .. tostring(level).. "_showed_star", count);
end

---------------------------------
function Game:getLevelStarShowed(locationId, level)
    return CCUserDefault:getInstance():getIntegerForKey(locationId .. tostring(level).. "_showed_star");
end

---------------------------------
function Game:getLocationUnlockShowed(locationId)
	return CCUserDefault:getInstance():getBoolForKey(locationId .. "_showed_unlock");
end

---------------------------------
function Game:setLocationUnlockShowed(locationId, val)
	CCUserDefault:getInstance():setBoolForKey(locationId .. "_showed_unlock", val);
end

---------------------------------
function Game:getBonusUnlockShowed(locationId)
	return CCUserDefault:getInstance():getBoolForKey(locationId .. "_bonus__showed_unlock");
end

---------------------------------
function Game:setBonusUnlockShowed(locationId, val)
	CCUserDefault:getInstance():setBoolForKey(locationId .. "_bonus__showed_unlock", val);
end

---------------------------------
function Game:getLevelStar(locationId, level)
    return CCUserDefault:getInstance():getIntegerForKey(locationId .. tostring(level) .. "_star", 0);
end

---------------------------------
function Game:initResolution()
	-- compute resolution scale
	local visibleSize = CCDirector:getInstance():getVisibleSize();

    if visibleSize.width == 0 or visibleSize.height == 0 then
        -- create desktop gl view
        local glview = cc.GLViewImpl:createWithRect("Desktop", cc.rect(0, 0, 960, 640));
        info_log("Game:initResolution glview ", glview);
        CCDirector:getInstance():setOpenGLView(glview);
        visibleSize = CCDirector:getInstance():getVisibleSize();
    end
    info_log("Game:initResolution width ", visibleSize.width);
    info_log("Game:initResolution height ", visibleSize.height);

    -- if width > 
    if visibleSize.width < visibleSize.height then
    	local tmp = visibleSize.width;
    	visibleSize.width = visibleSize.height;
    	visibleSize.height = tmp;

    	--CCDirector:getInstance():getOpenGLView().setFrameSize(visibleSize.width, visibleSize.height);
    end

	local resolutionInfo = nil;
	for i = #SUPPORTED_RESOLUTION, 1, -1  do
		if visibleSize.width >= SUPPORTED_RESOLUTION[i].size.width and visibleSize.height >= SUPPORTED_RESOLUTION[i].size.height then
			info_log("resolution x ", SUPPORTED_RESOLUTION[i].size.width);
			info_log("resolution y ", SUPPORTED_RESOLUTION[i].size.height);
			resolutionInfo = SUPPORTED_RESOLUTION[i];
			break;
		end
	end

	if resolutionInfo then 
		--CCDirector:getInstance():getOpenGLView():setDesignResolutionSize(resolutionInfo.size.width, resolutionInfo.size.height, 1);
		local scale = math.min(visibleSize.width / DESIGN_RESOLUTION_SIZE.width, visibleSize.height / DESIGN_RESOLUTION_SIZE.height);
		info_log("SCALE ", scale);
		self.mScale = scale;
        info_log("CCBReader ", cc.CCBReader);

		cc.CCBReader:setResolutionScale(scale);
		CCDirector:getInstance():setContentScaleFactor( (1 / scale) * resolutionInfo.scale);
		local fileUtils = CCFileUtils:getInstance();
		-- add resource directories
		for i, val in ipairs(RESOURCE_DIRECTORIES) do
			fileUtils:addSearchPath("res");
			fileUtils:addSearchPath("res/"..val);
			fileUtils:addSearchPath("res/"..val.."/"..resolutionInfo.searchPath);
		end
	end
end

---------------------------------
function Game:setSoundEnabled(enabled)
    info_log("Game:setSoundEnabled ", enabled);
    local value = enabled and 1 or 0;
	CCUserDefault:getInstance():setIntegerForKey("SoundValue", value);
    self.mSoundManager:setEffectsVolume(value);
end

---------------------------------
function Game:getSoundEnabled()
    local soundVolume = CCUserDefault:getInstance():getIntegerForKey("SoundValue", 1);
    info_log("soundVolume ", soundVolume);
    return soundVolume ~= 0;
end

---------------------------------
function Game:setMusicEnabled(enabled)
    info_log("Game:setMusicEnabled ", enabled);
    local value = enabled and 1 or 0;
	CCUserDefault:getInstance():setIntegerForKey("MusicValue", value);
    self.mSoundManager:setMusicVolume(value);
end

---------------------------------
function Game:getMusicEnabled()
    local musicVolume = CCUserDefault:getInstance():getIntegerForKey("MusicValue", 1);
    info_log("Game:getMusicEnabled musicVolume ", musicVolume);
    return musicVolume ~= 0;
end

---------------------------------
function Game:setConfiguration()
    self:setMusicEnabled(self:getMusicEnabled())
    self:setSoundEnabled(self:getSoundEnabled());
end

---------------------------------
function Game:getLocalizationManager()
	return self.mLocalizationManager
end

---------------------------------
function Game:getSoundManager()
	return self.mSoundManager;
end

---------------------------------
function Game:init()

	self.mLocations = {}

	CCUserDefault:getInstance();
	local xmlFilePath = CCUserDefault:getXMLFilePath();
	info_log("Game:init xmlFilePath ", xmlFilePath);

	self:initResolution();

	self.mLocalizationManager = LocalizationManager:create()
	self.mLocalizationManager:init()

	self.mSoundManager = SimpleAudioEngineAdapter:create()-- EmptyAudioEngineAdapter:create()--SimpleAudioEngineAdapter:create();--ExpAudioEngineAdapter:create();
	self.mSoundManager:init();

    -- set game configuration
    self:setConfiguration();

	-- create locations
	self:createLocation();

	-- create scene manager
	self.mSceneMan = SceneManager:create();
	self.mSceneMan:init(self);

	-- create gui manager
	self.mDialogManager = DialogManager:create();
	self.mDialogManager:init();

	local g_game = self;
	
	function tick(dt)
		g_game:tick(dt);
	end

	CCDirector:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

end
