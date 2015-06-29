require "src/base/Inheritance"
require "src/gui/Dialog"
require "src/scenes/Level"
require "src/base/Log"

Location = inheritsFrom(nil)
Location.mVisualNode = nil; -- image
Location.mOpened = false;
Location.mData = nil; -- static data of locations
Location.mGame = nil;
Location.mLevels = nil;


---------------------------------
function Location:onLocationPressed()
	info_log("onLocationPressed opened ", self.mOpened);
    info_log("onLocationPressed self.mLevels ", #self.mLevels);

    local locationId = self:getId();
    info_log("Location:onLocationPressed locationId ", locationId)

    if not self.mOpened then
		local dlg = BaseDialog:create();
		dlg:show(self.mGame.mSceneMan:getCurrentScene());
	else
		info_log("show levels");
		self.mGame.mSceneMan:runNextScene({location = self});
	end
end

---------------------------------
function Location:isOpened()
	return self.mOpened or self.mGame:isLocationOpened(self:getId());
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
function Location:getPosition()
	return self.mData.position;
end

---------------------------------
function Location:getId()
	return self.mData.id;
end

---------------------------------
function Location:initLevels(locationData)
    info_log("Location:initLevels !");
	if type(locationData.levels) == "table" then
		for i, levelData in ipairs(locationData.levels) do
			local level = Level:create();

            local locationId = self:getId();
            info_log("Location:initLevels levelData.id ", levelData.id)
            level:init(levelData, self, i, self.mGame:getLevelStar(locationId, i));
			table.insert(self.mLevels, level);
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
