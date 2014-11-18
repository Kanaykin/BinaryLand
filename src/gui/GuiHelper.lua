local DEFAULT_FONT = "res/fonts/Minecrafter.ttf";

GuiHelper = {

-----------------------------
getSpriteFrame = function(name, size)
    local cache = cc.SpriteFrameCache:getInstance();
    local frame = cache:getSpriteFrame(name);

    if not frame then
        print("getSpriteFrame not found frame ", name);
        local texture = cc.Director:getInstance():getTextureCache():addImage(name);
        frame = cc.SpriteFrame:createWithTexture(texture, size);
    end
    return frame;
end

}

-----------------------------
function setDefaultFont(label, scale)
    print("setDefaultFont scale ", scale);
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
	local settingsButton = nodeBase:getChildByTag(menuTag);
	if settingsButton then
		local settingsItem = settingsButton:getChildByTag(menuItemTag);
		
		settingsItem = tolua.cast(settingsItem, "cc.MenuItem");
		print("SettingsDlg:init ", settingsItem);
		if settingsItem then
    		settingsItem:registerScriptTapHandler(callback);
    	end
	end
end