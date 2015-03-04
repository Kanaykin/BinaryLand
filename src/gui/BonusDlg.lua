require "src/gui/CCBBaseDlg"

BonusDlg = inheritsFrom(CCBBaseDialog)
BonusDlg.mCallBack = nil;

BonusDlg.BASE_NODE_TAG = 49;
BonusDlg.WORK_PLACE = 72;
BonusDlg.LABEL_BACK = 74;
BonusDlg.LABEL_TAG = 2;

--------------------------------
function BonusDlg:init(game, uiLayer)
    self:superClass().init(self, game, uiLayer, "BonusDlg");

    self:initGuiElements();
end

--------------------------------
function BonusDlg:setCallBack(callback)
    self.mCallBack = callback;
end

--------------------------------
function BonusDlg:doModal()
    print("BonusDlg:doModal");
    self:superClass().doModal(self);
    self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function BonusDlg:initGuiElements()
    self.mAnimator = self.mReader:getActionManager();


    function callback()
        print("BonusDlg:callback");
        self:mCallBack();
    end

    local callFunc = CCCallFunc:create(callback);
    self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:Finish");

    local nodeBase = self.mNode:getChildByTag(BonusDlg.BASE_NODE_TAG);
    print("BonusDlg:initGuiElements nodeBase ", nodeBase );

    if not nodeBase then
        return;
    end

    local workPlace = nodeBase:getChildByTag(BonusDlg.WORK_PLACE);
    self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(BonusDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

    local label = tolua.cast(nodeBase:getChildByTag(YouLooseDlg.LABEL_TAG), "cc.Label");

    if label then
        setDefaultFont(label, self.mGame:getScale());
    end
end