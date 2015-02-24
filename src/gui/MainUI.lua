require "src/gui/CCBBaseDlg"
require "src/gui/SettingsDlg"
require "src/gui/GuiHelper"
require "src/gui/YouLooseDlg"
require "src/gui/YouWinDlg"
require "src/gui/LevelTimer"
require "src/gui/LevelScore"
require "src/gui/GettingBonusEffect"

MainUI = inheritsFrom(CCBBaseDialog)

MainUI.mJoystick = nil;
MainUI.mFightButton = nil;
MainUI.mSettingsDlg = nil;
MainUI.mYouLooseDlg = nil;
MainUI.mYouWinDlg = nil;
MainUI.mTimeLabel = nil;
MainUI.mTimer = nil;
MainUI.mScore = nil;
MainUI.mListener = nil;
MainUI.mEffects = nil;

MainUI.SETTINGS_MENU_TAG = 50;
MainUI.SETTINGS_MENU_ITEM_TAG = 51;
MainUI.TIMER_TAG = 52;
MainUI.SCORE_TAG = 53;

MainUI.MAIN_LAYER_TAG = 1;

--------------------------------
function MainUI:getJoystick()
	return self.mJoystick;
end

--------------------------------
function MainUI:getFightButton()
	return self.mFightButton;
end

--------------------------------
function MainUI:destroy()
	print("MainUI:destroy");
	self.mSettingsDlg:destroy();
	self.mYouLooseDlg:destroy();
	self.mYouWinDlg:destroy();

	self:superClass().destroy(self);
end

--------------------------------
function MainUI:onSettingsButtonPressed(val, val2)
	print("onSettingsButtonPressed ", val, val2);

	self.mSettingsDlg:doModal();
end

---------------------------------
function MainUI:onStateLose()
	self.mYouLooseDlg:doModal();
end

---------------------------------
function MainUI:onStateWin()
	self.mJoystick:release();
	self.mYouWinDlg:doModal();
end

--------------------------------
function MainUI:getTouchListener()
    return self.mListener;
end

--------------------------------
function MainUI:createGettingBonus(position, bonus)
    local gettingBonus = GettingBonusEffect:create();
    print("MainUI:createGettingBonus gettingBonus ", gettingBonus);
    gettingBonus:init(self.mGame, self.mUILayer, bonus);
    gettingBonus:getNode():setPosition(cc.p(position.x, position.y));
    gettingBonus:show();

    self.mEffects[#self.mEffects + 1] = gettingBonus
end

--------------------------------
function MainUI:onTouchHandler(action, var)
    return self.mListener:onTouchHandler(action, var);
end

--------------------------------
function MainUI:removeListener(listener)
    if self.mListener == listener then
        self.mListener = nil;
    else
        if self.mListener.mFirstListener == listener then
            self.mListener = self.mListener.mSecondListener;
        elseif self.mListener.mSecondListener == listener then
            self.mListener = self.mListener.mFirstListener;
        end
    end
end

--------------------------------
function MainUI:addTouchListener(listener)
    if self.mListener then
        local newListener = ListenerGlue.new(self.mListener, listener);
        self.mListener = newListener;
    else
        self.mListener = listener;
    end
end

--------------------------------
function MainUI:setTouchListener(listener)
    self.mListener = listener;
end

--------------------------------
function MainUI:setTimerEnabled(val)
    self.mTimer:setVisible(val);
end

--------------------------------
function MainUI:setTimerInitValue(value)
    self.mTimer:setTimerInitValue(value);
end

--------------------------------
function MainUI:setTime(time)
    self.mTimer:setTime(time);
end

---------------------------------
function MainUI:tick(dt)
    local i=1;
    while i <= #self.mEffects do
        if self.mEffects[i]:finished() then
            print("MainUI: remove effect i ", i);
            table.remove(self.mEffects, i)
        else
            i = i + 1
        end
    end
end

--------------------------------
function MainUI:setScore(score)
    self.mScore:setValue(score);
end

--------------------------------
function MainUI:init(game, uiLayer, ccbFile)
	self:superClass().init(self, game, uiLayer, ccbFile);

    self.mEffects = {}

	self.mJoystick = Joystick:create();
	self.mJoystick:init(self.mNode);

	self.mFightButton = FightButton:create();
	self.mFightButton:init(self.mNode);

	local function onSettingsButtonPressed(val, val2)
    	self:onSettingsButtonPressed(val, val2);
    end
	setMenuCallback(self.mNode, MainUI.SETTINGS_MENU_TAG, MainUI.SETTINGS_MENU_ITEM_TAG, onSettingsButtonPressed);

	-------------------------
	self.mSettingsDlg = SettingsDlg:create();
	self.mSettingsDlg:init(self.mGame, self.mUILayer);

	-------------------------
	self.mYouLooseDlg = YouLooseDlg:create();
	self.mYouLooseDlg:init(self.mGame, self.mUILayer);

	-------------------------
	self.mYouWinDlg = YouWinDlg:create();
	self.mYouWinDlg:init(self.mGame, self.mUILayer);

	-------------------------
    self.mTimer = LevelTimer:create();
    self.mTimer:init(self.mNode:getChildByTag(MainUI.TIMER_TAG), game);
    self.mTimer:setVisible(false);
    -------------------------

    self.mScore = LevelScore:create();
    self.mScore:init(self.mNode:getChildByTag(MainUI.SCORE_TAG), game);
    -------------------------

    local function onTouchHandler(action, var)
        print("MainUI:onTouchHandler ", action, "self.mListener ", self.mListener);
        return self:onTouchHandler(action, var);
    end

    local layer = tolua.cast(self.mNode:getChildByTag(MainUI.MAIN_LAYER_TAG), "cc.Layer");
    if layer then
        layer:registerScriptTouchHandler(onTouchHandler, true, 2, false);
        layer:setTouchEnabled(true);
    else
        print("ERROR: MainUI:setTouchListener not found layer !!!");
    end
end
