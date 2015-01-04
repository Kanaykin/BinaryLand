require "src/scenes/BaseScene"
require "src/gui/Joystick"
require "src/game_objects/Field"
require "src/gui/FightButton"
require "src/gui/MainUI"
require "src/game_objects/PlayerController"
require "src/tutorial/TutorialManager"
require "src/scenes/SoundConfigs"

LevelScene = inheritsFrom(BaseScene)
LevelScene.mField = nil;
LevelScene.mLevel = nil;
LevelScene.mPlayerController = nil;

LevelScene.FIELD_NODE_TAG = 10;
LevelScene.mMainUI = nil;
LevelScene.mTutorial = nil;

local LOADSCEENIMAGE = "choseLevel.png"


---------------------------------
function LevelScene:getLevel()
	return self.mLevel;
end

---------------------------------
function LevelScene:onStateLose()
	print("LevelScene: LOSE !!!");
	self.mMainUI:onStateLose();
	SimpleAudioEngine:getInstance():playMusic(gSounds.GAME_OVER_MUSIC, false)
end

---------------------------------
function LevelScene:onStateWin()
	print("LevelScene: WIN !!!");
	local locationId = self.mLevel:getLocation():getId();

	-- TODO: open location

	self.mSceneManager.mGame:openLevel(locationId, self.mLevel:getIndex() + 1);
	self.mMainUI:onStateWin();

	SimpleAudioEngine:getInstance():playMusic(gSounds.VICTORY_MUSIC, false)
	--SimpleAudioEngine:getInstance():playEffect(gSounds.VICTORY_MUSIC)
end

---------------------------------
function LevelScene:destroy()
	print("LevelScene:destroy ");

	if self.mMainUI then
		self.mMainUI:destroy();
	end

	if self.mField then
		self.mField:destroy();
	end

	self.mPlayerController:destroy();

	LevelScene:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
end

--------------------------------
function LevelScene:init(sceneMan, params)
	print("LevelScene:init( ", sceneMan, ", ", params, ")");
	LevelScene:superClass().init(self, sceneMan, params);
	self.mLevel = params;

	self:initScene();

	self:initGui();

	-- set joystick to players
	local players = self.mField:getPlayerObjects();
	if players then
		for i, player in ipairs(players) do
			player:setJoystick(self.mMainUI:getJoystick());
			player:setFightButton(self.mMainUI:getFightButton());
		end
	end

	self.mPlayerController = PlayerController:create();
	self.mPlayerController:init(self.mGuiLayer:getBoundingBox(), self.mField:getPlayerObjects(), self.mField,
		self.mMainUI:getJoystick(), self.mMainUI:getFightButton());
	self.mMainUI:setTouchListener(self.mPlayerController);

	if self.mLevel:getData().tutorial then
		self.mTutorial = TutorialManager:create();
		self.mTutorial:init(self.mSceneGame, self.mField, self.mMainUI);
	end

	-- play music
	if self.mLevel:getData().backgroundMusic then
		SimpleAudioEngine:getInstance():playMusic(self.mLevel:getData().backgroundMusic, true)
	end

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "LevelScene"..self.mLevel:getData().id);
end

--------------------------------
function LevelScene:initScene()

    local tileMap = nil;
	if self.mLevel:getData().tileMap then
		tileMap = cc.TMXTiledMap:create(self.mLevel:getData().tileMap);
        local visibleSize = CCDirector:getInstance():getVisibleSize();
        tileMap:setAnchorPoint(cc.p(0.5, 0.0));
        tileMap:setPosition(cc.p(visibleSize.width / 2.0, 0));
	end

	if type(self.mLevel:getData().ccbFile) == "string" then
		local ccpproxy = CCBProxy:create();
		local reader = ccpproxy:createCCBReader();
		
		local node = ccpproxy:readCCBFromFile(self.mLevel:getData().ccbFile, reader, false);

        if tileMap then
            self.mSceneGame:addChild(tileMap);
        end
		self.mSceneGame:addChild(node);

		-- create field
		local fieldNode = node:getChildByTag(LevelScene.FIELD_NODE_TAG);

		self.mField = Field:create();
		self.mField:init({ fieldNode }, node, self.mLevel:getData(), self.mSceneManager.mGame);
	elseif type(self.mLevel:getData().ccbFile) == "table" then
		local layers = {};
		local nodes = {};
		for i, fileName in ipairs(self.mLevel:getData().ccbFile) do
			local ccpproxy = CCBProxy:create();
			local reader = ccpproxy:createCCBReader();
			local node = ccpproxy:readCCBFromFile(fileName, reader, false);
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

        if tileMap then
            self.mScrollView:addChild(tileMap);
        end
		
		self.mSceneGame:addChild(self.mScrollView.mScroll);
		self.mField = Field:create();
		self.mField:init(nodes, self.mScrollView.mScroll, self.mLevel:getData(), self.mSceneManager.mGame);
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

	self.mMainUI:show();
end
