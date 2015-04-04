require "src/base/Inheritance"

Level = inheritsFrom(nil)
Level.mOpened = false;
Level.mData = nil;

Level.MENU_TAG = 100;
Level.MENU_ITEM_TAG = 101;
Level.DUMMY_TAG = 20;
Level.FIRST_STAR_TAG = 21;
Level.mLocation = nil;
Level.mIndex = nil;
Level.mCountStar = 0;

-----------------------------------
function Level:setCountStar(countStar)
    self.mCountStar = countStar;
end

-----------------------------------
function Level:getCountStar()
	return self.mCountStar;
end

-----------------------------------
function Level:isOpened()
	local locationId = self:getLocation():getId();
	return self.mOpened or self.mLocation.mGame:isLevelOpened(locationId, self:getIndex()); --self.mOpened;
end

-----------------------------------
function Level:getData()
	return self.mData;
end

-----------------------------------
function Level:runStartAnimation(animManager, node)
	print ("Level:runStartAnimation ", self:isOpened())
	if self:isOpened() then
		animManager:runAnimationsForSequenceNamed("StarAnim");
		-- delete unused stars
		local countStar = self:getCountStar();
		local dummy = node:getChildByTag(Level.DUMMY_TAG);
		for i = countStar, 2 do
			local star = node:getChildByTag(Level.FIRST_STAR_TAG + i);
			animManager:moveAnimationsFromNode(star, dummy);
			node:removeChild(star, false);
		end
	else
		animManager:runAnimationsForSequenceNamed("Lock");
	end
end

-----------------------------------
function Level:getLocation()
	return self.mLocation;
end

-----------------------------------
function Level:onLevelIconPressed()
	print("onLevelIconPressed !!!");
	if self:isOpened() then
		self.mLocation.mGame.mSceneMan:runLevelScene(self);
	end
end

-----------------------------------
function Level:initButton(node)
	local function onLevelIconPressed()
		self:onLevelIconPressed();
	end

	local menu = node:getChildByTag(Level.MENU_TAG);
	if menu then
		local menuItem = menu:getChildByTag(Level.MENU_ITEM_TAG);
        print("Level:initButton menuItem ", menuItem);
		tolua.cast(menuItem, "cc.MenuItem"):registerScriptTapHandler(onLevelIconPressed);
	end
end


-----------------------------------
function Level:getIndex()
	return self.mIndex;
end

-----------------------------------
function Level:initVisual(primaryAnimator, animManager, nameFrame, node)

	local loc_self = self;
    local loc_animManager = animManager;
	function callback()
		loc_self:runStartAnimation(loc_animManager, node);
	end

	local callFunc = CCCallFunc:create(callback);
	primaryAnimator:setCallFuncForLuaCallbackNamed(callFunc, nameFrame);

	self:initButton(node);
end

---------------------------------
function Level:init(levelData, location, index, countStar)
	self.mLocation = location;
	self.mIndex = index;
	self.mData = levelData;
	if(levelData.opened ~= nil ) then
		self.mOpened = levelData.opened; 
	end
    self:setCountStar(countStar);
end