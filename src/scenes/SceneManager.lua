require "src/scenes/BaseScene"
require "src/scenes/LoadingScene"
require "src/scenes/StartScene"
require "src/scenes/EndScene"
require "src/scenes/CreditsScene"
require "src/scenes/ChooseLocation"
require "src/scenes/ChooseLevel"
require "src/scenes/LevelScene"
require "src/base/Log"

--[[
It is class for controlling of scenes.
The game contain three base scenes: start, choosing level and level
--]]
SceneManager =  inheritsFrom(nil)
SceneManager.mScenes = {};
SceneManager.mCurrentSceneId = nil; -- current scene
SceneManager.mGame = nil;

SCENE_TYPE_ID = {
	LOADING_SCENE = 0;
	START_SCENE = 1;
	CHOOSE_LOCATION = 2;
	CHOOSE_LEVEL = 3;
	LEVEL = 4;
	END_SCENE = 5;
	CREDITS_SCENE = 6;
};

---------------------------------
function SceneManager:getCurrentScene()
	return self.mScenes[self.mCurrentSceneId];
end

---------------------------------
function SceneManager:onBackPressed()
    if self:getCurrentScene() ~= nil then
        return self:getCurrentScene():onBackPressed();
    end
    return 0;
end

---------------------------------
function SceneManager:runPrevScene(params)
	self:destroyCurrentScene();
	
	self.mCurrentSceneId = self.mCurrentSceneId - 1;
	if self.mCurrentSceneId <= 0 then
		self.mCurrentSceneId = 0;
	end

	self:getCurrentScene():init(self, params);
	CCDirector:getInstance():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:destroyCurrentScene()
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():destroy();
		CCDirector:getInstance():popScene();
	end
end

---------------------------------
function SceneManager:runScene(index, params)
	self.mCurrentSceneId = index;
	info_log("mCurrentSceneId ", self.mCurrentSceneId);
	self:getCurrentScene():init(self, params);
	CCDirector:getInstance():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:runNextScene(params, nextIndex)
	local index = 0;
	if nextIndex then
		index = nextIndex;
	else 
		index = self.mCurrentSceneId and self.mCurrentSceneId + 1 or 0;
	end

	info_log("SceneManager:runNextScene index ", index);
	if index == SCENE_TYPE_ID.CHOOSE_LOCATION then
		local locationId = 1;
		local isLevelOpened = self.mGame:isLevelOpened(locationId, 1);
		info_log("First start is level opened ", isLevelOpened);
		if not isLevelOpened then
			self.mGame:openLevel(locationId, 1);
			-- run tutorial
			--local locations = self.mGame:getLocations();
			--self:runLevelScene(locations[locationId]:getLevels()[1]);
			--return;
		end
	end

	self:destroyCurrentScene();
	self:runScene(index, params);
end

---------------------------------
function SceneManager:replayScene()
	info_log("SceneManager:replayScene");
	self:runLevelScene(self:getCurrentScene():getLevel());
end

---------------------------------
function SceneManager:runNextLevelScene()
	local level = self:getCurrentScene():getLevel();
	local locationId = level:getLocation():getId();
	local location = level:getLocation();
    local countLevels = #location:getLevels();

    -- TODO: open location
	local index = level:getIndex() + 1;
	local bonusLevel = location:getBonusLevel();
	
	local locations = self.mGame:getLocations();
	local level = locations[locationId]:getLevels()[index];
	
	if countLevels < index then
		-- open bonus level
		if bonusLevel and not bonusLevel:isOpened() then
			info_log("SceneManager:runNextLevelScene open bonus level ");
			self.mGame:openLevel(location:getId(), bonusLevel:getIndex());
		end
		index = 1;
        locationId = locationId + 1;
        if not locations[locationId] then
        	info_log("SceneManager:runNextLevelScene all location completed ");
            --locationId = 1;
            self:runNextScene(nil, SCENE_TYPE_ID.END_SCENE);
            return;
        end
        -- if last level on location run location scene
        -- if locations[locationId]:isLocked() then
        local params = nil;
        if locations[locationId]:isLocked() then
        	params = {locationLocked = locationId};
        end
        self:runNextScene(params, SCENE_TYPE_ID.CHOOSE_LOCATION);
        return;
    --     end
    --     level = locations[locationId]:getLevels()[index];
    end

	self:runLevelScene(level);
end

---------------------------------
function SceneManager:runLevelScene(params)
	self:destroyCurrentScene();
	self.mScenes[SCENE_TYPE_ID.LEVEL] = LevelScene:create();

	self.mCurrentSceneId = SCENE_TYPE_ID.LEVEL;
	self:getCurrentScene():init(self, params);
	CCDirector:getInstance():pushScene(self:getCurrentScene().mSceneGame);
end

---------------------------------
function SceneManager:tick(dt)
	if self:getCurrentScene() ~= nil then
		self:getCurrentScene():tick(dt);
	end
end

---------------------------------
function SceneManager:init(game)
	self.mGame = game;

	-- add fake scene
	local fakeScene = CCScene:create();
	CCDirector:getInstance():pushScene(fakeScene);

	-- loading scene initialize
	self.mScenes[SCENE_TYPE_ID.LOADING_SCENE] = LoadingScene:create();
	
	-- start scene initialize
	self.mScenes[SCENE_TYPE_ID.START_SCENE] = StartScene:create();
	
	-- choice location scene initialize
	self.mScenes[SCENE_TYPE_ID.CHOOSE_LOCATION] = ChooseLocation:create();

	-- choice level scene initialize
	self.mScenes[SCENE_TYPE_ID.CHOOSE_LEVEL] = ChooseLevel:create();

	-- end scene initialize
	self.mScenes[SCENE_TYPE_ID.END_SCENE] = EndScene:create();

	-- credits scene initialize
	self.mScenes[SCENE_TYPE_ID.CREDITS_SCENE] = CreditsScene:create();

	
	self:runNextScene();
end

