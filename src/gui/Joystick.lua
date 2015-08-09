require "src/base/Inheritance"
require "src/math/Vector"
require "src/gui/TouchWidget"
require "src/base/Log"

Joystick = inheritsFrom(TouchWidget)

Joystick.BUTTONS = {
	LEFT = 1,
	RIGHT = 2,
	TOP = 3,
	BOTTOM = 4,
	NONE = nil	
};

Joystick.BACKGROUND_TAG = 10;
Joystick.JOYSTICK_TAG = 15;
Joystick.BUTTON_TAG = 20;

Joystick.mCenter = nil;
Joystick.mRadius = nil;
Joystick.mDestPosition = nil;
Joystick.mButton = nil;
Joystick.mButtonPressed = Joystick.BUTTONS.NONE;
Joystick.mBlockedButton = nil;

--------------------------------
function Joystick:getButtonPressed( )
	return self.mButtonPressed;
end

--------------------------------
function Joystick:findButtonPressed(res)
	info_log("Joystick:findButtonPressed");
	if math.abs(res.x) > math.abs(res.y) then
		if res.x > 0 then
			self.mButtonPressed = Joystick.BUTTONS.RIGHT;
		else
			self.mButtonPressed = Joystick.BUTTONS.LEFT;
		end
	else
		if res.y > 0 then
			self.mButtonPressed = Joystick.BUTTONS.TOP;
		else
			self.mButtonPressed = Joystick.BUTTONS.BOTTOM;
		end
	end
	self.mButtonPressed = self:checkBlockedButton(self.mButtonPressed);
end

----------------------------------------
function Joystick:updatePos(position)
	info_log("Joystick:updatePos ");
	local res = (position - self.mCenter):normalize() * self.mRadius;
	-- compute position of button
	if (position - self.mCenter):len() > self.mRadius then
		self.mDestPosition = res + self.mCenter;
	else
		self.mDestPosition = position;
	end
	self:findButtonPressed(res);
	self.mButton:setPosition(self.mDestPosition.x, self.mDestPosition.y);
end

----------------------------------------
function Joystick:onTouchBegan(point)
	info_log("Joystick:onTouchBegan ", point);
	self:updatePos(point);
end

----------------------------------------
function Joystick:onTouchMoved(point)
	info_log("Joystick:onTouchMoved ");
	self:updatePos(point);
end

----------------------------------------
function Joystick:setButtonPressed(button)
	self.mButtonPressed = button;
	self.mButtonPressed = self:checkBlockedButton(self.mButtonPressed);
end

----------------------------------------
function Joystick:onTouchEnded(point)
	info_log("Joystick:onTouchEnded ");
	self.mDestPosition = self.mCenter;
	self.mButtonPressed = Joystick.BUTTONS.NONE;
	if self.mButton then
		self.mButton:setPosition(self.mDestPosition.x, self.mDestPosition.y);
	end
end

--------------------------------
function Joystick:checkBlockedButton(button)
	--info_log("Joystick:checkBlockedButton button ", button, "blocked ", self.mBlockedButton[button]);
	if self.mBlockedButton[button] then
		return nil
	end
	return button;
end

--------------------------------
function Joystick:addBlockedButton(button)
	self.mBlockedButton[button] = true;
end

--------------------------------
function Joystick:clearBlockedButtons()
	self.mBlockedButton = {};
end

--------------------------------
function Joystick:init(guiLayer)
	
	local node  = guiLayer:getChildByTag(Joystick.JOYSTICK_TAG);
	info_log(" Joystick:init ", node);

	node:setVisible(false);

	self.mBlockedButton = {}

	if node:isVisible() then
		--scene.mGuiLayer:addChild(node);
		self:superClass().init(self, node:getBoundingBox());
		
		-- set touch enabled for joystick 
		local function onTouchHandler(action, var)
			self:onTouchHandler(action, var);
	    end

	    local layer = tolua.cast(node, "cc.Layer");
	    layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
	    layer:setTouchEnabled(true);

	    -- init joystick size
	    local back = node:getChildByTag(Joystick.BACKGROUND_TAG);
	    local backSize = back:getContentSize();
	    info_log("backSize width ", backSize.width, " height ", backSize.height);
	    local backPosX, backPosY = back:getPosition();
	    local anchor = back:getAnchorPoint();
	    
	    self.mRadius = backSize.width / 2;
	    self.mCenter = Vector.new(backPosX - backSize.width * anchor.x + self.mRadius, backPosY - backSize.height * anchor.y + self.mRadius);
	    info_log("mCenter x ", self.mCenter.x, " y ", self.mCenter.y);

	    -- get button of joystick
	    self.mButton = node:getChildByTag(Joystick.BUTTON_TAG);
	    local buttonSize = self.mButton:getContentSize();
	    self.mRadius = self.mRadius - buttonSize.width / 2;
	end
end
