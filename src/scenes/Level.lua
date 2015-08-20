require "src/base/Inheritance"
require "src/base/Log"

Level = inheritsFrom(nil)
Level.mOpened = false;
Level.mData = nil;
Level.mNode = nil;

Level.MENU_TAG = 100;
Level.MENU_ITEM_TAG = 101;
Level.DUMMY_TAG = 20;
Level.FIRST_STAR_TAG = 21;
Level.LOCK_TAG = 50;
Level.BLUE_STAR_TAG = 1;
Level.LABEL_TAG = 40;
Level.mLocation = nil;
Level.mIndex = nil;
Level.mCountStar = 0;
Level.mStarAnimations = nil;

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
	print ("Level:runStartAnimation opened ", self:isOpened(), " count ", self:getCountStar())
	if self:isOpened() then
		animManager:runAnimationsForSequenceNamed("FireAnim");
		-- delete unused stars
		local countStar = self:getCountStar();
--[[		local dummy = node:getChildByTag(Level.DUMMY_TAG);
		for i = countStar, 2 do
			local star = node:getChildByTag(Level.FIRST_STAR_TAG + i);
			animManager:moveAnimationsFromNode(star, dummy);
			node:removeChild(star, false);
		end--]]
    end
    --animManager:runAnimationsForSequenceNamed("Lock");
end

-----------------------------------
function Level:getLocation()
	return self.mLocation;
end

-----------------------------------
function Level:onLevelIconPressed()
	info_log("onLevelIconPressed !!!");
	if self:isOpened() then
		self.mLocation.mGame.mSceneMan:runLevelScene(self);
	end
end

-----------------------------------
function Level:initButton(node)
	local menu = node:getChildByTag(Level.MENU_TAG);
	if menu then
		local menuItem = menu:getChildByTag(Level.MENU_ITEM_TAG);

        local function onLevelIconPressed()
            tolua.cast(menuItem, "cc.MenuItem"):unregisterScriptTapHandler();
            self:onLevelIconPressed();
        end

        info_log("Level:initButton menuItem ", menuItem);
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

    for i = 1, self:getCountStar() do
        function star_callback()
            info_log("star_callback ", i);
			local star = node:getChildByTag(Level.FIRST_STAR_TAG + (i - 1));
            star:setVisible(true);
            self.mStarAnimations[i]:play();
        end

        local starCallFunc = CCCallFunc:create(star_callback);
        animManager:setCallFuncForLuaCallbackNamed(starCallFunc, "0:starframe"..tostring(i));
    end

	self:initButton(node);

    local lock = node:getChildByTag(Level.LOCK_TAG);
    lock:setVisible(not self:isOpened());

    -- show blue star
    if self:isOpened() then
        for i = 1, 3 do
            local star = node:getChildByTag(Level.BLUE_STAR_TAG + (i - 1));
            star:setVisible(true);
        end
    end

    local label = node:getChildByTag(Level.LABEL_TAG);
    label:setVisible(self:isOpened());

    local textureName = "LevelLabel" .. tostring(self.mIndex).. ".png";
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
    tolua.cast(label, "cc.Sprite"):setTexture(texture);

    --------
    if self.mStarAnimations then
        for i, animation in pairs(self.mStarAnimations) do
            if animation then
                animation:destroy();
            end
        end
    end
    self.mStarAnimations = {}
    for i = 1, 3 do
        local star = node:getChildByTag(Level.FIRST_STAR_TAG + (i - 1));

        local animationBegin = PlistAnimation:create();
        animationBegin:init("LevelStarBegin.plist", star, star:getAnchorPoint(), nil, 0.1);

        local animation = PlistAnimation:create();
        animation:init("LevelStar.plist", star, star:getAnchorPoint(), nil, 0.1);
        local repAnimation = RepeatAnimation:create();
        repAnimation:init(animation);

        local sequence = SequenceAnimation:create();
        sequence:init();

        sequence:addAnimation(animationBegin);
        sequence:addAnimation(repAnimation);

        self.mStarAnimations[i] = sequence;
    end
end

---------------------------------
function Level:tick(dt)
    if self.mStarAnimations then
        for i, animation in pairs(self.mStarAnimations) do
            if animation then
                animation:tick(dt);
            end
        end
    end
end

---------------------------------
function Level:init(levelData, location, index, countStar)
	self.mLocation = location;
	self.mIndex = index;
	self.mData = levelData;
	if(levelData.opened ~= nil ) then
		self.mOpened = levelData.opened; 
	end
    debug_log("Level:init id ", levelData.id);
    debug_log("Level:init ccbFile ", levelData.ccbFile);
    self:setCountStar(countStar);
end