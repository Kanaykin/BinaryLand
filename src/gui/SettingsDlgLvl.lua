require "src/gui/SettingsDlg"


SettingsDlgLvl = inheritsFrom(SettingsDlg)

--------------------------------
function SettingsDlgLvl:init(game, uiLayer)
	SettingsDlgLvl:superClass().init(self, game, uiLayer, "SettingsDlgLvl");

	info_log("SettingsDlgLvl:init ");
end

--------------------------------
function SettingsDlgLvl:initChooseLevelButton(nodeBase)
    local function onHomePressed(val, val2)
        info_log("onHomePressed ");
        self.mGame.mSceneMan:runPrevScene();
    end

    setMenuCallback(nodeBase, SettingsDlg.CHOOSE_LEVEL_MENU_TAG, SettingsDlg.CHOOSE_LEVEL_MENU_ITEM_TAG, onHomePressed);
end