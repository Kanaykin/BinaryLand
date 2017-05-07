require "src/base/Inheritance"
require "src/gui/GuiHelper"

ChooseLangButton = inheritsFrom(nil)
ChooseLangButton.mAnimator = nil;
ChooseLangButton.mBaseNode = nil;

ChooseLangButton.BASE_NODE_TAG = 10;
ChooseLangButton.SECOND_NODE_TAG = 20;
ChooseLangButton.CHOOSE_LANG_MENU_TAG = 70;
ChooseLangButton.CHOOSE_LANG_MENU_ITEM_TAG = 71;

ChooseLangButton.mOpened = false;
ChooseLangButton.mBlocked = false;

ChooseLangButton.mCurrentLangItem = nil; --"rus"
ChooseLangButton.mOtherLangItem = nil; --"usa"
ChooseLangButton.mGame = nil; --"usa"

-------------------------------------------------
function ChooseLangButton:init(button, animManager, game)
	self.mBaseNode = button;
	self.mAnimator = animManager;
	self.mGame = game;
	--self.mAnimator:runAnimationsForSequenceNamed("Open");

	local node = self.mBaseNode:getChildByTag(ChooseLangButton.BASE_NODE_TAG);
	debug_log("ChooseLangButton:init node ", node);


	local function onButtonPressed(val, val2)
    	self:onButtonPressed();
    end
	setMenuCallback(node, ChooseLangButton.CHOOSE_LANG_MENU_TAG, ChooseLangButton.CHOOSE_LANG_MENU_ITEM_TAG, onButtonPressed);
	self.mCurrentLangItem = getMenuItem(node, ChooseLangButton.CHOOSE_LANG_MENU_TAG, ChooseLangButton.CHOOSE_LANG_MENU_ITEM_TAG);

	function onFinishOpenAnimation()
    	self:onFinishOpenAnimation();
    end

    function onFinishCloseAnimation()
    	self:onFinishCloseAnimation();
    end

    local callFunc = CCCallFunc:create(onFinishOpenAnimation);
    self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:finish");

    local callFunc = CCCallFunc:create(onFinishCloseAnimation);
    self.mAnimator:setCallFuncForLuaCallbackNamed(callFunc, "0:finishClose");

    function onChangeLangPressed()
    	self:onChangeLangPressed();
    end
    local secondNode = node:getChildByTag(ChooseLangButton.SECOND_NODE_TAG);
    setMenuCallback(secondNode, ChooseLangButton.CHOOSE_LANG_MENU_TAG, ChooseLangButton.CHOOSE_LANG_MENU_ITEM_TAG, onChangeLangPressed);

    self.mOtherLangItem = getMenuItem(secondNode, ChooseLangButton.CHOOSE_LANG_MENU_TAG, ChooseLangButton.CHOOSE_LANG_MENU_ITEM_TAG);
    self:updateButtonImages();
end

-------------------------------------------------
function ChooseLangButton:updateButtonImages()
	local localizationManager = self.mGame:getLocalizationManager();
	local currLang = localizationManager:getCurrentLanguage();
	local rusButton = currLang == LocalizationManager.RUSSIAN_LANG and self.mCurrentLangItem or self.mOtherLangItem;
	local usaButton = currLang == LocalizationManager.ENGLISH_LANG and self.mCurrentLangItem or self.mOtherLangItem;
	changeMenuItemFrame(rusButton, "rus_normal.png", "rus_pressed.png");
	changeMenuItemFrame(usaButton, "usa_normal.png", "usa_pressed.png");
end

-------------------------------------------------
function ChooseLangButton:onChangeLangPressed()
	info_log("ChooseLangButton:onChangeLangPressed ");
	self.mAnimator:runAnimationsForSequenceNamed("Default Timeline");
	self.mOpened = false
	self.mBlocked = false;
	local localizationManager = self.mGame:getLocalizationManager();
	local currLang = localizationManager:getCurrentLanguage();
	local lang = currLang == LocalizationManager.ENGLISH_LANG and LocalizationManager.RUSSIAN_LANG or LocalizationManager.ENGLISH_LANG;
	localizationManager:setCurrentLanguage(lang);
	self:updateButtonImages();
end

-------------------------------------------------
function ChooseLangButton:onFinishCloseAnimation()
	info_log("ChooseLangButton onFinishCloseAnimation");
	self.mBlocked = false;
end

-------------------------------------------------
function ChooseLangButton:onFinishOpenAnimation()
	info_log("ChooseLangButton onFinishOpenAnimation");
	self.mBlocked = false;
end

-------------------------------------------------
function ChooseLangButton:close()
	if self.mOpened then
		self.mAnimator:runAnimationsForSequenceNamed("Close");
		self.mOpened = false
	end
end

-------------------------------------------------
function ChooseLangButton:onButtonPressed()
	info_log("ChooseLangButton onButtonPressed ");
	if self.mBlocked then
		return
	end 
	self.mBlocked = true;
	if not self.mOpened then
		self.mAnimator:runAnimationsForSequenceNamed("Open");
		self.mOpened = true
	else
		self.mAnimator:runAnimationsForSequenceNamed("Close");
		self.mOpened = false
	end
end
