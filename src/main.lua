require "Cocos2d"
require "Cocos2dConstants"
require "src/Game"

-- cclog
cclog = function(...)
print(string.format(...))
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
local function main()
	print("lua script started");

	local game = Game:create();
	game:init();
end
xpcall(main, __G__TRACKBACK__)