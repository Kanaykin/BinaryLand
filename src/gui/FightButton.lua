require "src/base/Inheritance"
require "src/math/Vector"
require "src/gui/TouchWidget"

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
	local cache = CCSpriteFrameCache:getInstance();
	local frame = cache:getSpriteFrame("fire_button_pressed.png");
	print("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = true;
end

--------------------------------
function FightButton:onUp()
	local cache = CCSpriteFrameCache:getInstance();
	local frame = cache:getSpriteFrame("fire_button.png");
	print("frame ", frame);
	self.mButtonNode:setDisplayFrame(frame);
	self.mPressed = false;
end

----------------------------------------
function FightButton:onTouchBegan(point)
	print("TouchWidget:onTouchBegan ");
	self:onDown();
end

----------------------------------------
function FightButton:onTouchMoved(point)
	print("TouchWidget:onTouchMoved ");
end

----------------------------------------
function FightButton:onTouchEnded(point)
	print("TouchWidget:onTouchEnded ");
	self:onUp();
end

--------------------------------
function FightButton:init(guiLayer)
	local node  = guiLayer:getChildByTag(FightButton.BUTTON_TAG);
	print(" FightButton:init ", node);

	node:setVisible(false);

	if node:isVisible() then

		self.mButtonNode = tolua.cast(node, "cc.Sprite");

		local cache = CCSpriteFrameCache:getInstance();
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