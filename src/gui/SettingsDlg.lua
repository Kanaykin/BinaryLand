require "src/gui/CCBBaseDlg"
require "src/gui/GuiHelper"
require "src/gui/ChooseLangButton"
require "src/base/Log"

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
SettingsDlg.CHOOSE_LANG_BUTTON_TAG = 30;

SettingsDlg.mAnimator = nil;
SettingsDlg.mSoundButton = nil;
SettingsDlg.mMusicButton = nil;
SettingsDlg.mChooseLangButton = nil;

--------------------------------
function SettingsDlg:doModal()
	SettingsDlg:superClass().doModal(self);
	self.mAnimator:runAnimationsForSequenceNamed("Show");
end

--------------------------------
function SettingsDlg:hidePanel()
	info_log("SettingsDlg:hidePanel");
	function callback()
		info_log("SettingsDlg:callback");
        self:hide();
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
        info_log("onSoundButtonPressed ");
        self.mGame:setSoundEnabled(not self.mGame:getSoundEnabled());
        self:updateSoundButton();
        self.mChooseLangButton:close();
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
        info_log("onMusicButtonPressed ");
        self.mGame:setMusicEnabled(not self.mGame:getMusicEnabled());
        self:updateMusicButton();
        self.mChooseLangButton:close();
    end

    setMenuCallback(nodeBase, SettingsDlg.MUSIC_MENU_TAG, SettingsDlg.MUSIC_MENU_ITEM_TAG, onMusicButtonPressed);
end

--------------------------------
function SettingsDlg:initReplayButton(nodeBase)
	local function onReplayButtonPressed(val, val2)
    	info_log("onReplayButtonPressed ");
        self.mChooseLangButton:close();
    	self.mGame.mSceneMan:replayScene();
    end

    setMenuCallback(nodeBase, SettingsDlg.REPLAY_MENU_TAG, SettingsDlg.REPLAY_MENU_ITEM_TAG, onReplayButtonPressed);
end

--------------------------------
function SettingsDlg:initChooseLevelButton(nodeBase)
	local function onChooseLevelPressed(val, val2)
    	info_log("onChooseLevelPressed ");
        self.mChooseLangButton:close();
    	self.mGame.mSceneMan:runPrevScene({location = self.mGame.mSceneMan:getCurrentScene():getLevel():getLocation()});
    end

    setMenuCallback(nodeBase, SettingsDlg.CHOOSE_LEVEL_MENU_TAG, SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onChooseLevelPressed);
end

--------------------------------
function SettingsDlg:initHideButton(nodeBase)
	local function onPanelHidePressed(val, val2)
    	info_log("onPanelHidePressed ");
        self.mChooseLangButton:close();
    	self:hidePanel();
    end

    setMenuCallback(nodeBase, SettingsDlg.BACK_MENU_TAG, SettingsDlg.BACK_MENU_ITEM_TAG, onPanelHidePressed);
end

--------------------------------
function SettingsDlg:initChooseLangButton(nodeBase)
    local button = nodeBase:getChildByTag(SettingsDlg.CHOOSE_LANG_BUTTON_TAG);
    
    local arrayAnimator = self.mReader:getAnimationManagersForNodes();
    local animManager = nil;
    for i = 1, #arrayAnimator do
        local manager = tolua.cast(arrayAnimator[i], "cc.CCBAnimationManager");
        if button == manager:getRootNode() then
            animManager = manager;
            break;
        end
    end
    debug_log("SettingsDlg:initChooseLangButton count ", animManager);
    self.mChooseLangButton = ChooseLangButton:create();
    self.mChooseLangButton:init(button, animManager, self.mGame);
end

--------------------------------
function SettingsDlg:initGuiElements()
	local nodeBase = self.mNode:getChildByTag(SettingsDlg.BASE_NODE_TAG);
	info_log("SettingsDlg:initGuiElements nodeBase ", nodeBase );
	
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
    self:initMusicButton(nodeBase);
    self:initSoundButton(nodeBase);
    self:initChooseLangButton(nodeBase);
end

--------------------------------
function SettingsDlg:init(game, uiLayer, ccbFile)
    local ccbFile = ccbFile and ccbFile or "SettingsDlg";
	SettingsDlg:superClass().init(self, game, uiLayer, ccbFile);

    self.mAnimator = self.mReader:getActionManager();
	self:initGuiElements();

	info_log("SettingsDlg:init ", self.mAnimator);
end