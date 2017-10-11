require "src/scenes/BaseScene"
require "src/gui/ScrollView"
require "src/base/AlignmentHelper"
require "src/scenes/GameConfigs"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/gui/GuiHelper"
require "src/gui/TouchWidget"
require "src/gui/NotEnoughStarsDlg"
require "src/gui/SettingsDlg"

local LOADSCEENIMAGE = "GlobalMapBack.png"
local GLOBALMAP = "GlobalMap.png"

--[[
start scene - loading screen
]]
ChooseLocation = inheritsFrom(BaseScene)
ChooseLocation.mScrollView = nil;
ChooseLocation.mBabyInTrapAnimations = nil
ChooseLocation.mBonusAnimations = nil
ChooseLocation.mNode = nil;
ChooseLocation.mSettingsDlg = nil;

ChooseLocation.LABEL_BEGIN = 1;
ChooseLocation.LABEL_TAG = 2;
ChooseLocation.COUNT_LOCATION = 4;

ChooseLocation.LOCATION_BEGIN = 10;
ChooseLocation.LOCATION_FOX_ANIMATION_DELTA = 3;
ChooseLocation.LOCATION_FOX_BACK_DELTA = 4;
ChooseLocation.LOCATION_SPRITE_BEGIN = 100;

ChooseLocation.BACK_MENU = 7;
ChooseLocation.BACK_MENU_ITEM = 8;
ChooseLocation.TUTORIAL_FRAME = 20;

ChooseLocation.PLANE_STAR_BEGIN = 80;
ChooseLocation.COUNT_STAR_LABEL_BEGIN = 90;
ChooseLocation.LOCK_IMAGE_TAG = 150;

ChooseLocation.BONUS_NODE = 500;
ChooseLocation.BONUS_MENU = 70;
ChooseLocation.BONUS_ANIM_NODE = 80;
ChooseLocation.BONUS_MENU_ITEM = 71;

local MovieText = "StartMovieStep6Text";


--------------------------------
function ChooseLocation:createIdleAnimation(animation, nameAnimation, node, texture, textureSize, textureName,
                                        times, delayPerUnit)
    local repeat_idle = RepeatAnimation:create();

    local idle = PlistAnimation:create();
    idle:init(nameAnimation, node, node:getAnchorPoint(), nil, delayPerUnit);
    repeat_idle:init(idle, false, times);
    animation:addAnimation(repeat_idle);
end

--------------------------------
function ChooseLocation:createBabyAnimation(node)
    local randomAnim = RandomAnimation:create();
    randomAnim:init();
    self:createIdleAnimation(randomAnim, "BabyIdle1.plist", node, texture, contentSize, textureName, 3);
    self:createIdleAnimation(randomAnim, "BabyIdle2.plist", node, texture, contentSize, textureName, 1, 0.15);
    return randomAnim;
end

--------------------------------
function ChooseLocation:createBabyFreeAnimation(node)
    local repeat_idle = RepeatAnimation:create();

    local idle = PlistAnimation:create();
    idle:init("BabyFreeIdle.plist", node, node:getAnchorPoint(), nil, 0.15);

    local delayAnim = DelayAnimation:create();
    delayAnim:init(idle, math.random(1, 2000) / 1000, texture, contentSize, textureName);

    repeat_idle:init(delayAnim, true);

    return repeat_idle;
end

--------------------------------
function ChooseLocation:showBonusRoom(location, sprite)
    local bonusNode = sprite:getChildByTag(ChooseLocation.BONUS_NODE);
    if bonusNode then
        bonusNode:setVisible(false);
    end
    local bonusLevel = location:getBonusLevel();
    debug_log("ChooseLocation:showBonusRoom bonusLevel ", bonusLevel);
    if not bonusLevel or not bonusLevel:isOpened() then
        return;
    end

    bonusNode:setVisible(true);
    local countStarLabel = bonusNode:getChildByTag(ChooseLocation.COUNT_STAR_LABEL_BEGIN);
    if countStarLabel then
        setDefaultFont(countStarLabel, self.mSceneManager.mGame:getScale());

        local countStar = bonusLevel:getCountStar();
        countStarLabel:setString(tostring(countStar));
    end

    local function onBonusLevelPressed()
        info_log("onBonusLevelPressed ");
        self.mSceneManager:runLevelScene(bonusLevel);
    end

    setMenuCallback(bonusNode, ChooseLocation.BONUS_MENU , ChooseLocation.BONUS_MENU_ITEM, onBonusLevelPressed);
end

--------------------------------
function ChooseLocation:showLocation(sprite, i)
    debug_log("ChooseLocation:showLocation ", i);

    local locations = self.mSceneManager.mGame:getLocations();
    local location = locations[i];
    if not location:isLocked() then
        self:setCountStar(location:getCountStar(), i);
    end

    self:showBonusRoom(location, sprite);
    --local foxInTrap = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * locationNum);
    --foxInTrap:setVisible(false);
    local animNode = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * i + ChooseLocation.LOCATION_FOX_ANIMATION_DELTA);
    if animNode then
        local anim = nil;
        local lockImage = sprite:getChildByTag(ChooseLocation.LOCK_IMAGE_TAG);
        lockImage:setVisible(false);

        if (#locations >= (i + 1) and locations[i + 1]:isOpened()) then 
            local back = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * i + ChooseLocation.LOCATION_FOX_BACK_DELTA);
            if back then
                back:setVisible(false);
            end
            anim = self:createBabyFreeAnimation(animNode);
        else
            anim = self:createBabyAnimation(animNode);
        end
        if location:isLocked() then
            lockImage:setVisible(true);
        end

        anim:play();
        self.mBabyInTrapAnimations[i] = anim;
    end

end

--------------------------------
function ChooseLocation:createLocationImages(node)
    info_log("ChooseLocation:createLocationImages node ", node);

    self.mBabyInTrapAnimations = {};
    self.mBonusAnimations = {};
    local locations = self.mSceneManager.mGame:getLocations();
    local locationNum = 1;

    local lastVisited = self.mSceneManager.mGame:getLastVisitLocation();
    local scrollVisitedOffset = nil;
	for i, location in ipairs(locations) do
        local sprite = node:getChildByTag(ChooseLocation.LOCATION_SPRITE_BEGIN * i);
        info_log("ChooseLocation:createLocationImages location ID ", location:getId(), " isOpened ", location:isOpened());

        local function onLocationPressed()
            info_log("onLocationPressed ", self.mGuiLayer);
            location:onLocationPressed();
            self.mSceneManager.mGame:setLastVisitLocation(location:getId());
        end

        if lastVisited == location:getId() then
            local positionNode = Vector.new(sprite:getPosition());
            scrollVisitedOffset = positionNode.x - sprite:getContentSize().width / 2;
        end

        -- TODO: check all opened
        if  location:isOpened() then
            self:showLocation(sprite, i);
            if not lastVisited then
                local positionNode = Vector.new(sprite:getPosition());
                scrollVisitedOffset = positionNode.x - sprite:getContentSize().width / 2;
            end
        else -- if location is locked
            sprite:setVisible(false);
        end
        debug_log("ChooseLocation:createLocationImages i ", i);
        setMenuCallback(sprite, ChooseLocation.LOCATION_BEGIN * i , ChooseLocation.LOCATION_BEGIN * i + 1, onLocationPressed);

        info_log("ChooseLocation:createLocationImages scrollVisitedOffset ", scrollVisitedOffset);
        if scrollVisitedOffset then
            local visibleSize = CCDirector:getInstance():getVisibleSize();
            --scrollVisitedOffset = math.min(scrollVisitedOffset, visibleSize.width);
            --scrollVisitedOffset = scrollVisitedOffset - visibleSize.width / 2;
            scrollVisitedOffset = math.max(scrollVisitedOffset, 0);
            info_log("ChooseLocation:createLocationImages scrollVisitedOffset result ", scrollVisitedOffset);
            self.mScrollView:setContentOffset({ x = -scrollVisitedOffset, y = 0});
        end

        locationNum = locationNum + 1;
	end
end

---------------------------------
function ChooseLocation:destroy()
    debug_log("ChooseLocation:destroy");
	ChooseLocation:superClass().destroy(self);

	self:getGame():getSoundManager():stopMusic(true);

    for key, anim in ipairs(self.mBabyInTrapAnimations) do
        anim:destroy();
    end

    for key, anim in ipairs(self.mBonusAnimations) do
        anim:destroy();
    end

    self.mSettingsDlg:destroy();
end

--------------------------------
function ChooseLocation:initScene()

    local globalMap = CCSprite:create(GLOBALMAP);
    local imageMapSize = globalMap:getContentSize();
    local visibleSize = CCDirector:getInstance():getVisibleSize();

	self.mScrollView = ScrollView:create();
	self.mScrollView:init(cc.size(imageMapSize.width / visibleSize.width, 1), {});
	self.mScrollView:setClickable(true);
	self.mSceneGame:addChild(self.mScrollView.mScroll);

	--parallax
	local parallax = CCParallaxNode:create();
	self.mScrollView:addChild(parallax);

	local pos = Coord(0.8, 0.5, 0, 0);
	local grass = CCSprite:create(LOADSCEENIMAGE);

    local imageSize = grass:getContentSize();
    local scale = visibleSize.height / imageSize.height;
    grass:setScaleY(scale);
    grass:setScaleX(scale);

	parallax:addChild(grass, 1, cc.p(0.4, 1.0), getPosition(grass, pos));

    globalMap:setAnchorPoint(cc.p(0, 0));
    self.mScrollView:addChild(globalMap);

    self:createLocations();
end

--------------------------------
function ChooseLocation:createLocations()
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("ChooseLocation", reader, false);
    self.mScrollView:addChild(node);
    self.mNode = node;

    self:updateLabels(node);
    self:updateCountStarLabels(node);
    self:createLocationImages(node);
end

--------------------------------
function ChooseLocation:setCountStar(countStar, i)
    info_log("ChooseLocation:setCountStar (", countStar, " , ", i, ")");
    local label = tolua.cast(self.mNode:getChildByTag(ChooseLocation.COUNT_STAR_LABEL_BEGIN + i), "cc.Label");
    info_log("ChooseLocation:setCountStar label ", label);
    if label then
        label:setVisible(true);
        label:setString(tostring(countStar));
    end
    local plane = tolua.cast(self.mNode:getChildByTag(ChooseLocation.PLANE_STAR_BEGIN + i), "cc.Node");
    if plane then
        plane:setVisible(true);
    end
end

--------------------------------
function ChooseLocation:updateCountStarLabels(node)
    for i = 0, ChooseLocation.COUNT_LOCATION, 1 do
        local indexLabel = i + ChooseLocation.COUNT_STAR_LABEL_BEGIN;
        local label = tolua.cast(node:getChildByTag(indexLabel + 1), "cc.Label");
        info_log("ChooseLocation:updateLabels label ", label);

        if label then
            setDefaultFont(label, self.mSceneManager.mGame:getScale());
            label:setVisible(false);
        end
        local indexPlane = i + ChooseLocation.PLANE_STAR_BEGIN;
        local plane = tolua.cast(node:getChildByTag(indexPlane + 1), "cc.Node");
        if plane then
            plane:setVisible(false);
        end
    end

end

--------------------------------
function ChooseLocation:updateLabels(node)
    for i = ChooseLocation.LABEL_BEGIN, ChooseLocation.LABEL_BEGIN + ChooseLocation.COUNT_LOCATION, 1 do
        local label = tolua.cast(node:getChildByTag(i), "cc.Label");
        info_log("ChooseLocation:updateLabels label ", label);

        if label then
            setDefaultFont(label, self.mSceneManager.mGame:getScale());
        end
    end
end

--------------------------------
function ChooseLocation:setVisibleTutorialLayer(node, visible)
    local layer = node:getChildByTag(ChooseLocation.TUTORIAL_FRAME);
    if not layer then 
        return
    end
    layer:setVisible(visible);

    if visible then
        local label = tolua.cast(layer:getChildByTag(ChooseLocation.LABEL_TAG), "cc.Label");

        if label then
            setDefaultFont(label, self.mSceneManager.mGame:getScale());

            local localizationManager = self.mSceneManager.mGame:getLocalizationManager();
            local text = localizationManager:getStringForKey(MovieText);
            label:setString(text);
        end
    end

end

--------------------------------
function ChooseLocation:initGui(params)
    self:createGuiLayer();

    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("ChooseLocationUI", reader, false);
    self.mGuiLayer:addChild(node);

    local choseLevel = self;
    local function onReturnPressed()
    	info_log("onReturnPressed");
    	--choseLevel.mSceneManager:runPrevScene();
        self.mSettingsDlg:doModal();
    end

    setMenuCallback(node, ChooseLocation.BACK_MENU, ChooseLocation.BACK_MENU_ITEM, onReturnPressed);

    self:setVisibleTutorialLayer(node, params and params.fromTutorial);

    if params and params.locationLocked then
        local notEnoughStarsDlg = NotEnoughStarsDlg:create();
        notEnoughStarsDlg:init(self.mSceneManager.mGame, self.mGuiLayer, params.locationLocked);
        notEnoughStarsDlg:doModal();
    else
        self:hideNotEnoughStarsDlg();
    end

    -------------------------
    self.mSettingsDlg = SettingsDlg:create();
    self.mSettingsDlg:init(self.mSceneManager.mGame, self.mGuiLayer, "SettingsDlgLoc");
end

---------------------------------
function ChooseLocation:tick(dt)
    self:superClass().tick(self, dt);

    for key, anim in ipairs(self.mBabyInTrapAnimations) do
        anim:tick(dt);
    end

    for key, anim in ipairs(self.mBonusAnimations) do
        anim:tick(dt);
    end

    --if  not SimpleAudioEngine:getInstance():isMusicPlaying() then
        --self:getGame():getSoundManager():playMusic(gSounds.CHOOSE_LOCATION_MUSIC, true)
    --end
end

--------------------------------
function ChooseLocation:showUnlockBonusAnimation()
    local locations = self.mSceneManager.mGame:getLocations();

    for i, location in ipairs(locations) do
        local bonusLevel = location:getBonusLevel();
        if bonusLevel and bonusLevel:isOpened() then
            local showedUnlock = self.mSceneManager.mGame:getBonusUnlockShowed(location:getId());
            info_log("ChooseLocation:showUnlockBonusAnimation i ", i, " showedUnlock ", showedUnlock);
            if not showedUnlock then
                local sprite = self.mNode:getChildByTag(ChooseLocation.LOCATION_SPRITE_BEGIN * i);
                local itemNode = sprite:getChildByTag(ChooseLocation.BONUS_NODE);
                local bonusNode = itemNode:getChildByTag(ChooseLocation.BONUS_ANIM_NODE);
                debug_log("ChooseLocation:showUnlockBonusAnimation bonusNode ", bonusNode);
                if bonusNode then
                    local sequence = SequenceAnimation:create();
                    sequence:init();

                    local idle = PlistAnimation:create();
                    local anchor = {x=0.5, y=0.61};
                    idle:init("BonusLevelIconAnim.plist", bonusNode, anchor, nil, 0.1   );
                    sequence:addAnimation(idle);
                    
                    local emptyAnim = EmptyAnimation:create();
                    emptyAnim:init(nil, bonusNode, anchor);
                    emptyAnim:setFrame(idle:getLastFrame());
                    sequence:addAnimation(emptyAnim);

                    sequence:play();
                    self.mBonusAnimations[i] = sequence;

                    self.mSceneManager.mGame:setLocationUnlockShowed(location:getId(), true);
                end
            end
        end
    end
end

--------------------------------
function ChooseLocation:showUnlockAnimation()
    local locations = self.mSceneManager.mGame:getLocations();

    for i, location in ipairs(locations) do
        debug_log("ChooseLocation:showUnlockAnimation i " .. i)
        if i > 1 then 
            local locked = location:isLocked();
            if not locked then
                local showedUnlock = self.mSceneManager.mGame:getLocationUnlockShowed(location:getId());
                info_log("ChooseLocation:showUnlockAnimation i ", i, " showedUnlock ", showedUnlock);

                if not showedUnlock then
                    local sprite = self.mNode:getChildByTag(ChooseLocation.LOCATION_SPRITE_BEGIN * i);
                    local animNode = sprite:getChildByTag(ChooseLocation.LOCATION_BEGIN * i + ChooseLocation.LOCATION_FOX_ANIMATION_DELTA);
                    if animNode then
                        local sequence = SequenceAnimation:create();
                        sequence:init();

                        -- unlock animation
                        local idle = PlistAnimation:create();
                        idle:init("LocationOpenAnim.plist", animNode, {x=0.5, y=0.61}, nil, 0.1   );
                        sequence:addAnimation(idle);

                        local anim = self:createBabyAnimation(animNode);
                        sequence:addAnimation(anim);
                        if self.mBabyInTrapAnimations[i] ~= nil then
                            self.mBabyInTrapAnimations[i]:stop();
                            self.mBabyInTrapAnimations[i]:destroy();
                        end
                        animNode:stopAllActions();

                        sequence:play();
                        self.mBabyInTrapAnimations[i] = sequence;
                        self.mSceneManager.mGame:setLocationUnlockShowed(location:getId(), true);
                    end
                end
            end
        end
    end
    debug_log("ChooseLocation:showUnlockAnimation end " )
end

--------------------------------
function ChooseLocation:hideNotEnoughStarsDlg(locationLockedId)
    info_log("ChooseLocation:hideNotEnoughStarsDlg ", locationLockedId);

    self:showUnlockAnimation();
    self:showUnlockBonusAnimation();
end

--------------------------------
function ChooseLocation:init(sceneMan, params)
	info_log("ChooseLocation:init ");
	self:superClass().init(self, sceneMan, params);

	-- init scene
	self:initScene();

	-- init gui
	self:initGui(params);

    --ccexp.AudioEngine:setFinishCallback(function () end);
    self:getGame():getSoundManager():playMusic(gSounds.CHOOSE_LOCATION_MUSIC, true)

    local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("ChooseLocation");
end
