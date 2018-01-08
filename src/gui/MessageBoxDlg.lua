require "src/gui/CCBBaseDlg"
require "src/base/Log"

MessageBoxDlg = inheritsFrom(CCBBaseDialog)
MessageBoxDlg.mAnimationShow = "Show";
MessageBoxDlg.mText = nil;

MessageBoxDlg.BASE_NODE_TAG = 49;
MessageBoxDlg.WORK_PLACE = 72;
MessageBoxDlg.LABEL_BACK = 74;
MessageBoxDlg.LABEL = 2;
MessageBoxDlg.BUTTON_YES = 100;
MessageBoxDlg.BUTTON_CANCEL = 101;

--------------------------------
function MessageBoxDlg:init(game, uiLayer)
    MessageBoxDlg:superClass().init(self, game, uiLayer, "MessageBox");

    self:initGuiElements();
end

--------------------------------
function MessageBoxDlg:doModal(params)
    info_log("MessageDlg:doModal ", params);
    MessageBoxDlg:superClass().doModal(self);
    --self.mAnimator:runAnimationsForSequenceNamed(self.mAnimationShow);

    if params then
        self.mText:setString(params.text);
        self:initButton(MessageBoxDlg.BUTTON_YES, params.ok_callback, params.ok_text);
        self:initButton(MessageBoxDlg.BUTTON_CANCEL, params.cancel_callback, params.cancel_callback);
    end
end

--------------------------------
function MessageBoxDlg:initButton(tag, action, text)

    local nodeBase = self.mNode:getChildByTag(MessageBoxDlg.BASE_NODE_TAG);

    local button = tolua.cast(nodeBase:getChildByTag(tag), "cc.ControlButton");

    if not action then
        button:setVisible(false);
        return;
    end

    local ok_button_action = function ()
        self.mGame.mDialogManager:deactivateModal(self);
        action()
    end
    button:registerControlEventHandler(ok_button_action, 1);
    button:setTitleForState(text, 1);
    button:setTitleForState(text, 2);

    local label = button:getTitleLabelForState(1);
    label = tolua.cast(label, "cc.Label");
    if label then
        setDefaultFont(label, self.mGame:getScale());

        -- local size = label:getContentSize();
        -- info_log("MessageDlg:initButton size ", size.width, " ", size.height);
        -- label:updateContent();
        -- size = label:getContentSize();
        -- info_log("MessageDlg:initButton size ", size.width, " ", size.height);
        -- button:setContentSize(size)
    end
end

--------------------------------
function MessageBoxDlg:initGuiElements()
    -- self.mAnimator = self.mReader:getActionManager();


    -- function callback()
    --     info_log("BonusDlg:callback");
    --     self:mCallBack();
    -- end

    -- local callFunc = CCCallFunc:create(callback);
    -- self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:Finish");

    local nodeBase = self.mNode:getChildByTag(MessageBoxDlg.BASE_NODE_TAG);
    info_log("MessageBoxDlg:initGuiElements nodeBase ", nodeBase );

    if not nodeBase then
        return;
    end

    local workPlace = nodeBase:getChildByTag(MessageBoxDlg.WORK_PLACE);
    self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(MessageBoxDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

    local label = tolua.cast(nodeBase:getChildByTag(MessageBoxDlg.LABEL), "cc.Label");

    if label then
        setDefaultFont(label, self.mGame:getScale());
    end
    self.mText = label;
end
