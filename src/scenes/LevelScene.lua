require "src/scenes/BaseScene"
require "src/gui/Joystick"
require "src/game_objects/Field"
require "src/gui/FightButton"
require "src/gui/MainUI"
require "src/game_objects/PlayerController"
require "src/tutorial/TutorialManager"
require "src/scenes/SoundConfigs"
require "src/base/Log"
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
	SimpleAudioEngine:getInstance():playMusic(gSounds.GAME_OVER_MUSIC, false)
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
function LevelScene:bonusStart(self_fake, bonusData)
    info_log("LevelScene:bonusStart bonusData ", bonusData);
    self:destroyLevelComponent();
    local data = bonusData and bonusData or self.mLevel:getData().bonusLevel;
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
function LevelScene:onEnterBonusRoomDoor(isFemale)
    local score = self.mField:getScore();
    info_log("LevelScene:onEnterBonusRoomDoor score ", score);
    if self.mStoredLevel == nil then
        self.mLevel:getData().bonusRoom.isFemale = isFemale;
        self.mLevel:getData().bonusRoom.score = score;
        self:storeScene();
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusRoomStart), "ShortShow");
    else
        self.mStoredLevel.field.score = score;
        self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.restoreScene), "ShortShow");
    end
end

---------------------------------
function LevelScene:onStateBonusStart()
    self:winOpenLevel();
    self.mMainUI:onStateBonusStart(Callback.new(self, LevelScene.bonusStart));
end

---------------------------------
function LevelScene:winOpenLevel()
    info_log("LevelScene: WIN !!!");
    local locationId = self.mLevel:getLocation():getId();
    info_log("LevelScene:winOpenLevel: locationId ", locationId);

    -- TODO: open location
    if #self.mSceneManager.mGame:getLocations() >= (locationId + 1) then
        self.mSceneManager.mGame:openLocation(locationId + 1);
    end

    self.mSceneManager.mGame:openLevel(locationId, self.mLevel:getIndex() + 1);
    self.mSceneManager.mGame:setLevelStar(locationId, self.mLevel:getIndex(), 2);

    SimpleAudioEngine:getInstance():playMusic(gSounds.VICTORY_MUSIC, false)
    --SimpleAudioEngine:getInstance():playEffect(gSounds.VICTORY_MUSIC)
end

---------------------------------
function LevelScene:onStateWin()
    self:winOpenLevel();
	self.mMainUI:onStateWin();
end

---------------------------------
function LevelScene:destroyLevelComponent()

    if self.mMainUI then
        self.mMainUI:destroy();
    end

    if self.mField then
        self.mField:destroy();
    end

    self.mPlayerController:destroy();

end

---------------------------------
function LevelScene:destroy()
	info_log("LevelScene:destroy ");

    self:destroyLevelComponent();

	LevelScene:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
end

--------------------------------
function LevelScene:postInitScene(levelData)
    info_log("LevelScene:postInitScene ", levelData);
    if levelData.tutorial then
        self.mTutorial = TutorialManager:create();
        self.mTutorial:init(self.mSceneGame, self.mField, self.mMainUI);
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
        SimpleAudioEngine:getInstance():playMusic(self.mLevel:getData().backgroundMusic, true)
    end

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "LevelScene"..levelData.id);
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
function LevelScene:loadTileMap(tileMapName)

    local tileMap = cc.TMXTiledMap:create(tileMapName);
    local visibleSize = CCDirector:getInstance():getVisibleSize();
    tileMap:setAnchorPoint(cc.p(0.5, 0.0));
    tileMap:setPosition(cc.p(visibleSize.width / 2.0, 0));

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
        return;
    end

	if type(levelData.ccbFile) == "string" then
		local ccpproxy = CCBProxy:create();
		local reader = ccpproxy:createCCBReader();
		
		local node = ccpproxy:readCCBFromFile(levelData.ccbFile, reader, false);

        if levelData.tileMap then
            self:loadTileMap(levelData.tileMap);
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
            self:loadTileMap(levelData.tileMap);
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
	self.mPlayerController:tick(dt);

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
