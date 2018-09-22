require "src/scenes/BaseScene"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/gui/SettingsDlgLvl"
require "src/gui/BuyCoffeeDlg"

ChooseLevel = inheritsFrom(BaseScene)
ChooseLevel.mCurLocation = nil;
ChooseLevel.mSettingsDlg = nil;

ChooseLevel.BACK_MENU_TAG = 10;
ChooseLevel.BACK_MENU_ITEM_TAG = 11;
ChooseLevel.BASE_NODE_TAG = 1;
ChooseLevel.COUNT_ENTER_SCENE_BUY_COFFEE = 3;

local LOADSCEENIMAGE = "GlobalMap.png"

--------------------------------
function ChooseLevel:getCurLocation()
	return self.mCurLocation;
end

--------------------------------
function ChooseLevel:init(sceneMan, params)
	info_log("ChooseLevel:init ", params.location:getId());
	self.mCurLocation = params.location;
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});

	self:initScene();

	self:initGui();

    --self:getGame():getSoundManager():playMusic(gSounds.CHOOSE_LEVEL_MUSIC, true);

    local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("ChooseLevel");
end

---------------------------------
function ChooseLevel:destroy()
	ChooseLevel:superClass().destroy(self);

	self:getGame():getSoundManager():stopMusic(true);
    self.mSettingsDlg:destroy();
end

--------------------------------
function ChooseLevel:initScene()
    local nameTileMap = self.mCurLocation:getId() <= 5 and "ChoiceLevels" ..self.mCurLocation:getId().. ".tmx" or "ChoiceLevels1.tmx";
    local tileMap = cc.TMXTiledMap:create(nameTileMap);
    local visibleSize = cc.Director:getInstance():getVisibleSize();
    tileMap:setAnchorPoint(cc.p(0.5, 0.5));
    tileMap:setPosition(cc.p(visibleSize.width / 2.0, visibleSize.height / 2.0));

	local ccpproxy = cc.CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
    local nameCCBFile = self.mCurLocation:getId() <= 5 and "MainScene" ..self.mCurLocation:getId() or "MainScene1";
	local node = ccpproxy:readCCBFromFile(nameCCBFile, reader, false);

    if tileMap then
        self.mSceneGame:addChild(tileMap);
    end
    self.mSceneGame:addChild(node);

    self:initChooseLevelButton(node);
    node = node:getChildByTag(ChooseLevel.BASE_NODE_TAG);

	local animator = reader:getActionManager();
    animator:retain();

	local arrayAnimator = reader:getAnimationManagersForNodes();
    info_log("ChooseLevel:initScene arrayAnimator ", arrayAnimator );

    table.sort(arrayAnimator, function(a, b)
		local animManagerA = tolua.cast(a, "cc.CCBAnimationManager");
		local animManagerB = tolua.cast(b, "cc.CCBAnimationManager");
        --info_log("animManager:getRootNode() ", animManagerA:getRootNode():getTag());
        --info_log("animManager:getRootNode() ", animManagerB:getRootNode():getTag());

        return animManagerA:getRootNode():getTag() < animManagerB:getRootNode():getTag();
    end)

    local minCount = (#arrayAnimator < #self.mCurLocation.mLevels) and #arrayAnimator or #self.mCurLocation.mLevels;

    local frameIndex = 1;
	for i = 1, minCount do
		local animManager = tolua.cast(arrayAnimator[i + 1], "cc.CCBAnimationManager");

        local showedCountStar = self.mSceneManager.mGame:getLevelStarShowed(self.mCurLocation:getId(), self.mCurLocation.mLevels[i]:getIndex());
        local countStar = self.mCurLocation.mLevels[i]:getCountStar();
        local need_showed = countStar - showedCountStar;
        debug_log("ChooseLevel: showed !!!! ", need_showed );
        self.mSceneManager.mGame:setLevelStarShowed(self.mCurLocation:getId(), 
            self.mCurLocation.mLevels[i]:getIndex(),
            countStar);

        --info_log("animManager:getRootNode() ", animManager:getRootNode():getTag());
        local nameFrame = "0:frame"..frameIndex;
        if need_showed > 0 then
            frameIndex = frameIndex + 1;
        end

        local child = node:getChildByTag(i);
		self.mCurLocation.mLevels[i]:initVisual(animator, animManager, nameFrame, child, need_showed);
	end

	animator:runAnimationsForSequenceNamed("Default Timeline");

end

---------------------------------
function ChooseLevel:showBuyCoffeeIfNeed()
    -- если покупка была ничего не показываем

    local key = "CountShowChooseLevelScene";
    local count = cc.UserDefault:getInstance():getIntegerForKey(key, 0);
    count = count + 1;
    cc.UserDefault:getInstance():setIntegerForKey(key, count);
    
    if count % ChooseLevel.COUNT_ENTER_SCENE_BUY_COFFEE == 0 then
        self.mSettingsDlg:openBuyCoffeeDlg();
    end
end

---------------------------------
function ChooseLevel:tick(dt)
    for i, level in pairs(self.mCurLocation.mLevels) do
        level:tick(dt);
    end
	self.mSettingsDlg:tick(dt)
end

--------------------------------
function ChooseLevel:initChooseLevelButton(nodeBase)
    local function onReturnPressed(val, val2)
        info_log("onReturnPressed");
        --self.mSceneManager:runPrevScene();
        self.mSettingsDlg:doModal();
    end

    setMenuCallback(nodeBase, ChooseLevel.BACK_MENU_TAG, ChooseLevel.BACK_MENU_ITEM_TAG, onReturnPressed);
end

--------------------------------
function ChooseLevel:initGui()
	local visibleSize = cc.Director:getInstance():getVisibleSize();
    
    self:createGuiLayer();

    -------------------------
    self.mSettingsDlg = SettingsDlgLvl:create();
    self.mSettingsDlg:init(self.mSceneManager.mGame, self.mGuiLayer);

    self:showBuyCoffeeIfNeed();
end
