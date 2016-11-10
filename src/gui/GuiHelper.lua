require "src/base/Log"

local DEFAULT_FONT = "res/fonts/UpheavalPro.ttf"--"res/fonts/Minecrafter.ttf";

GuiHelper = {

-----------------------------
getSpriteFrame = function(name, size)
    local cache = cc.SpriteFrameCache:getInstance();
    local frame = cache:getSpriteFrame(name);

    if not frame then
        --info_log("getSpriteFrame not found frame ", name);
        local texture = cc.Director:getInstance():getTextureCache():addImage(name);
        frame = cc.SpriteFrame:createWithTexture(texture, size);
    end
    return frame;
end,

-----------------------------
updateScale9SpriteByScale = function(widget, scale)
    info_log("updateScale9SpriteByScale (", widget, ", ", scale, ")");
    local widget9Sprite = tolua.cast(widget, "ccui.Scale9Sprite");
    info_log("updateScale9SpriteByScale widget9Sprite ", widget9Sprite);
    widget9Sprite:setInsetRight(widget9Sprite:getInsetRight() * scale);
    widget9Sprite:setInsetLeft(widget9Sprite:getInsetLeft() * scale);
    widget9Sprite:setInsetTop(widget9Sprite:getInsetTop() * scale);
    widget9Sprite:setInsetBottom(widget9Sprite:getInsetBottom() * scale);
end

}

-----------------------------
function setDefaultFont(label, scale)
    info_log("setDefaultFont scale ", scale);
    local config = label:getTTFConfig();
    config.fontFilePath = DEFAULT_FONT;
    config.fontSize = label:getSystemFontSize();
    if scale then
        config.fontSize = config.fontSize * scale / 2;
    end
    label:setTTFConfig(config);
end

-----------------------------
function changeMenuItemFrame(menuItem, name_normal, name_pressed)
    local frame_normal = GuiHelper.getSpriteFrame(name_normal, menuItem:getContentSize());
    local frame_pressed = GuiHelper.getSpriteFrame(name_pressed, menuItem:getContentSize());
    menuItem:setNormalSpriteFrame(frame_normal);
    menuItem:setSelectedSpriteFrame(frame_pressed);
end

-----------------------------
function getMenuItem(nodeBase, menuTag, menuItemTag)
	local settingsButton = nodeBase:getChildByTag(menuTag);
    if settingsButton then
        local settingsItem = settingsButton:getChildByTag(menuItemTag);

        settingsItem = tolua.cast(settingsItem, "cc.MenuItemImage");
        return settingsItem;
    end
    return nil;
end

-----------------------------
function setMenuCallback(nodeBase, menuTag, menuItemTag, callback)
    debug_log("setMenuCallback menuTag ", menuTag, " menuItemTag ", menuItemTag);
	local settingsButton = nodeBase:getChildByTag(menuTag);
	if settingsButton then
		local settingsItem = settingsButton:getChildByTag(menuItemTag);
		
		settingsItem = tolua.cast(settingsItem, "cc.MenuItem");
		info_log("setMenuCallback ", settingsItem);
		if settingsItem then
    		settingsItem:registerScriptTapHandler(callback);
    	end
	end
end
