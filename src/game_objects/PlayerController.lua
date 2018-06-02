require "src/base/Inheritance"
require "src/gui/TouchWidget"
require "src/base/Log"

PlayerController = inheritsFrom(TouchWidget)

PlayerController.mPlayerObjects = nil

PlayerController.mClickSize = 80;
PlayerController.mField = nil
PlayerController.mObjectCaptured = nil
PlayerController.mDeltaCapturedPos = nil

PlayerController.mPrevObjectPosition = nil

PlayerController.mDestPos = nil

PlayerController.mJoystick = nil

PlayerController.mFightButton = nil

---------------------------------
function PlayerController:destroy()
end

--------------------------------
function PlayerController:init(bbox, players, field, joystick, fightButton)
	info_log("PlayerController:init ");
	self:superClass().init(self, bbox);
	self.mPlayerObjects = players;
	self.mField = field;
	self.mJoystick = joystick;
	self.mFightButton = fightButton;
end

----------------------------------------
function PlayerController:touchObject(object, point)
	if self.mField:getState() == Field.LOSE then
		return;
	end
	
	local pos = object:getScreenPos();
	
	local scale = self.mField.mGame:getScale();

	local width = PlayerController.mClickSize * scale;
	local box = cc.rect(pos.x - width / 2, pos.y - width / 2, width, width);
    return Rect.new(box):containsPoint(cc.p(point.x, point.y));
end

----------------------------------------
function PlayerController:onDoubleTouch(point)
	if self.mField:getState() == Field.LOSE then
		return;
	end
	info_log("PlayerController:onDoubleTouch ");
	self.mFightButton:setPressed(true);
end

----------------------------------------
function PlayerController:onTouchBegan(point)
	if self.mField:getState() == Field.LOSE then
		return;
	end

	info_log("PlayerController:onTouchBegan ", self, " ( ",  point.x, " ,", point.y, ")");

	self:resetData();
	self.mObjectCaptured = nil;
	local centerBox = nil;
	for _, object in ipairs(self.mPlayerObjects) do
		--local box = object:getBoundingBox();
		--debug_log("PlayerController:onTouchBegan  x ", box.origin.x, " y ", box.origin.y);
		--debug_log("PlayerController:onTouchBegan  size ", box.size.width, " y ", box.size.height);
		local pos = object:getScreenPos();
		--info_log("PlayerController:onTouchBegan  x ", pos.x, " y ", pos.y);
		if not object:isInTrap() and self:touchObject(object, point) then
			local objPos = Vector.new(object.mNode:getPosition());
			local delta = Vector.new(point.x, point.y) - objPos;
			info_log("self:touchObject ", object:getTag(), " delta ", delta);

			local box = Rect.new(object:getBoundingBox());

        	local size = object.mNode:getBoundingBox();
        	local anchor = object.mNode:getAnchorPoint();
        	box.x = 0;
        	box.y = 0;
        	local center = cc.p(objPos.x + anchor.x * size.width , objPos.y + anchor.y * size.height);

			local newCenter = Vector.new(center.x + box.width / 2, center.y + box.height / 2);
			local deltaCenter = (newCenter - point):len();
			info_log("self:touchObject deltaCenter ", deltaCenter);
			
			if self.mObjectCaptured then

				if deltaCenter < centerBox then
					self.mObjectCaptured = object;
					self.mDeltaCapturedPos = delta;
					centerBox = deltaCenter;
				end
			else
				self.mObjectCaptured = object;
				self.mDeltaCapturedPos = delta;
				centerBox = deltaCenter;
			end
		end
	end
end

----------------------------------------
function PlayerController:getJoystickButton(direction)
	local horProj = direction:projectOn(Vector.new(1, 0));
	local horProjLen = horProj:len();
	--info_log("PlayerController:getJoystickButton horProj ", horProjLen);
	local verProj = direction:projectOn(Vector.new(0, 1));
	local verProjLen = verProj:len();
	--info_log("PlayerController:getJoystickButton verProj ", verProjLen);

	if horProjLen == 0 and verProjLen == 0 then
		return nil;
	end

	if horProjLen > verProjLen then
		return horProj.x > 0 and Joystick.BUTTONS.LEFT or Joystick.BUTTONS.RIGHT;
	else
		return verProj.y > 0 and Joystick.BUTTONS.BOTTOM or Joystick.BUTTONS.TOP;
	end
end

----------------------------------------
function PlayerController:onTouchMoved(point)
	if self.mField:getState() == Field.LOSE then
		return;
	end

	debug_log("PlayerController:onTouchMoved x ", point.x, " y ", point.y);
	local gridPos = Vector.new(self.mField:positionToGrid(Vector.new(point.x, point.y)));
	debug_log("PlayerController:onTouchMoved gridPos x ", gridPos.x, " y ", gridPos.y);

	if self.mObjectCaptured ~= nil then
		self.mDestPos = gridPos:clone();
		local dest = self.mField:gridPosToReal(gridPos);
		self.mDestPos.x = dest.x + self.mField.mCellSize / 2;
		self.mDestPos.y = dest.y + self.mField.mCellSize / 2;

		local playerPos = Vector.new(self.mObjectCaptured.mNode:getPosition());

		local newObjPos = playerPos + self.mDeltaCapturedPos;
		local objGridPos = Vector.new(self.mField:positionToGrid(newObjPos));
		local button = self:getJoystickButton((objGridPos - gridPos) * self.mObjectCaptured:getReverse());
		info_log("PlayerController:onTouchMoved objGridPos ", objGridPos.y);
		info_log("PlayerController:onTouchMoved gridPos ", gridPos.y);
		self.mJoystick:setButtonPressed(button);
	end
end

---------------------------------
function PlayerController:resetData()
	--info_log("PlayerController:resetData");
	self.mDestPos = nil;
	self.mJoystick:setButtonPressed(nil);
	self.mPrevObjectPosition = nil;
end

---------------------------------
function PlayerController:positionChanged()
	--debug_log("PlayerController:positionChanged ", self.mPrevObjectPosition);
	if self.mPrevObjectPosition == nil then
		return true;
	end

	local result = false;
	if self.mObjectCaptured then
		local pos = Vector.new(self.mObjectCaptured.mNode:getPosition());

		if not self.mPrevObjectPosition[self.mObjectCaptured] then
			result = true;
		else
			local prevPos = self.mPrevObjectPosition[self.mObjectCaptured];
			debug_log("PlayerController:positionChanged pos ", pos.x, " ", pos.y);
			debug_log("PlayerController:positionChanged prevPos ", prevPos.x, " ", prevPos.y);

			local dist = (pos - prevPos):len();
			debug_log("PlayerController:positionChanged dist ", dist);
			if dist > 0 then
				result = true;
			end
		end
		self.mPrevObjectPosition[self.mObjectCaptured] = pos;
		debug_log("PlayerController:positionChanged ", result);
	end
	return result;
end

---------------------------------
function PlayerController:tick(dt)
	self:superClass().tick(self, dt);

	self.mFightButton:setPressed(false);

	if self.mField:getState() == Field.LOSE then
		self:resetData();
	end

	if self.mDestPos ~= nil then
		-- get directional of moving
		local newObjPos = Vector.new(self.mObjectCaptured.mNode:getPosition()) + self.mDeltaCapturedPos;
		info_log("PController:onTouchMoved newObjPos x ", newObjPos.x , " y ", newObjPos.y );
		info_log("PController:onTouchMoved mDestPos2 x ", self.mDestPos.x , " y ", self.mDestPos.y );		
		
		local objGridPos = Vector.new(self.mField:positionToGrid(newObjPos));
		local destGridPos = Vector.new(self.mField:positionToGrid(self.mDestPos));
		debug_log("PlayerController:onTouchMoved objGridPos x ", objGridPos.x, " y ", objGridPos.y);
		--local button = self:getJoystickButton((objGridPos - destGridPos) * self.mObjectCaptured:getReverse());
		
		--self.mJoystick:setButtonPressed(button);

		local button = self:getJoystickButton((newObjPos - self.mDestPos) * self.mObjectCaptured:getReverse());
		info_log("PController:onTouchMoved button ", button);
		info_log("PController:onTouchMoved mJoystick ", self.mJoystick:getButtonPressed());

		if button ~= self.mJoystick:getButtonPressed() or not self:positionChanged() then
			self:resetData();
		end
	end
end

----------------------------------------
function PlayerController:onTouchEnded(point)
	info_log("PlayerController:onTouchEnded ");
	--self.mObjectCaptured = nil
	--self.mJoystick:setButtonPressed(nil);
	self.mPrevObjectPosition = {}

	-- for _, object in ipairs(self.mPlayerObjects) do
	-- 	local pos = Vector.new(object.mNode:getPosition());
	-- 	info_log("PlayerController:onTouchEnded  x ", pos.x, " y ", pos.y);
	-- 	self.mPrevObjectPosition[#self.mPrevObjectPosition + 1] = pos;
	-- end
end
