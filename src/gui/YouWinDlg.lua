require "src/gui/CCBBaseDlg"
require "src/base/Log"

YouWinDlg = inheritsFrom(CCBBaseDialog)

YouWinDlg.BASE_NODE_TAG = 49;
YouWinDlg.WORK_PLACE = 72;
YouWinDlg.REPLAY_MENU_TAG = 70;
YouWinDlg.REPLAY_MENU_ITEM_TAG = 71;
YouWinDlg.LABEL_BACK = 74;
YouWinDlg.CHOOSE_LEVEL_MENU_TAG = 60;
YouWinDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
YouWinDlg.NEXT_LEVEL_MENU_TAG = 80;
YouWinDlg.NEXT_LEVEL_MENU_ITEM_TAG = 81;
YouWinDlg.LABEL_TAGS = {2, 3, 4, 5};
YouWinDlg.ANIM_SPRITE = 75;
YouWinDlg.BUTTON_OK = 100;

YouWinDlg.TRAP_STAR_TAG = 300;
YouWinDlg.COINS_STAR_TAG = 400;
YouWinDlg.TIME_STAR_TAG = 500;
YouWinDlg.ALL_STAR_TAG = 600;
YouWinDlg.ALL_STAR_COUNT = 5;

YouWinDlg.mAnimator = nil;
YouWinDlg.mMainUI = nil;
YouWinDlg.mStarsCount = nil;
YouWinDlg.mStarAnimations = nil;
YouWinDlg.mAnimation = nil;

--------------------------------
function YouWinDlg:init(game, uiLayer, mainUI)
	self:superClass().init(self, game, uiLayer, "VictoryDlg");

    self.mMainUI = mainUI;
    self.mStarAnimations = {};
	self:initGuiElements();
end

--------------------------------
function YouWinDlg:doModal(stars, lastStar)
	info_log("YouWinDlg:doModal ", stars);
	self:superClass().doModal(self);
    self.mStarsCount = stars;
    self:destroyStarAnimations();
    if not lastStar then
	   self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
    else
        self.mAnimation:play();
        self:showStarsImpl(self.mStarsCount.trapStar, YouWinDlg.TRAP_STAR_TAG, true);
        self:showStarsImpl(self.mStarsCount.coinsStar, YouWinDlg.COINS_STAR_TAG, true);
        self:showStarsImpl(self.mStarsCount.timeStar, YouWinDlg.TIME_STAR_TAG, true);
        self:showStarsImpl(self.mStarsCount.allStar, YouWinDlg.ALL_STAR_TAG, true, true);
    end
end

--------------------------------
function YouWinDlg:getStars()
    return self.mStarsCount;
end

--------------------------------
function YouWinDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	info_log("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, YouWinDlg.CHOOSE_LEVEL_MENU_TAG, YouWinDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function YouWinDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	info_log("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, YouWinDlg.REPLAY_MENU_TAG, YouWinDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function YouWinDlg:initNextLevelButton(nodeBase)
	local function onNextLevelPressed(val, val2)
    	info_log("onNextLevelPressed ");
    	self.mGame.mSceneMan:runNextLevelScene();
    end

    setMenuCallback(nodeBase, YouWinDlg.NEXT_LEVEL_MENU_TAG, YouWinDlg.NEXT_LEVEL_MENU_ITEM_TAG, onNextLevelPressed);
end

---------------------------------
function YouWinDlg:tick(dt)
    self.mAnimation:tick(dt);

    if self.mStarAnimations then
        for i, animation in pairs(self.mStarAnimations) do
            if animation then
                animation:tick(dt);
            end
        end
    end
end

--------------------------------
function YouWinDlg:initLabels(nodeBase)
    for i,val in ipairs(YouWinDlg.LABEL_TAGS ) do
        local label = tolua.cast(nodeBase:getChildByTag(val), "cc.Label");
        info_log("YouWinDlg:initGuiElements label ", label);

        if label then
            setLabelLocalizedText(label, self.mGame);
            setDefaultFont(label, self.mGame:getScale());
        end
    end
end

--------------------------------
function YouWinDlg:initButtonOk(nodeBase)
    local button = tolua.cast(nodeBase:getChildByTag(YouWinDlg.BUTTON_OK), "cc.ControlButton");
    debug_log("YouWinDlg:initButtonOk button ", button);

    setControlButtonLocalizedText(button, self.mGame);

    --self:initButtonLabel(label1);

    local function onButtonPress()
        debug_log("YouWinDlg:initButtonOk onButtonPress ");
        local allStars = self.mStarsCount.allStar;
        if allStars == YouWinDlg.ALL_STAR_COUNT then
            self.mGame.mSceneMan:runNextLevelScene();
        else
            self.mMainUI:onGetStarDlgPressed();
        end
    end
    button:registerControlEventHandler(onButtonPress, 1);

    
end

---------------------------------
function YouWinDlg:destroyStarAnimations()
    for i,val in ipairs(self.mStarAnimations) do
        val:destroy();
    end
    self.mStarAnimations = {};
end

---------------------------------
function YouWinDlg:destroy()
    self:superClass().destroy(self);

    self.mAnimation:destroy();

    self:destroyStarAnimations();
end

--------------------------------
function YouWinDlg:showStarsImpl(starCount, tag, hideBegin, lastStarAnim)
    local nodeBase = self.mNode:getChildByTag(YouWinDlg.BASE_NODE_TAG);
    for i = 1, starCount do
        local star = nodeBase:getChildByTag(tag + (i - 1));
        debug_log("YouWinDlg:showStarsImpl i ", i, " star ", star);
        star:stopAllActions();

        local sequence = SequenceAnimation:create();
        sequence:init();

        if (not hideBegin) or (lastStarAnim and i == starCount) then
            local animationBegin = PlistAnimation:create();
            animationBegin:init("LevelStarBegin.plist", star, star:getAnchorPoint(), nil, 0.1);
            sequence:addAnimation(animationBegin);
        end

        local animation = PlistAnimation:create();
        animation:init("LevelStar.plist", star, star:getAnchorPoint(), nil, 0.1);
        local repAnimation = RepeatAnimation:create();
        repAnimation:init(animation);

        sequence:addAnimation(repAnimation);

        table.insert(self.mStarAnimations, sequence);
        sequence:play();
    end
end

--------------------------------
function YouWinDlg:showStars()
    self:showStarsImpl(self.mStarsCount.trapStar, YouWinDlg.TRAP_STAR_TAG);
    self:showStarsImpl(self.mStarsCount.coinsStar, YouWinDlg.COINS_STAR_TAG);
    self:showStarsImpl(self.mStarsCount.timeStar, YouWinDlg.TIME_STAR_TAG);
    self:showStarsImpl(self.mStarsCount.allStar, YouWinDlg.ALL_STAR_TAG);
end

--------------------------------
function YouWinDlg:initAnimation(nodeBase)
    local animationNode  = nodeBase:getChildByTag(YouWinDlg.ANIM_SPRITE);

--    local animation = PlistAnimation:create();
--    animation:init("LevelClearedAnim.plist", animationNode, animationNode:getAnchorPoint(), nil, 0.3);

    local animationBegin = PlistAnimation:create();
    animationBegin:init("LevelClearedAnim.plist", animationNode, animationNode:getAnchorPoint(), nil, 0.3);

    local animation = PlistAnimation:create();
    animation:init("LevelClearedAnimLoop.plist", animationNode, animationNode:getAnchorPoint(), nil, 0.3);
    local repAnimation = RepeatAnimation:create();
    repAnimation:init(animation);

    local sequence = SequenceAnimation:create();
    sequence:init();

    sequence:addAnimation(animationBegin);
    sequence:addAnimation(repAnimation);

    self.mAnimation = sequence;
    function start_callback()
        info_log("start_callback ");
        self.mAnimation:play();
        self:showStars();
    end

    local starCallFunc = CCCallFunc:create(start_callback);
    self.mAnimator:setCallFuncForLuaCallbackNamed(starCallFunc, "0:animationStart");
end

--------------------------------
function YouWinDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(YouWinDlg.BASE_NODE_TAG);
	info_log("YouWinDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(YouWinDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(YouWinDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

	self.mAnimator = self.mReader:getActionManager();

	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);
	self:initNextLevelButton(nodeBase);
    self:initButtonOk(nodeBase);

    self:initLabels(nodeBase);

    self:initAnimation(nodeBase);
end
