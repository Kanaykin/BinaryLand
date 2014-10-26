require "src/scenes/BaseScene"
require "src/scenes/SoundConfigs"

ChooseLevel = inheritsFrom(BaseScene)
ChooseLevel.mCurLocation = nil;
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

	SimpleAudioEngine:sharedEngine():playMusic(gSounds.CHOOSE_LEVEL_MUSIC, true)
end

---------------------------------
function ChooseLevel:destroy()
	ChooseLevel:superClass().destroy(self);

	SimpleAudioEngine:sharedEngine():stopMusic(true);
end

--------------------------------
function ChooseLevel:initScene()
	local ccpproxy = CCBProxy:create();
	local reader = ccpproxy:createCCBReader();
	local node = ccpproxy:readCCBFromFile("MainScene", reader, false);

    self.mSceneGame:addChild(node);

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

--------------------------------
function ChooseLevel:initGui()
	local visibleSize = CCDirector:getInstance():getVisibleSize();
    
    self:createGuiLayer();

	-- play button
	local menuToolsItem = CCMenuItemImage:create("back_normal.png", "back_pressed.png");
    menuToolsItem:setPosition(- visibleSize.width / 3, - visibleSize.height / 3);

    local choseLevel = self;

    local function onReturnPressed()
    	print("onReturnPressed");
    	choseLevel.mSceneManager:runPrevScene();
    end

    menuToolsItem:registerScriptTapHandler(onReturnPressed);

    local menuTools = cc.Menu:createWithItem(menuToolsItem);
    
    self.mGuiLayer:addChild(menuTools);
end