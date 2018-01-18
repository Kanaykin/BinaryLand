require "src/gui/MessageBoxDlg"
require "src/base/Log"

WaitAdsDlg = inheritsFrom(MessageBoxDlg)
WaitAdsDlg.mStarsCount = nil
WaitAdsDlg.mMainUI = nil;
WaitAdsDlg.mPointTime = 0;
WaitAdsDlg.mDefaultText = "PleaseWaitText";

--------------------------------
function WaitAdsDlg:init(game, uiLayer, mainUI)
    WaitAdsDlg:superClass().init(self, game, uiLayer, "MessageBox");

    -- self:initGuiElements();
    self.mMainUI = mainUI;
    self.mPointTime = 0;
end

--------------------------------
function WaitAdsDlg:doModal(stars)
	local localizationManager = game:getLocalizationManager();
    self.mDefaultText = localizationManager:getStringForKey(WaitAdsDlg.mDefaultText);

    info_log("WaitAdsDlg:doModal ");
    local params = {};
    params.text = self.mDefaultText;
    params.cancel_callback = function() 
    	local advertisement = extend.Advertisement:getInstance();
    	advertisement:cancelADS();

    	self:hide();
    	self.mGame.mSceneMan:runNextLevelScene();
    end;
    params.cancel_text = localizationManager:getStringForKey("CancelText");
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
function WaitAdsDlg:updateText(dt)
	self.mPointTime = self.mPointTime + dt;
	local numbTime = math.floor(self.mPointTime);
	-- info_log("WaitAdsDlg:updateText numbTime ", numbTime);
	local countPoint = numbTime % 3 + 1;
	self:setText(self.mDefaultText .. string.rep(".", countPoint) .. string.rep(" ", (3 - countPoint)));

end

---------------------------------
function WaitAdsDlg:tick(dt)

	local advertisement = extend.Advertisement:getInstance();
	local status = advertisement:getStatusADS();

	-- info_log("WaitAdsDlg:tick status ", status);

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
    elseif status == 2 then -- LOADING(4)
    	self:updateText(dt);
	end
end

--------------------------------
-- function WaitAdsDlg:initGuiElements()
-- end