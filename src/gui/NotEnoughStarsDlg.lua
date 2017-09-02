require "src/gui/CCBBaseDlg"

NotEnoughStarsDlg = inheritsFrom(CCBBaseDialog)

NotEnoughStarsDlg.mLocationLockedId = nil;

NotEnoughStarsDlg.BASE_NODE_TAG = 49;
NotEnoughStarsDlg.WORK_PLACE = 72;
NotEnoughStarsDlg.NOT_ENOUGH = {
    BUTTON_YES = 100,
    TEXT_CURRENT_LOC_STARS_LABEL = 5
}

NotEnoughStarsDlg.ENOUGH = {
    BUTTON_YES = 101,
    TEXT_CURRENT_LOC_STARS_LABEL = 15
}

NotEnoughStarsDlg.TEXT_TITLE_LABEL = 2;
NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL = 6;

--------------------------------
function NotEnoughStarsDlg:init(game, uiLayer, locationLockedId)
	self:superClass().init(self, game, uiLayer, "NotEnoughStarsDlg");

    self.mLocationLockedId = locationLockedId;
    self:initGuiElements();

    self:hideUnnecessaryElements();
end

--------------------------------
function NotEnoughStarsDlg:updateLabel(nodeBase, tagLabel)
    local label = tolua.cast(nodeBase:getChildByTag(tagLabel), "cc.Label");
    info_log("YouLooseDlg:initGuiElements label ", label, " tagLabel ", tagLabel);

    if label then
        setLabelLocalizedText(label, self.mGame);
        setDefaultFont(label, self.mGame:getScale());
    end
end

--------------------------------
function NotEnoughStarsDlg:updateLocationInfo(nodeBase)
    local location = self.mGame:getLocation(self.mLocationLockedId);
    debug_log("NotEnoughStarsDlg:updateLocationInfo self.mLocationLockedId ", self.mLocationLockedId);
    
    local needStars = location:getNeedStars();
    debug_log("NotEnoughStarsDlg:updateLocationInfo needStars ", needStars);
    local countStars = location:getPredLocationStar(true);

    local label = tolua.cast(nodeBase:getChildByTag(NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL), "cc.Label");
    if label then
        label:setString(tostring(countStars).."/"..tostring(needStars));
    end
end

--------------------------------
function NotEnoughStarsDlg:hideUnnecessaryElements()
    local location = self.mGame:getLocation(self.mLocationLockedId);
    local needStars = location:getNeedStars();
    local countStars = location:getPredLocationStar(true);

    local notEnough = needStars < countStars;
    debug_log("NotEnoughStarsDlg:hideUnnecessaryElements notEnough ", notEnough);

    local nodeBase = self.mNode:getChildByTag(GetStarDlg.BASE_NODE_TAG);

    local tableHide = notEnough and NotEnoughStarsDlg.NOT_ENOUGH or NotEnoughStarsDlg.ENOUGH;
    debug_log("NotEnoughStarsDlg:hideUnnecessaryElements tableHide ", tableHide);
    for i, tag in pairs(tableHide) do
        debug_log("NotEnoughStarsDlg:hideUnnecessaryElements i ", i);

        local w = nodeBase:getChildByTag(tag);
        w:setVisible(false);
    end
end

--------------------------------
function NotEnoughStarsDlg:initOkButton(nodeBase, buttonTag)
    local button = tolua.cast(nodeBase:getChildByTag(buttonTag), "cc.ControlButton");
    setControlButtonLocalizedText(button, self.mGame);

    local function onOKButtonPressed(val, val2)
        self.mGame.mDialogManager:delayRemove(self);
    end

    button:registerControlEventHandler(onOKButtonPressed, 1);
end

--------------------------------
function NotEnoughStarsDlg:initGuiElements()
    local nodeBase = self.mNode:getChildByTag(GetStarDlg.BASE_NODE_TAG);
    info_log("NotEnoughStarsDlg:initGuiElements nodeBase ", nodeBase );
    
    if not nodeBase then
        return;
    end

    local workPlace = nodeBase:getChildByTag(NotEnoughStarsDlg.WORK_PLACE);    
    self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    self:initOkButton(nodeBase, NotEnoughStarsDlg.NOT_ENOUGH.BUTTON_YES);
    self:initOkButton(nodeBase, NotEnoughStarsDlg.ENOUGH.BUTTON_YES);

    self:updateLabel(nodeBase, NotEnoughStarsDlg.TEXT_TITLE_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.NOT_ENOUGH.TEXT_CURRENT_LOC_STARS_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.ENOUGH.TEXT_CURRENT_LOC_STARS_LABEL);
    
    self:updateLabel(nodeBase, NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL);

    self:updateLocationInfo(nodeBase);
end