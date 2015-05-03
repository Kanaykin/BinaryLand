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
YouWinDlg.LABEL_TAG = 2;
YouWinDlg.ANIM_SPRITE = 75;
YouWinDlg.mAnimator = nil;

--------------------------------
function YouWinDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "VictoryDlg");

	self:initGuiElements();
end

--------------------------------
function YouWinDlg:doModal()
	info_log("YouWinDlg:doModal");
	self:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
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

    local label = tolua.cast(nodeBase:getChildByTag(YouLooseDlg.LABEL_TAG), "cc.Label");
    info_log("YouWinDlg:initGuiElements label ", label);

    if label then
        setDefaultFont(label, self.mGame:getScale());
    end

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
    end

    local starCallFunc = CCCallFunc:create(start_callback);
    self.mAnimator:setCallFuncForLuaCallbackNamed(starCallFunc, "0:animationStart");

end