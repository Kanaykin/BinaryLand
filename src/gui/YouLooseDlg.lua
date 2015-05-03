require "src/gui/CCBBaseDlg"
require "src/base/Log"

YouLooseDlg = inheritsFrom(CCBBaseDialog)

YouLooseDlg.BASE_NODE_TAG = 49;
YouLooseDlg.LAYER_TAG = 50;
YouLooseDlg.CHOOSE_LEVEL_MENU_TAG = 60;
YouLooseDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
YouLooseDlg.REPLAY_MENU_TAG = 70;
YouLooseDlg.REPLAY_MENU_ITEM_TAG = 71;
YouLooseDlg.WORK_PLACE = 72;
YouLooseDlg.LABEL_BACK = 74;
YouLooseDlg.ANIM_SPRITE = 75;
YouLooseDlg.LABEL_TAG = 2;
YouLooseDlg.mAnimator = nil;

--------------------------------
function YouLooseDlg:doModal()
	self:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
end

--------------------------------
function YouLooseDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "YouLooseDlg");

	self:initGuiElements();
end

--------------------------------
function YouLooseDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	info_log("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, YouLooseDlg.REPLAY_MENU_TAG, YouLooseDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function YouLooseDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	info_log("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, YouLooseDlg.CHOOSE_LEVEL_MENU_TAG, YouLooseDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function YouLooseDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(YouLooseDlg.BASE_NODE_TAG);
	info_log("YouLooseDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(YouLooseDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(YouLooseDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

	self.mAnimator = self.mReader:getActionManager();

	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);

    local label = tolua.cast(nodeBase:getChildByTag(YouLooseDlg.LABEL_TAG), "cc.Label");
    info_log("YouLooseDlg:initGuiElements label ", label);

    if label then
        setDefaultFont(label, self.mGame:getScale());
    end

    local animationNode  = nodeBase:getChildByTag(YouLooseDlg.ANIM_SPRITE);

    local animation = PlistAnimation:create();
    animation:init("LevelFailedAnim.plist", animationNode, animationNode:getAnchorPoint(), nil, 0.3);

    self.mAnimation = RepeatAnimation:create();
    self.mAnimation:init(animation);
    self.mAnimation:play();

end