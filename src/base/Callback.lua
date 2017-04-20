require "src/base/Log"

Callback = {}
Callback.__index = Callback

-----------------------------------
function unpack_arg(...)
	if _VERSION == 'Lua 5.1' then
		local arg = {}
		for i = 1, select("#",...) do
			arg[#arg+1] = select(i,...)
		end
		--info_log("Callback.new arg ", #arg)
		return arg
	else
		return arg
	end
end

-----------------------------------
function Callback.new(obj, func, ...)
	print(_VERSION)
	local arg = unpack_arg(...)
	return setmetatable({ mObj = obj or 0, mFunc = func or 0, mArgs = arg or {} }, Callback)
end

-----------------------------------
function Callback.__call(a, ...)
    --info_log("Callback.__call a.mObj ", a.mObj, " a.mArgs ", a.mArgs)
    local params = {}
	local arg = unpack_arg(...)
	for i,v in ipairs(arg) do
		table.insert(params, v)
	end
    for i,v in ipairs(a.mArgs) do
        table.insert(params, v)
    end
    params.n = #params
	return a.mFunc(a.mObj, unpack(params))
end

setmetatable(Callback, { __call = function(_, ...) return Callback.new(...) end })

-----------------------------------
-----------------------------------

local func_example = setmetatable({callback = function() info_log("t.callback ", self.callback2) end}, {__index = function (t, k)
    t[k] = Callback.new(t, t.callback);
    info_log("add key ", k);
    t.nameFunc = k;
    return t[k];
end})

ListenerGlue = {}

local fallback_tbl = setmetatable(ListenerGlue, {__index = func_example})

-----------------------------------
function ListenerGlue.new(firstListener, secondListener)
    debug_log("ListenerGlue.new firstListener ", firstListener, " secondListener ", secondListener);
    return setmetatable({ mFirstListener = firstListener, mSecondListener = secondListener,
    callback = function(a1, var, ...)
        info_log("ListenerGlue.callback ", a1.mFirstListener, " second ", a1.mSecondListener, " nameFunc ", a1.nameFunc)
        a1.mFirstListener[a1.nameFunc](a1.mFirstListener, ...);
        a1.mSecondListener[a1.nameFunc](a1.mSecondListener, ...);
    end
    }, {__index = function (t, k)
        t[k] = Callback.new(t, t.callback);
        t.nameFunc = k;
        info_log("add key ", k);
        return t[k];
end})
end

-----------------------------------
