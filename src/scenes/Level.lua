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

Level.MAX_COUNT_STAR = 5;

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
function Level:initFlashAnimation(primaryAnimator, animManager, nameFrame, node, showedStars)
    local loc_self = self;
    local loc_animManager = animManager;
    function callback()
        loc_self:runStartAnimation(loc_animManager, node);
    end

    local callFunc = CCCallFunc:create(callback);
    primaryAnimator:setCallFuncForLuaCallbackNamed(callFunc, nameFrame);

    for i = 1, self:getCountStar() do
        function star_callback()
            -- if i > showedStars then
                info_log("star_callback ", i);
                local star = node:getChildByTag(Level.FIRST_STAR_TAG + (i - 1));
                star:setVisible(true);
                self.mStarAnimations[i]:play();
            -- end
        end

        local starCallFunc = CCCallFunc:create(star_callback);
        animManager:setCallFuncForLuaCallbackNamed(starCallFunc, "0:starframe"..tostring(i));
    end

    for i = showedStars + 1, self:getCountStar() do
        info_log("Level:initFlashAnimation ", i);
        
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

-----------------------------------
function Level:initFireAnimation(node, starsCount)
    info_log("Level:initFireAnimation starsCount ", starsCount);
    
    for i = 1, starsCount do
        info_log("Level:initFireAnimation i ", i);
        local star = node:getChildByTag(Level.FIRST_STAR_TAG + (i - 1));
        if star then
            local animation = PlistAnimation:create();
            animation:init("LevelStar.plist", star, star:getAnchorPoint(), nil, 0.1);
            local repAnimation = RepeatAnimation:create();
            repAnimation:init(animation);
            self.mStarAnimations[i] = repAnimation;
            star:setVisible(true);
            self.mStarAnimations[i]:play();
        end
    end
end

-----------------------------------
function Level:initVisual(primaryAnimator, animManager, nameFrame, node, needShowed)

    self:initButton(node);

    local lock = node:getChildByTag(Level.LOCK_TAG);
    if lock then
        lock:setVisible(not self:isOpened());
    end

    -- show blue star
    if self:isOpened() then
        for i = 1, Level.MAX_COUNT_STAR do
            local star = node:getChildByTag(Level.BLUE_STAR_TAG + (i - 1));
            debug_log("Level:initVisual ", i, " star ", star);
            star:setVisible(true);
        end
    end

    local label = node:getChildByTag(Level.LABEL_TAG);
    if label then
        label:setVisible(self:isOpened());
        local textureName = "LevelLabel" .. tostring(self.mIndex).. ".png";
        local texture = cc.Director:getInstance():getTextureCache():addImage(textureName);
        tolua.cast(label, "cc.Sprite"):setTexture(texture);
    end

    --------
    if self.mStarAnimations then
        for i, animation in pairs(self.mStarAnimations) do
            if animation then
                animation:destroy();
            end
        end
    end

    self.mStarAnimations = {};
    local currentStars = self:getCountStar();
    info_log("Level:initVisual index ", self:getIndex(), " currentStars ", currentStars);
    info_log("Level:initVisual index ", self:getIndex(), " needShowed ", needShowed);
    
    self:initFireAnimation(node, currentStars - needShowed);

    self:initFlashAnimation(primaryAnimator, animManager, nameFrame, node, currentStars - needShowed);
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