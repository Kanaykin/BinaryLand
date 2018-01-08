require "src/gui/MessageBoxDlg"
require "src/base/Log"

WaitAdsDlg = inheritsFrom(MessageBoxDlg)
WaitAdsDlg.mStarsCount = nil
WaitAdsDlg.mMainUI = nil;

--------------------------------
function WaitAdsDlg:init(game, uiLayer, mainUI)
    WaitAdsDlg:superClass().init(self, game, uiLayer, "MessageBox");

    -- self:initGuiElements();
    self.mMainUI = mainUI;
end

--------------------------------
function WaitAdsDlg:doModal(stars)
    info_log("WaitAdsDlg:doModal ");
    local params = {};
    params.text = "please wait";
    params.cancel_callback = function() 
    	local advertisement = extend.Advertisement:getInstance();
    	advertisement:cancelADS();

    	self:hide();
    	self.mGame.mSceneMan:runNextLevelScene();
    end;
    params.cancel_text = "cancel";
    WaitAdsDlg:superClass().doModal(self, params);

    self.mStarsCount = stars;
end

--------------------------------
function WaitAdsDlg:saveStars()
    local level = self.mGame.mSceneMan:getCurrentScene():getLevel();
    local location = level:getLocation();
    debug_log("WaitAdsDlg:saveStars  Location Id ", location:getId());
    debug_log("WaitAdsDlg:saveStars  level Id ", level:getIndex());
    self.mGame:setLevelStar(location:getId(), level:getIndex(), self.mStarsCount.allStar);
end

---------------------------------
function WaitAdsDlg:tick(dt)

	local advertisement = extend.Advertisement:getInstance();
	local status = advertisement:getStatusADS();

	info_log("WaitAdsDlg:doModal status ", status);

	if status == 3 then -- LOADED(3),
		self.mStarsCount.allStar = self.mStarsCount.allStar + 1;
        self:saveStars();
		self.mMainUI:showWinDlg(self.mStarsCount, true);
	elseif status == 4 then -- FAILED(4)
		self:hide();
        
        local localizationManager = self.mGame:getLocalizationManager();
        local text = localizationManager:getStringForKey(GetStarDlg.ErrorLoadingText);

        local message_params = {
            text = text,
            ok_text = "Ok",
            ok_callback = function()
                self.mGame.mSceneMan:runNextLevelScene();
            end
        };
        self.mMainUI:showMessageBox(message_params);

	end
end

--------------------------------
-- function WaitAdsDlg:initGuiElements()
-- end