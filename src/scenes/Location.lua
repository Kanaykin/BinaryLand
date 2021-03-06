require "src/base/Inheritance"
require "src/gui/Dialog"
require "src/gui/LocationLockedDlg"
require "src/scenes/Level"
require "src/base/Log"

Location = inheritsFrom(nil)
Location.mVisualNode = nil; -- image
Location.mOpened = false;
Location.mData = nil; -- static data of locations
Location.mGame = nil;
Location.mLevels = nil;
Location.mBonusLevel = nil;


---------------------------------
function Location:onLocationPressed()
    info_log("onLocationPressed opened ", self:isOpened());
    info_log("onLocationPressed self.mLevels ", #self.mLevels);

    local locationId = self:getId();
    info_log("Location:onLocationPressed locationId ", locationId)

    if self:isLocked() then
		-- local dlg = BaseDialog:create();
		-- dlg:show(self.mGame.mSceneMan:getCurrentScene());

	    local locationLockedDlg = LocationLockedDlg:create();
    	locationLockedDlg:init(self.mGame, self.mGame.mSceneMan:getCurrentScene():getGuiLayer(), self:getNeedStars(), 
    		self:getPredLocationStar(true));
    	locationLockedDlg:doModal();
	else
		info_log("show levels");
		self.mGame.mSceneMan:runNextScene({location = self});
	end
end

-----------------------------------
function Location:getCountStar(withBonus)

	local countStar = 0;
	for i, level in ipairs(self.mLevels) do
		countStar = countStar + level:getCountStar();
	end
	if withBonus and self.mBonusLevel then
		countStar = countStar + self.mBonusLevel:getCountStar();
	end
	return countStar;
end

-----------------------------------
function Location:getNeedStars()
	return self.mData.countStars;
end

---------------------------------
function Location:isOpened()
	return self.mOpened or self.mGame:isLocationOpened(self:getId());
end

---------------------------------
function Location:getPredLocationStar(withBonus)
	local locations = self.mGame:getLocations();
    if self.mData.id <= 1 then
    	return 0;
    end
    return locations[self.mData.id - 1]:getCountStar(withBonus);
end

---------------------------------
function Location:isLocked()
	local locations = self.mGame:getLocations();
    if self.mData.id <= 1 then
    	return false;
    end
    local countStars = self:getPredLocationStar(true);
    local needStars = self:getNeedStars();
    debug_log("countStars ", countStars);
    debug_log("needStars ", needStars);
    return needStars > countStars;
end

---------------------------------
function Location:getImage()
	return self.mData.image;
end

---------------------------------
function Location:getLevels()
	return self.mLevels;
end

---------------------------------
function Location:getLevel(index)
	if index == (#self.mLevels + 1) then
		debug_log("Location:getLevel get bonus ");
		return self.mBonusLevel;
	end
	return self.mLevels[index];
end

---------------------------------
function Location:getPosition()
	return self.mData.position;
end

---------------------------------
function Location:getId()
	return self.mData.id;
end


---------------------------------
function Location:getDescription()
	return self.mData.description;
end

---------------------------------
function Location:getBonusLevel()
	return self.mBonusLevel;
end

---------------------------------
function Location:initLevels(locationData)
    info_log("Location:initLevels !");
    local locationId = self:getId();
	if type(locationData.levels) == "table" then
		for i, levelData in ipairs(locationData.levels) do
			if not levelData.isBonus then
				local level = Level:create();

	            info_log("Location:initLevels levelData.id ", levelData.id)
	            level:init(levelData, self, i, self.mGame:getLevelStar(locationId, i));
				table.insert(self.mLevels, level);
			else
				self.mBonusLevel = Level:create();
	            self.mBonusLevel:init(levelData, self, i, self.mGame:getLevelStar(locationId, i));
			end
		end
	end
    info_log("Location:initLevels self.mLevels ", #self.mLevels);
end

---------------------------------
function Location:init(locationData, game)
	self.mData = locationData;
	self.mGame = game;
    self.mLevels = {};
	-- check preferences
	if(locationData.opened ~= nil ) then
		self.mOpened = locationData.opened; 
	end

	self:initLevels(locationData);
end
