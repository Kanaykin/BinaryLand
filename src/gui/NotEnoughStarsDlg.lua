require "src/gui/CCBBaseDlg"

NotEnoughStarsDlg = inheritsFrom(CCBBaseDialog)

NotEnoughStarsDlg.mLocationLockedId = nil;

NotEnoughStarsDlg.BASE_NODE_TAG = 49;
NotEnoughStarsDlg.WORK_PLACE = 72;
NotEnoughStarsDlg.BUTTON_YES = 100;
NotEnoughStarsDlg.TEXT_TITLE_LABEL = 2;
NotEnoughStarsDlg.TEXT_CURRENT_LOC_STARS_LABEL = 5;
NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL = 6;

--------------------------------
function NotEnoughStarsDlg:init(game, uiLayer, locationLockedId)
	self:superClass().init(self, game, uiLayer, "NotEnoughStarsDlg");

    self.mLocationLockedId = locationLockedId;
    self:initGuiElements();
end

--------------------------------
function NotEnoughStarsDlg:updateLabel(nodeBase, tagLabel)
    local label = tolua.cast(nodeBase:getChildByTag(tagLabel), "cc.Label");
    info_log("YouLooseDlg:initGuiElements label ", label);

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
function NotEnoughStarsDlg:initGuiElements()
    local nodeBase = self.mNode:getChildByTag(GetStarDlg.BASE_NODE_TAG);
    info_log("NotEnoughStarsDlg:initGuiElements nodeBase ", nodeBase );
    
    if not nodeBase then
        return;
    end

    local workPlace = nodeBase:getChildByTag(NotEnoughStarsDlg.WORK_PLACE);    
    self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());


    local button = tolua.cast(nodeBase:getChildByTag(NotEnoughStarsDlg.BUTTON_YES), "cc.ControlButton");
    setControlButtonLocalizedText(button, self.mGame);

    local function onOKButtonPressed(val, val2)
        self.mGame.mDialogManager:delayRemove(self);
    end

    button:registerControlEventHandler(onOKButtonPressed, 1);

    self:updateLabel(nodeBase, NotEnoughStarsDlg.TEXT_TITLE_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.TEXT_CURRENT_LOC_STARS_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL);

    self:updateLocationInfo(nodeBase);
end