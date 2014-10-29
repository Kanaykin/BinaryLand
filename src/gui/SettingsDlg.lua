require "src/gui/CCBBaseDlg"
require "src/gui/GuiHelper"

SettingsDlg = inheritsFrom(CCBBaseDialog)

SettingsDlg.mAnimator = nil;
SettingsDlg.BASE_NODE_TAG = 49;
SettingsDlg.BACK_MENU_TAG = 50;
SettingsDlg.BACK_MENU_ITEM_TAG = 51;
SettingsDlg.CHOOSE_LEVEL_MENU_TAG = 60;
SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG = 61;
SettingsDlg.REPLAY_MENU_TAG = 70;
SettingsDlg.REPLAY_MENU_ITEM_TAG = 71;
SettingsDlg.INTERACTIVE_PANEL = 80;
SettingsDlg.SOUND_MENU_TAG = 10;
SettingsDlg.SOUND_MENU_ITEM_TAG = 11;
SettingsDlg.MUSIC_MENU_TAG = 20;
SettingsDlg.MUSIC_MENU_ITEM_TAG = 21;
SettingsDlg.mAnimator = nil;
SettingsDlg.mSoundButton = nil;
SettingsDlg.mMusicButton = nil;

--------------------------------
function SettingsDlg:doModal()
	self:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function SettingsDlg:hidePanel()
	print("SettingsDlg:hidePanel");
	function callback()
		print("SettingsDlg:callback");
		self.mGame.mDialogManager:deactivateModal(self);
	end

	local callFunc = CCCallFunc:create(callback);
	self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

	self.mAnimator:runAnimationsForSequenceNamed("Hide");
end

--------------------------------
function SettingsDlg:updateSoundButton()
    if not self.mGame:getSoundEnabled() then
        changeMenuItemFrame(self.mSoundButton, "sound_dis_normal.png", "sound_dis_pressed.png");
    else
        changeMenuItemFrame(self.mSoundButton, "sound_normal.png", "sound_pressed.png");
    end

end

--------------------------------
function SettingsDlg:initSoundButton(nodeBase)
    self.mSoundButton = getMenuItem(nodeBase, SettingsDlg.SOUND_MENU_TAG, SettingsDlg.SOUND_MENU_ITEM_TAG);
    self:updateSoundButton();

    local function onSoundButtonPressed(val, val2)
        print("onSoundButtonPressed ");
        self.mGame:setSoundEnabled(not self.mGame:getSoundEnabled());
        self:updateSoundButton();
    end

    setMenuCallback(nodeBase, SettingsDlg.SOUND_MENU_TAG, SettingsDlg.SOUND_MENU_ITEM_TAG, onSoundButtonPressed);
end

--------------------------------
function SettingsDlg:updateMusicButton()
    if not self.mGame:getMusicEnabled() then
        changeMenuItemFrame(self.mMusicButton, "music_dis_normal.png", "music_dis_pressed.png");
    else
        changeMenuItemFrame(self.mMusicButton, "music_normal.png", "music_pressed.png");
    end
end

--------------------------------
function SettingsDlg:initMusicButton(nodeBase)
    self.mMusicButton = getMenuItem(nodeBase, SettingsDlg.MUSIC_MENU_TAG, SettingsDlg.MUSIC_MENU_ITEM_TAG);
    self:updateMusicButton();

    local function onMusicButtonPressed(val, val2)
        print("onMusicButtonPressed ");
        self.mGame:setMusicEnabled(not self.mGame:getMusicEnabled());
        self:updateMusicButton();
    end

    setMenuCallback(nodeBase, SettingsDlg.MUSIC_MENU_TAG, SettingsDlg.MUSIC_MENU_ITEM_TAG, onMusicButtonPressed);
end

--------------------------------
function SettingsDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	print("onReplayButtonPressed ");
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, SettingsDlg.REPLAY_MENU_TAG, SettingsDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function SettingsDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	print("onChooseLevelPressed ");
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, SettingsDlg.CHOOSE_LEVEL_MENU_TAG, SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function SettingsDlg:initHideButton(nodeBase)
	local function onPanelHidePressed(val, val2)
    	print("onPanelHidePressed ");
    	self:hidePanel();
    end

    setMenuCallback(nodeBase, SettingsDlg.BACK_MENU_TAG, SettingsDlg.BACK_MENU_ITEM_TAG, onPanelHidePressed);
end

--------------------------------
function SettingsDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(SettingsDlg.BASE_NODE_TAG);
	print("SettingsDlg:initGuiElements nodeBase ", nodeBase );
	
	if not nodeBase then
		return;
	end

	local panel = nodeBase:getChildByTag(SettingsDlg.INTERACTIVE_PANEL);
	if panel then
		self:setTouchBBox(panel:getBoundingBox());
	end

	self:initHideButton(nodeBase);
	self:initReplayButton(nodeBase);
	self:initChooseLevelButton(nodeBase);
    self:initSoundButton(nodeBase);
    self:initMusicButton(nodeBase);
end

--------------------------------
function SettingsDlg:init(game, uiLayer)
	self:superClass().init(self, game, uiLayer, "SettingsDlg");

	self:initGuiElements();

	self.mAnimator = self.mReader:getActionManager();
	--local arrayAnimator = self.mReader:getAnimationManagersForNodes();

	print("SettingsDlg:init ", self.mAnimator);
end