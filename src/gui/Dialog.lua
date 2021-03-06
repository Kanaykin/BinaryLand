require "src/base/Inheritance"
require "src/base/Log"

BaseDialog = inheritsFrom(nil)

---------------------------------
function BaseDialog:show(scene)

	info_log("BaseDialog:show ", scene:getGuiLayer());

	local sprite = CCScale9Sprite:create("status_frame.png");
	sprite:setPreferredSize(cc.size(400,320));
	sprite:setInsetLeft(15);
	sprite:setInsetRight(15);
	sprite:setInsetTop(15);
	sprite:setInsetBottom(15);

	local closeButtonItem = CCMenuItemImage:create("close_button.png", "close_button_pressed.png");
	local closeButton = cc.Menu:createWithItem(closeButtonItem);

	local layer = scene:getGuiLayer();
	local function onCloseButtonPressed()
    	info_log("onCloseButtonPressed");
    	layer:removeChild(sprite, true);
    end

    closeButtonItem:registerScriptTapHandler(onCloseButtonPressed);

	sprite:addChild(closeButton);
	setPosition(closeButton, Coord(1.0, 1.0, 0, 0));

	scene:getGuiLayer():addChild(sprite);

	setPosition(sprite, Coord(0.5, 0.5, 0, 0));
end