require "src/gui/CCBBaseDlg"

LocationOpenDlg = inheritsFrom(CCBBaseDialog)

LocationOpenDlg.BASE_NODE_TAG = 49;
LocationOpenDlg.WORK_PLACE = 72;

--------------------------------
function LocationOpenDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "LocationOpenDlg");
	self:initGuiElements();
end

--------------------------------
function LocationOpenDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(LocationOpenDlg.BASE_NODE_TAG);
	info_log("LocationOpenDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local workPlace = nodeBase:getChildByTag(LocationOpenDlg.WORK_PLACE);	
	self:setTouchBBox(workPlace:getBoundingBox());
    GuiHelper.updateScale9SpriteByScale(workPlace, self.mGame:getScale());
end