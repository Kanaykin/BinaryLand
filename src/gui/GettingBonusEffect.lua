require "src/gui/CCBBaseDlg"
require "src/base/Log"

GettingBonusEffect = inheritsFrom(CCBBaseDialog)

GettingBonusEffect.LABEL_TAG = 10;
GettingBonusEffect.mLabel = nil;
GettingBonusEffect.mFinished = nil;

--------------------------------
function GettingBonusEffect:finished()
    return self.mFinished;
end

--------------------------------
function GettingBonusEffect:init(game, uiLayer, bonus)
    info_log("GettingBonusEffect:init ", self:superClass());
    self:superClass().init(self, game, uiLayer, "GettingBonusEffect");

    self.mLabel = tolua.cast(self.mNode:getChildByTag(GettingBonusEffect.LABEL_TAG), "cc.Label");

    if self.mLabel then
        setDefaultFont(self.mLabel, self.mGame:getScale());
        local sign = bonus > 0 and "+" or "";
        self.mLabel:setString(sign..tostring(bonus));
    end

    local animator = self.mReader:getActionManager();
    animator:retain();

    function callback()
        info_log("GettingBonusEffect callback !!! ");
        self.mFinished = true;
    end

    local callFunc = cc.CallFunc:create(callback);
    animator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

    animator:runAnimationsForSequenceNamed("Default Timeline");
end
