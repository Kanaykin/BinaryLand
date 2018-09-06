require "src/gui/CCBBaseDlg"

BuyCoffeeDlg = inheritsFrom(CCBBaseDialog)

BuyCoffeeDlg.BASE_NODE_TAG = 49;
BuyCoffeeDlg.WORK_PLACE = 72;
BuyCoffeeDlg.LABEL_BACK = 74;
BuyCoffeeDlg.LABEL = 2;
BuyCoffeeDlg.BUTTON_YES = 100;
BuyCoffeeDlg.BUTTON_NO = 101;
BuyCoffeeDlg.ANIM_SPRITE = 75;

BuyCoffeeDlg.mAnimation = nil

--------------------------------
function BuyCoffeeDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "BuyCoffeeDlg");

	self:initGuiElements();
end

--------------------------------
function BuyCoffeeDlg:initAnimation(nodeBase)
	local animationNode  = nodeBase:getChildByTag(BuyCoffeeDlg.ANIM_SPRITE);

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

--------------------------------
function BuyCoffeeDlg:initButton(nodeBase, tag, action)
	local button = tolua.cast(nodeBase:getChildByTag(tag), "cc.ControlButton");
    setControlButtonLocalizedText(button, self.mGame);
    button:registerControlEventHandler(action, 1);
end

---------------------------------
function BuyCoffeeDlg:tick(dt)
    self.mAnimation:tick(dt);
end

--------------------------------
function BuyCoffeeDlg:onNoPressed()
    self:hide();
    self.mGame.mDialogManager:deactivateModal(self);
end

--------------------------------
function BuyCoffeeDlg:onYesPressed()
    local billing = extend.Billing:getInstance();
    billing:purchase("com.mycompany.binaryland.buycoffee");
end

--------------------------------
function BuyCoffeeDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(BuyCoffeeDlg.BASE_NODE_TAG);
	info_log("BuyCoffeeDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(BuyCoffeeDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(BuyCoffeeDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

    local label = tolua.cast(nodeBase:getChildByTag(BuyCoffeeDlg.LABEL), "cc.Label");
    if label then

        setLabelLocalizedText(label, self.mGame);

        setDefaultFont(label, self.mGame:getScale());
    end

    self:initButton(nodeBase, BuyCoffeeDlg.BUTTON_YES, function() self:onYesPressed() end);
    self:initButton(nodeBase, BuyCoffeeDlg.BUTTON_NO, function() self:onNoPressed() end);
    self:initAnimation(nodeBase);
end