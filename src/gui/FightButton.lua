require "src/base/Inheritance"
require "src/math/Vector"
require "src/gui/TouchWidget"
require "src/base/Log"

FightButton = inheritsFrom(TouchWidget)

FightButton.BUTTON_TAG = 21;
FightButton.mBBox = nil;
FightButton.mButtonNode = nil;
FightButton.mPressed = false;
FightButton.mBlocked = false;

--------------------------------
function FightButton:setBlocked(blocked)
	self.mBlocked = blocked;
end

--------------------------------
function FightButton:isPressed()
	if self.mBlocked then
		return false;
	end
	return self.mPressed;
end

--------------------------------
function FightButton:setPressed(pressed)
	self.mPressed = pressed;
end

--------------------------------
function FightButton:onDown()
	local cache = cc.SpriteFrameCache:getInstance();
	local frame = cache:getSpriteFrame("fire_button_pressed.png");
	info_log("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = true;
end

--------------------------------
function FightButton:onUp()
	local cache = cc.SpriteFrameCache:getInstance();
	local frame = cache:getSpriteFrame("fire_button.png");
	info_log("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = false;
end

----------------------------------------
function FightButton:onTouchBegan(point)
	info_log("TouchWidget:onTouchBegan ");
	self:onDown();
end

----------------------------------------
function FightButton:onTouchMoved(point)
	info_log("TouchWidget:onTouchMoved ");
end

----------------------------------------
function FightButton:onTouchEnded(point)
	info_log("TouchWidget:onTouchEnded ");
	self:onUp();
end

--------------------------------
function FightButton:init(guiLayer)
	local node  = guiLayer:getChildByTag(FightButton.BUTTON_TAG);
	info_log(" FightButton:init ", node);

	node:setVisible(false);

	if node:isVisible() then

		self.mButtonNode = tolua.cast(node, "cc.Sprite");

		local cache = cc.SpriteFrameCache:getInstance();
		cache:addSpriteFrames("fight_button_map.plist");

		self:superClass().init(self, node:getBoundingBox());

		local parent = node:getParent();
		
		local function onTouchHandler(action, var)
			return self:onTouchHandler(action, var);
	    end

	    local layer = tolua.cast(parent, "cc.Layer");
	    layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
	    layer:setTouchEnabled(true);

	end
end
