require "src/gui/CCBBaseDlg"

LocationLockedDlg = inheritsFrom(CCBBaseDialog)

LocationLockedDlg.BASE_NODE_TAG = 49;
LocationLockedDlg.WORK_PLACE = 72;
LocationLockedDlg.LABEL_BACK = 74;
LocationLockedDlg.LABEL = 2;
LocationLockedDlg.BUTTON_YES = 100;
LocationLockedDlg.TEXT = "Чтобы открыть локацию\n\n надо %s звезд.\n\n У вас %s.";

LocationLockedDlg.mNeedStars = 0;
LocationLockedDlg.mCurStars = 0;

--------------------------------
function LocationLockedDlg:init(game, uiLayer, needStars, curStars)
	debug_log("LocationLockedDlg:init ", needStars, ", ", curStars);
	self:superClass().init(self, game, uiLayer, "LocationLockedDlg");

	self.mNeedStars = needStars;
	self.mCurStars = curStars;
	self:initGuiElements();
end

--------------------------------
function LocationLockedDlg:doModal()
	self:superClass().doModal(self);

	local layer = tolua.cast(self.mNode:getChildByTag(1), "cc.Layer");
	debug_log("LocationLockedDlg:doModal layer ", layer);

	local function onTouchHandler(action, var)
        info_log("LocationLockedDlg:onTouchHandler ");
        return true;
    end

    -- layer:registerScriptTouchHandler(onTouchHandler, false, -128, true);
    -- layer:setTouchEnabled(true);
end

--------------------------------
function LocationLockedDlg:initButton(nodeBase, tag, action)
	local button = tolua.cast(nodeBase:getChildByTag(tag), "cc.ControlButton");
	local label = button:getTitleLabelForState(1);

    button:registerControlEventHandler(action, 1);

	label = tolua.cast(label, "cc.Label");
    if label then
        setDefaultFont(label, self.mGame:getScale());
    end
end

--------------------------------
function LocationLockedDlg:onYesPressed()
	--self:destroy();
	self.mGame.mDialogManager:delayRemove(self);
end

--------------------------------
function LocationLockedDlg:initLabel(nodeBase)
	local label = nodeBase:getChildByTag(LocationLockedDlg.LABEL);
    label = tolua.cast(label, "cc.Label");
    if label then
        setDefaultFont(label, self.mGame:getScale());
        label:setString(string.format(LocationLockedDlg.TEXT, self.mNeedStars, self.mCurStars));
    end
end

--------------------------------
function LocationLockedDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(LocationLockedDlg.BASE_NODE_TAG);
	info_log("LocationLockedDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(LocationLockedDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());

    local labelPlace = nodeBase:getChildByTag(LocationLockedDlg.LABEL_BACK);
    GuiHelper.updateScale9SpriteByScale(labelPlace, self.mGame:getScale());

	self:initButton(nodeBase, LocationLockedDlg.BUTTON_YES, function() self:onYesPressed() end);

	self:initLabel(nodeBase);
end
