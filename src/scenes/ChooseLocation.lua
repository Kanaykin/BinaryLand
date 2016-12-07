require "src/scenes/BaseScene"
require "src/gui/ScrollView"
require "src/base/AlignmentHelper"
require "src/scenes/GameConfigs"
require "src/scenes/SoundConfigs"
require "src/base/Log"
require "src/gui/GuiHelper"
require "src/gui/TouchWidget"

local LOADSCEENIMAGE = "GlobalMapBack.png"
local GLOBALMAP = "GlobalMap.png"

--[[
start scene - loading screen
]]
ChooseLocation = inheritsFrom(BaseScene)
ChooseLocation.mScrollView = nil;
ChooseLocation.mBabyInTrapAnimations = nil
ChooseLocation.mNode = nil;

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

ChooseLocation.COUNT_STAR_LABEL_BEGIN = 90;
ChooseLocation.LOCK_IMAGE_TAG = 150;

ChooseLocation.BONUS_NODE = 500;
ChooseLocation.BONUS_MENU = 70;
ChooseLocation.BONUS_MENU_ITEM = 71;

local MovieText = "Пришло время помочь взрослым лисам вернуть своё потомство!"


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

    self.mBabyInTrapAnimations = {}
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
	ChooseLocation:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
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
end

--------------------------------
function ChooseLocation:updateCountStarLabels(node)
    for i = ChooseLocation.COUNT_STAR_LABEL_BEGIN, ChooseLocation.COUNT_STAR_LABEL_BEGIN + ChooseLocation.COUNT_LOCATION, 1 do
        local label = tolua.cast(node:getChildByTag(i + 1), "cc.Label");
        info_log("ChooseLocation:updateLabels label ", label);

        if label then
            setDefaultFont(label, self.mSceneManager.mGame:getScale());
            --label:setVisible(false);
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
function ChooseLocation:initGui(params)
    self:createGuiLayer();

    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("ChooseLocationUI", reader, false);
    self.mGuiLayer:addChild(node);

    local choseLevel = self;

    local function onReturnPressed()
    	info_log("onReturnPressed");
    	choseLevel.mSceneManager:runPrevScene();
    end

    setMenuCallback(node, ChooseLocation.BACK_MENU, ChooseLocation.BACK_MENU_ITEM, onReturnPressed);

    local layer = node:getChildByTag(ChooseLocation.TUTORIAL_FRAME);
    if layer then 
        if params and params.fromTutorial then
            local label = tolua.cast(layer:getChildByTag(ChooseLocation.LABEL_TAG), "cc.Label");
            info_log("ChooseLocation:loadScene label ", params );

            if label then
                setDefaultFont(label, game:getScale());
                label:setString(MovieText);
            end
        else
            layer:setVisible(false);
        end
    end
end

---------------------------------
function ChooseLocation:tick(dt)
    self:superClass().tick(self, dt);

    for key, anim in ipairs(self.mBabyInTrapAnimations) do
        anim:tick(dt);
    end
end

--------------------------------
function ChooseLocation:init(sceneMan, params)
	info_log("ChooseLocation:init ");
	self:superClass().init(self, sceneMan, params);

	-- init scene
	self:initScene();

	-- init gui
	self:initGui(params);

	SimpleAudioEngine:getInstance():playMusic(gSounds.CHOOSE_LOCATION_MUSIC, true)

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "ChooseLocation");
end
