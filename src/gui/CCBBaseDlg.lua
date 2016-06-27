require "src/base/Inheritance"
require "src/base/Log"

CCBBaseDialog = inheritsFrom(nil)

CCBBaseDialog.mNode = nil;
CCBBaseDialog.mUILayer = nil;
CCBBaseDialog.mReader = nil;
CCBBaseDialog.mGame = nil;
CCBBaseDialog.mTouchBBox = nil;

---------------------------------
function CCBBaseDialog:setTouchBBox(box)
	self.mTouchBBox = box;
end

---------------------------------
function CCBBaseDialog:destroy()
	info_log("CCBBaseDialog:destroy ", self.mGame.mDialogManager:isModal(self));
	if self.mGame.mDialogManager:isModal(self) then 
		self.mGame.mDialogManager:deactivateModal(self);
	end

	if self.mNode then
		local parent = self.mNode:getParent();
		parent:removeChild(self.mNode, true);
		self.mNode = nil;
	end
end

--------------------------------
function CCBBaseDialog:getNode()
    return self.mNode;
end

--------------------------------
function CCBBaseDialog:show()
	self.mNode:setVisible(true);
end

--------------------------------
function CCBBaseDialog:hide()
	self.mNode:setVisible(false);
end

--------------------------------
function CCBBaseDialog:doModal()
	self:show();
	local function onTouchHandler(action, var1, var2)
		info_log("!!! CCBBaseDialog onTouchHandler ", var1, ", ", var2);
		return not self.mTouchBBox:containsPoint(cc.p(var1, var2));
    end

	local layer = tolua.cast(self.mNode, "cc.Layer");
    --layer:registerScriptTouchHandler(onTouchHandler, false, -128, true);
    --layer:setTouchEnabled(true);

	self.mGame.mDialogManager:activateModal(self);
end

--------------------------------
function CCBBaseDialog:init(game, uiLayer, ccbFile)
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbFile, reader, false);
	uiLayer:addChild(node);

	self.mNode = node;
	self.mTouchBBox = self.mNode:getBoundingBox();
	self.mUILayer = uiLayer;
	self.mReader = reader;
	self.mNode:setVisible(false);
	self.mGame = game;
end
