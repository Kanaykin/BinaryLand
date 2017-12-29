require "src/gui/CCBBaseDlg"

NotEnoughStarsDlg = inheritsFrom(CCBBaseDialog)

NotEnoughStarsDlg.mLocationLockedId = nil;
NotEnoughStarsDlg.mAnimation = nil;

NotEnoughStarsDlg.BASE_NODE_TAG = 49;
NotEnoughStarsDlg.WORK_PLACE = 72;
NotEnoughStarsDlg.LABEL_BACK = 74;
NotEnoughStarsDlg.NOT_ENOUGH = {
    BUTTON_YES = 100,
    -- TEXT_CURRENT_LOC_STARS_LABEL = 5
}

NotEnoughStarsDlg.ENOUGH = {
    BUTTON_YES = 101,
    -- TEXT_CURRENT_LOC_STARS_LABEL = 15
}

NotEnoughStarsDlg.TEXT_TITLE_LABEL = 2;
NotEnoughStarsDlg.TEXT_TITLE2_LABEL = 22;
-- NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL = 6;
NotEnoughStarsDlg.CURR_STAR_LABEL = 10;
NotEnoughStarsDlg.STAR_SEP_LABEL = 11;
NotEnoughStarsDlg.NEED_STAR_LABEL = 12;

NotEnoughStarsDlg.ANIM_NODE = 75;

-- // "NotEnoughStartsTitleText": "Location finished!",
-- // "NotEnoughStartsTitleText" : "Локация пройдена!",

--------------------------------
function NotEnoughStarsDlg:init(game, uiLayer, locationLockedId)
	self:superClass().init(self, game, uiLayer, "NotEnoughStarsDlg");

    self.mLocationLockedId = locationLockedId;
    self:initGuiElements();

    self:hideUnnecessaryElements();

    self:initAnimation()
end

--------------------------------
function NotEnoughStarsDlg:updateLabel(nodeBase, tagLabel)
    local label = tolua.cast(nodeBase:getChildByTag(tagLabel), "cc.Label");
    info_log("YouLooseDlg:updateLabel label ", label, " tagLabel ", tagLabel);

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

    local label = tolua.cast(nodeBase:getChildByTag(NotEnoughStarsDlg.CURR_STAR_LABEL), "cc.Label");
    if label then
        label:setString(tostring(countStars));
    end

    label = tolua.cast(nodeBase:getChildByTag(NotEnoughStarsDlg.STAR_SEP_LABEL), "cc.Label");
    if label then
        label:setString(tostring("/"));
    end

    label = tolua.cast(nodeBase:getChildByTag(NotEnoughStarsDlg.NEED_STAR_LABEL), "cc.Label");
    if label then
        label:setString(tostring(needStars));
    end

end

--------------------------------
function NotEnoughStarsDlg:initAnimation()
    local nodeBase = self.mNode:getChildByTag(NotEnoughStarsDlg.BASE_NODE_TAG);
    info_log("NotEnoughStarsDlg:initAnimation nodeBase ", nodeBase );
    
    if not nodeBase then
        return;
    end

    local animNode = nodeBase:getChildByTag(NotEnoughStarsDlg.ANIM_NODE);  

    local animationBark = PlistAnimation:create();
    animationBark:init("NotEnoughDlgAnim.plist", animNode, animNode:getAnchorPoint(), nil, 0.1);

    local repeatAnimation = RepeatAnimation:create();
    repeatAnimation:init(animationBark);
    self.mAnimation = repeatAnimation;
    self.mAnimation:play();
end

--------------------------------
function NotEnoughStarsDlg:hideUnnecessaryElements()
    local location = self.mGame:getLocation(self.mLocationLockedId);
    local needStars = location:getNeedStars();
    local countStars = location:getPredLocationStar(true);

    local notEnough = needStars > countStars;
    debug_log("NotEnoughStarsDlg:hideUnnecessaryElements notEnough ", notEnough);

    local nodeBase = self.mNode:getChildByTag(NotEnoughStarsDlg.BASE_NODE_TAG);

    local tableHide = notEnough and NotEnoughStarsDlg.ENOUGH or NotEnoughStarsDlg.NOT_ENOUGH;
    debug_log("NotEnoughStarsDlg:hideUnnecessaryElements tableHide ", tableHide);
    for i, tag in pairs(tableHide) do
        debug_log("NotEnoughStarsDlg:hideUnnecessaryElements i ", i);

        local w = nodeBase:getChildByTag(tag);
        w:setVisible(false);
    end
end

---------------------------------
function NotEnoughStarsDlg:tick(dt)
    if self.mAnimation then
        self.mAnimation:tick(dt);
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

---------------------------------
function NotEnoughStarsDlg:destroy()
    self:superClass().destroy(self);
    self.mGame.mSceneMan:getCurrentScene():hideNotEnoughStarsDlg(self.mLocationLockedId, true);

    if self.mAnimation then
        self.mAnimation:destroy()
    end
end

--------------------------------
function NotEnoughStarsDlg:hide()
    self:superClass().hide(self);
    self.mGame.mSceneMan:getCurrentScene():hideNotEnoughStarsDlg(self.mLocationLockedId);
end

--------------------------------
function NotEnoughStarsDlg:initGuiElements()
    local nodeBase = self.mNode:getChildByTag(NotEnoughStarsDlg.BASE_NODE_TAG);
    info_log("NotEnoughStarsDlg:initGuiElements nodeBase ", nodeBase );
    
    if not nodeBase then
        return;
    end

    local workPlace = nodeBase:getChildByTag(NotEnoughStarsDlg.WORK_PLACE);    
    self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

	local back = nodeBase:getChildByTag(NotEnoughStarsDlg.LABEL_BACK);
	GuiHelper.updateScale9SpriteByScale(back, self.mGame:getScale());

    self:initOkButton(nodeBase, NotEnoughStarsDlg.NOT_ENOUGH.BUTTON_YES);
    self:initOkButton(nodeBase, NotEnoughStarsDlg.ENOUGH.BUTTON_YES);

    self:updateLabel(nodeBase, NotEnoughStarsDlg.TEXT_TITLE_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.TEXT_TITLE2_LABEL);

    self:updateLabel(nodeBase, NotEnoughStarsDlg.CURR_STAR_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.STAR_SEP_LABEL);
    self:updateLabel(nodeBase, NotEnoughStarsDlg.NEED_STAR_LABEL);
    -- self:updateLabel(nodeBase, NotEnoughStarsDlg.NOT_ENOUGH.TEXT_CURRENT_LOC_STARS_LABEL);
    -- self:updateLabel(nodeBase, NotEnoughStarsDlg.ENOUGH.TEXT_CURRENT_LOC_STARS_LABEL);
    
    -- self:updateLabel(nodeBase, NotEnoughStarsDlg.CURRENT_LOC_STARS_LABEL_VAL);

    self:updateLocationInfo(nodeBase);
end
