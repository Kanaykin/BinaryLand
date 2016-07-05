require "src/gui/CCBBaseDlg"

GetStarDlg = inheritsFrom(CCBBaseDialog)
GetStarDlg.mAnimation = nil;
GetStarDlg.mStarsCount = nil;
GetStarDlg.mMainUI = nil;

GetStarDlg.BASE_NODE_TAG = 49;
GetStarDlg.WORK_PLACE = 72;
GetStarDlg.LABEL_BACK = 74;
GetStarDlg.LABEL = 2;
GetStarDlg.BUTTON_YES = 100;
GetStarDlg.BUTTON_NO = 101;
GetStarDlg.ANIM_SPRITE = 75;

--------------------------------
function GetStarDlg:init(game, uiLayer, mainUI)
	self:superClass().init(self, game, uiLayer, "VictoryDlgAds");

	self.mMainUI = mainUI;
	self:initGuiElements();
end

--------------------------------
function GetStarDlg:initButton(nodeBase, tag, action)
	local button = tolua.cast(nodeBase:getChildByTag(tag), "cc.ControlButton");
	local label = button:getTitleLabelForState(0);

    button:registerControlEventHandler(action, 1);

	label = tolua.cast(label, "cc.Label");
    if label then
        setDefaultFont(label, self.mGame:getScale());
    end
end

--------------------------------
function GetStarDlg:initAnimation(nodeBase)
	local animationNode  = nodeBase:getChildByTag(YouWinDlg.ANIM_SPRITE);

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
    self.mAnimation:play();
end

---------------------------------
function GetStarDlg:tick(dt)
    self.mAnimation:tick(dt);
end

--------------------------------
function GetStarDlg:saveStars()
    local level = self.mGame.mSceneMan:getCurrentScene():getLevel();
    local location = level:getLocation();
    debug_log("GetStarDlg:initButton onButtonPress Location Id ", location:getId());
    debug_log("GetStarDlg:initButton onButtonPress level Id ", level:getIndex());
    self.mGame:setLevelStar(location:getId(), level:getIndex(), self.mStarsCount.allStar);
end

--------------------------------
function GetStarDlg:onYesPressed()
    self.mStarsCount.allStar = self.mStarsCount.allStar + 1;
    self:saveStars();
    self.mMainUI:showWinDlg(self.mStarsCount, true);
end

--------------------------------
function GetStarDlg:onNoPressed()
	self.mGame.mSceneMan:runNextLevelScene();
end

--------------------------------
function GetStarDlg:doModal(stars)
	info_log("GetStarDlg:doModal");
	self:superClass().doModal(self);
    self.mStarsCount = stars;
end

--------------------------------
function GetStarDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(GetStarDlg.BASE_NODE_TAG);
	info_log("GetStarDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(GetStarDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(GetStarDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

    local label = tolua.cast(nodeBase:getChildByTag(GetStarDlg.LABEL), "cc.Label");
    if label then
        setDefaultFont(label, self.mGame:getScale());
    end

    self:initButton(nodeBase, GetStarDlg.BUTTON_YES, function() self:onYesPressed() end);
    self:initButton(nodeBase, GetStarDlg.BUTTON_NO, function() self:onNoPressed() end);
    self:initAnimation(nodeBase);
end