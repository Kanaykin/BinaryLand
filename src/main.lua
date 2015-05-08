require "Cocos2d"
require "Cocos2dConstants"
require "src/Game"
require "src/base/Log"

-- cclog
cclog = function(...)
error_log(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
cclog("----------------------------------------")
cclog("LUA ERROR: " .. tostring(msg) .. "\n")
cclog(debug.traceback())
cclog("----------------------------------------")
return msg
end

-----------------------------------------------
_G.onBackPressed = function()
    info_log("onBackPressed ");
    return game:onBackPressed();
end

-----------------------------------------------
local function main()
	info_log("lua script started");

	game = Game:create();
	game:init();
end
xpcall(main, __G__TRACKBACK__)