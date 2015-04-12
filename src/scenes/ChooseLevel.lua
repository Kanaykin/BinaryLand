require "src/scenes/BaseScene"
require "src/scenes/SoundConfigs"

ChooseLevel = inheritsFrom(BaseScene)
ChooseLevel.mCurLocation = nil;

ChooseLevel.BACK_MENU_TAG = 10;
ChooseLevel.BACK_MENU_ITEM_TAG = 11;
ChooseLevel.BASE_NODE_TAG = 1;

local LOADSCEENIMAGE = "Games_Duck_Hunt_Nintendo_Dendy_Nes_025749_32.jpg"

--------------------------------
function ChooseLevel:getCurLocation()
	return self.mCurLocation;
end

--------------------------------
function ChooseLevel:init(sceneMan, params)
	print("ChooseLevel:init ", params.location);
	self.mCurLocation = params.location;
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});

	self:initScene();

	self:initGui();

	SimpleAudioEngine:getInstance():playMusic(gSounds.CHOOSE_LEVEL_MUSIC, true)

    local statistic = extend.Statistic:getInstance();
    statistic:sendEvent("setScreenName", "ChooseLevel");
end

---------------------------------
function ChooseLevel:destroy()
	ChooseLevel:superClass().destroy(self);

	SimpleAudioEngine:getInstance():stopMusic(true);
end

--------------------------------
function ChooseLevel:initScene()
    local tileMap = cc.TMXTiledMap:create("ChoiceLevels1.tmx");
    local visibleSize = CCDirector:getInstance():getVisibleSize();
    tileMap:setAnchorPoint(cc.p(0.5, 0.5));
    tileMap:setPosition(cc.p(visibleSize.width / 2.0, visibleSize.height / 2.0));

	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("MainScene", reader, false);

    if tileMap then
        self.mSceneGame:addChild(tileMap);
    end
    self.mSceneGame:addChild(node);

    self:initChooseLevelButton(node);
    node = node:getChildByTag(ChooseLevel.BASE_NODE_TAG);

	local animator = reader:getActionManager();
    animator:retain();

	local arrayAnimator = reader:getAnimationManagersForNodes();
    print("ChooseLevel:initScene arrayAnimator ", arrayAnimator );

    table.sort(arrayAnimator, function(a, b)
		local animManagerA = tolua.cast(a, "cc.CCBAnimationManager");
		local animManagerB = tolua.cast(b, "cc.CCBAnimationManager");
        print("animManager:getRootNode() ", animManagerA:getRootNode():getTag());
        print("animManager:getRootNode() ", animManagerB:getRootNode():getTag());

        return animManagerA:getRootNode():getTag() < animManagerB:getRootNode():getTag();
    end)
	
    local minCount = (#arrayAnimator < #self.mCurLocation.mLevels) and #arrayAnimator or #self.mCurLocation.mLevels;

	for i = 1, minCount do
		local nameFrame = "0:frame"..i;

        print("nameFrame ", nameFrame);

		local animManager = tolua.cast(arrayAnimator[i + 1], "cc.CCBAnimationManager");

        print("animManager:getRootNode() ", animManager:getRootNode():getTag());

        local child = node:getChildByTag(i);
		self.mCurLocation.mLevels[i]:initVisual(animator, animManager, nameFrame, child);
	end

	animator:runAnimationsForSequenceNamed("Default Timeline");
end

---------------------------------
function ChooseLevel:tick(dt)
    for i, level in pairs(self.mCurLocation.mLevels) do
        level:tick(dt);
    end
end

--------------------------------
function ChooseLevel:initChooseLevelButton(nodeBase)
    local function onReturnPressed(val, val2)
        print("onReturnPressed");
        self.mSceneManager:runPrevScene();
    end

    setMenuCallback(nodeBase, ChooseLevel.BACK_MENU_TAG, ChooseLevel.BACK_MENU_ITEM_TAG, onReturnPressed);
end

--------------------------------
function ChooseLevel:initGui()
	local visibleSize = CCDirector:getInstance():getVisibleSize();
    
    self:createGuiLayer();

end