require "src/scenes/BaseScene"
require "src/gui/Joystick"
require "src/game_objects/Field"
require "src/gui/FightButton"
require "src/gui/MainUI"
require "src/game_objects/PlayerController"
require "src/tutorial/TutorialManager"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/base/table"
require "src/scenes/EditorFileLoader"

local G_EditorScene = require "src/levels/editor_scene"

LevelScene = inheritsFrom(BaseScene)
LevelScene.mField = nil;
LevelScene.mLevel = nil;
LevelScene.mPlayerController = nil;

LevelScene.FIELD_NODE_TAG = 10;
LevelScene.mMainUI = nil;
LevelScene.mTutorial = nil;
LevelScene.mStoredLevel = nil;

local LOADSCEENIMAGE = "GlobalMap.png"


---------------------------------
function LevelScene:getLevel()
	return self.mLevel;
end

---------------------------------
function LevelScene:onStateLose()
	info_log("LevelScene: LOSE !!!");
	self.mMainUI:onStateLose();
	self:getGame():getSoundManager():playMusic(gSounds.GAME_OVER_MUSIC, false);

    local id = "Level_" .. self.mLevel:getData().id;
    local statistic = extend.Statistic:getInstance();

    statistic:sendTime(id, "lose", "time", (self.mLevel:getData().time - self.mField:getTimer()) * 1000);
    statistic:sendEvent(id, "finish", "lose", -1);
end

---------------------------------
function LevelScene:onBackPressed()
	info_log("LevelScene:onBackPressed !!! ", self.mField:getState());
    if self.mField:getState() == Field.IN_GAME then
        self.mMainUI:onSettingsButtonPressed(1, 1);
        return 1;
    else
        return 0;
    end
end

---------------------------------
function LevelScene:bonusFileStart(self_fake)
    debug_log("LevelScene:bonusFileStart ")
    local old_G_EditorScene = G_EditorScene
    G_EditorScene = self.mLevel:getData().BonusLevelFile
    self:bonusStart(self, self.mLevel:getData());
    G_EditorScene = old_G_EditorScene
end

---------------------------------
function LevelScene:bonusStart(self_fake, bonusData)

    info_log("LevelScene:bonusStart bonusData ");
    self:destroyLevelComponent();
    local data = bonusData and bonusData or self.mLevel:getData().bonusLevel;

--    data = data and data or self.mLevel:getData().BonusLevelFile;
    info_log("LevelScene:bonusStart ccbFile ", data.ccbFile);
    data.isBonus = true;

    self:initScene(data);
    self:initGui();
    self:postInitScene(data);
    if bonusData and bonusData.score then
        self.mField:setScore(bonusData.score);
    end
end

---------------------------------
function LevelScene:storeScene()
    self.mStoredLevel = {}
    self.mField:store(self.mStoredLevel);
end

---------------------------------
function LevelScene:restoreScene()
    self:destroyLevelComponent();
    self:initScene(self.mLevel:getData());
    self:initGui();
    self:postInitScene(self.mLevel:getData());

    self.mField:restore(self.mStoredLevel);
    self.mStoredLevel = nil;
end

---------------------------------
function LevelScene:bonusRoomStart()
    self:bonusStart(self, self.mLevel:getData().bonusRoom);
end

---------------------------------
function LevelScene:bonusRoomStartFromFile(self_fake, isFemale, bonusFile, score)
    debug_log("LevelScene:bonusRoomStartFromFile (", isFemale, ", ", bonusFile);
    local old_G_EditorScene = G_EditorScene
    G_EditorScene = bonusFile
    local copyData = table.copy(self.mLevel:getData())

    copyData.isFemale = isFemale;

    self:bonusStart(self, copyData)
    G_EditorScene = old_G_EditorScene
    self.mField:setScore(score);
end

---------------------------------
function LevelScene:loadBonusRoomFromFile(isFemale, bonusFile)
    local score = self.mField:getScore();
    if self.mStoredLevel == nil then
        self:storeScene();
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusRoomStartFromFile, isFemale, bonusFile, score), "ShortShow");
    end
end

---------------------------------
function LevelScene:onEnterBonusRoomDoor(isFemale, bonusFile)
    local score = self.mField:getScore();
    info_log("LevelScene:onEnterBonusRoomDoor score ", score);
    if self.mStoredLevel ~= nil then
        self.mStoredLevel.field.score = score;
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.restoreScene), "ShortShow");
    elseif bonusFile and bonusFile ~= "" then
        self:loadBonusRoomFromFile(isFemale, bonusFile)
    elseif self.mLevel:getData().bonusRoom then
        self.mLevel:getData().bonusRoom.isFemale = isFemale;
        self.mLevel:getData().bonusRoom.score = score;
        self:storeScene();
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusRoomStart), "ShortShow");
    end
end

---------------------------------
function LevelScene:onStateBonusStart()
    debug_log("LevelScene:onStateBonusStart ", self.mLevel:getData().BonusLevelFile);
    self:winOpenLevel();

    if self.mLevel:getData().BonusLevelFile then
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusFileStart));
    else
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusStart));
    end
end

---------------------------------
function LevelScene:winOpenLevel(stars)
    info_log("LevelScene: WIN !!!");
    local locationId = self.mLevel:getLocation():getId();
    info_log("LevelScene:winOpenLevel: locationId ", locationId);

    local newLevelIndex = self.mLevel:getIndex() + 1;
    local newLocationIndex = locationId;
    if newLevelIndex > #self.mLevel:getLocation():getLevels() then
        newLocationIndex = newLocationIndex + 1;
        newLevelIndex = 1;
    end

    if #self.mSceneManager.mGame:getLocations() >= newLocationIndex and newLocationIndex ~= locationId then
        self.mSceneManager.mGame:openLocation(newLocationIndex);
    end

    self.mSceneManager.mGame:openLevel(newLocationIndex, newLevelIndex);
    if stars then
        self.mSceneManager.mGame:setLevelStar(locationId, self.mLevel:getIndex(), stars.trapStar +
            stars.coinsStar + stars.timeStar);
    else
        self.mSceneManager.mGame:setLevelStar(locationId, self.mLevel:getIndex(), 2);
    end

    self:getGame():getSoundManager():playMusic(gSounds.VICTORY_MUSIC, false);
end

---------------------------------
function LevelScene:onStateWin(stars)
    self:winOpenLevel(stars);
    -- send star to statistic
    local statistic = extend.Statistic:getInstance();
    local id = "Level_" .. self.mLevel:getData().id;

    statistic:sendEvent(id, "stars", "trapStar", stars.trapStar);
    statistic:sendEvent(id, "stars", "timeStar", stars.timeStar);
    statistic:sendEvent(id, "stars", "coinsStar", stars.coinsStar);
    statistic:sendEvent(id, "stars", "allStar", stars.allStar);
    statistic:sendEvent(id, "finish", "win", -1);

    if self.mLevel:getData().time then
        statistic:sendTime(id, "win", "time", (self.mLevel:getData().time - self.mField:getTimer()) * 1000);
    end

	self.mMainUI:onStateWin(stars);
end

---------------------------------
function LevelScene:destroyLevelComponent()

    if self.mMainUI then
        self.mMainUI:destroy();
    end

    if self.mField then
        self.mField:destroy();
    end

    if self.mPlayerController then
        self.mPlayerController:destroy();
    end

end

---------------------------------
function LevelScene:destroy()
	info_log("LevelScene:destroy ");

    self:destroyLevelComponent();

	LevelScene:superClass().destroy(self);

    if self.mTutorial then
        self.mTutorial:destroy();
        self.mTutorial = nil;
    end

	self:getGame():getSoundManager():stopMusic(true);
end

--------------------------------
function LevelScene:postInitScene(levelData)
    info_log("LevelScene:postInitScene ", levelData.isFemale);
    if levelData.tutorial then
        self.mTutorial = TutorialManager:create();
        self.mTutorial:init(self.mSceneGame, self.mField, self.mMainUI, levelData.tutorial);
    end

    -- set joystick to players
    local players = self.mField:getPlayerObjects();
    info_log("LevelScene:postInitScene players ", players);
    if players then
        for i, player in ipairs(players) do
            player:setJoystick(self.mMainUI:getJoystick());
            player:setFightButton(self.mMainUI:getFightButton());
        end
        if levelData.isFemale ~= nil then
            players[1]:setCustomProperties({isFemale = levelData.isFemale});
        end
    end

	self.mPlayerController = PlayerController:create();
	self.mPlayerController:init(self.mGuiLayer:getBoundingBox(), self.mField:getPlayerObjects(), self.mField,
	self.mMainUI:getJoystick(), self.mMainUI:getFightButton());
	self.mMainUI:setTouchListener(self.mPlayerController);

    -- play music
    if levelData.backgroundMusic then
        self:getGame():getSoundManager():playMusic(self.mLevel:getData().backgroundMusic, true)
    end

    local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("LevelScene"..levelData.id);
end

--------------------------------
function LevelScene:init(sceneMan, params)
	info_log("LevelScene:init( ", sceneMan, ", ", params, ")");
	LevelScene:superClass().init(self, sceneMan, params);
	self.mLevel = params;

	self:initScene(self.mLevel:getData());

	self:initGui();

    self:postInitScene(self.mLevel:getData());
end

--------------------------------
function LevelScene:loadTileMap(tileMapName, levelData)

    local tileMap = cc.TMXTiledMap:create(tileMapName);
    local visibleSize = CCDirector:getInstance():getVisibleSize();
    if levelData.customTiledAnchor then
        tileMap:setAnchorPoint(levelData.customTiledAnchor);
    else
        tileMap:setAnchorPoint(cc.p(0.5, 0.0));
    end
    tileMap:setPosition(cc.p(visibleSize.width / 2.0 - levelData.cellSize * self.mSceneManager.mGame:getScale() / 2, 0));

    if self.mScrollView then
        self.mScrollView:addChild(tileMap);
    else
        self.mSceneGame:addChild(tileMap);
    end
end

--------------------------------
function LevelScene:initScene(levelData)

    -- try open file from editor
    if  EditorFileLoader:loadEditorFile(levelData, G_EditorScene, self) then
		levelData.tutorial = false;
        return;
    end

    debug_log("levelData.ccbFile ", levelData);
	if type(levelData.ccbFile) == "string" then
		local ccpproxy = CCBProxy:create();
		local reader = ccpproxy:createCCBReader();
		
		local node = ccpproxy:readCCBFromFile(levelData.ccbFile, reader, false);

        if levelData.tileMap then
            self:loadTileMap(levelData.tileMap, levelData);
        end

        self.mSceneGame:addChild(node);

		-- create field
		local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);

		self.mField = Field:create();
		self.mField:init({ fieldNode }, node, levelData, self.mSceneManager.mGame);
	elseif type(levelData.ccbFile) == "table" then
		local layers = {};
		local nodes = {};
		for i, fileName in ipairs(levelData.ccbFile) do
			local ccpproxy = CCBProxy:create();
			local reader = ccpproxy:createCCBReader();
			local node = ccpproxy:readCCBFromFile(fileName, reader, false);

            local anchor = node:getAnchorPoint();
            info_log("LevelScene:initScene anchor.x ", anchor.x, " anchor.y ", anchor.y);

			table.insert(layers, node);
			local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);
			table.insert(nodes, fieldNode);
			local layerSize = node:getContentSize();
			local fieldSize = fieldNode:getContentSize();
			node:setContentSize(cc.size(layerSize.width, fieldSize.height));
		end
		self.mScrollView = ScrollView:create();
		self.mScrollView:initLayers(layers);
		self.mScrollView:setTouchEnabled(false);

        if levelData.tileMap then
            self:loadTileMap(levelData.tileMap, levelData);
        end

		self.mSceneGame:addChild(self.mScrollView.mScroll);
		self.mField = Field:create();
		self.mField:init(nodes, self.mScrollView.mScroll, levelData, self.mSceneManager.mGame);
	end

	self.mField:setStateListener(self);
end

---------------------------------
function LevelScene:tick(dt)
	LevelScene:superClass().tick(self, dt);
	self.mField:tick(dt);

    if self.mPlayerController then
	   self.mPlayerController:tick(dt);
    end

	if self.mTutorial then
		self.mTutorial:tick(dt);
	end

	if self.mField:getTimer() then
		self.mMainUI:setTime(self.mField:getTimer());
	end

    self.mMainUI:setScore(self.mField:getScore());
    self.mMainUI:tick(dt);
end

--------------------------------
function LevelScene:initGui()
	self:createGuiLayer();

	self.mMainUI = MainUI:create();
	self.mMainUI:init(self.mSceneManager.mGame, self.mGuiLayer, "Level_UI_layer");

	if self.mField:getTimer() then
		self.mMainUI:setTimerEnabled(true);
        self.mMainUI:setTimerInitValue(self.mField:getTimer());
	end

    self.mField:setMainUi(self.mMainUI);
	self.mMainUI:show();
end
