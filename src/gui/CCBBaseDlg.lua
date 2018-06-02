require "src/base/Inheritance"
require "src/base/Log"
require "src/math/Rect"

CCBBaseDialog = inheritsFrom(nil)

CCBBaseDialog.mNode = nil;
CCBBaseDialog.mModalLayer = nil; -- layer for make modal dialog
CCBBaseDialog.mUILayer = nil;
CCBBaseDialog.mReader = nil;
CCBBaseDialog.mGame = nil;
CCBBaseDialog.mTouchBBox = nil;

---------------------------------
function CCBBaseDialog:setTouchBBox(box)
	self.mTouchBBox = Rect.new(box);
end

---------------------------------
function CCBBaseDialog:destroy()
	info_log("CCBBaseDialog:destroy ", self.mGame.mDialogManager:isModal(self));
	if self.mGame.mDialogManager:isModal(self) then 
		self.mGame.mDialogManager:deactivateModal(self);
	end

	if self.mModalLayer then
		self.mModalLayer:unregisterScriptTouchHandler();
		local parent = self.mModalLayer:getParent();
		parent:removeChild(self.mModalLayer, true);
		self.mNode = nil;
		self.mModalLayer = nil;
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
	if self.mModalLayer then
		self.mModalLayer:unregisterScriptTouchHandler();
	end
end

--------------------------------
function CCBBaseDialog:doModal()
	self:show();
	local function onTouchHandler(action, var1, var2)
		--info_log("!!! CCBBaseDialog onTouchHandler ", var1, ", ", var2);
		return true;--not self.mTouchBBox:containsPoint(cc.p(var1, var2));
    end

	local layer = tolua.cast(self.mModalLayer, "cc.Layer");
	debug_log("CCBBaseDialog:doModal ", layer);
	if layer then
    	layer:registerScriptTouchHandler(onTouchHandler, false, 0, true);
    	layer:setTouchEnabled(true);
    end

	self.mGame.mDialogManager:activateModal(self);
end

--------------------------------
function CCBBaseDialog:init(game, uiLayer, ccbFile)
	local ccpproxy = cc.CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile(ccbFile, reader, false);

	local layer = cc.Layer:create();
	debug_log("CCBBaseDialog:init layer ", layer);
	uiLayer:addChild(layer);
	layer:addChild(node);
	self.mModalLayer = layer;

	self.mNode = node;
	self.mTouchBBox = Rect.new(self.mNode:getBoundingBox());
	self.mUILayer = uiLayer;
	self.mReader = reader;
	self.mNode:setVisible(false);
	self.mGame = game;
end
