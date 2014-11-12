Callback = {}
Callback.__index = Callback

-----------------------------------
function Callback.new(obj, func)
	return setmetatable({ mObj = obj or 0, mFunc = func or 0 }, Callback)
end

-----------------------------------
function Callback.__call(a, ...)
    print("Callback.__call a.mObj ", a.mObj)
	return a.mFunc(a.mObj, ...);
end

setmetatable(Callback, { __call = function(_, ...) return Callback.new(...) end })

-----------------------------------
-----------------------------------

local func_example = setmetatable({callback = function() print("t.callback ", self.callback2) end}, {__index = function (t, k)
    t[k] = Callback.new(t, t.callback);
    print("add key ", k);
    t.nameFunc = k;
    return t[k];
end})

ListenerGlue = {}

local fallback_tbl = setmetatable(ListenerGlue, {__index = func_example})

-----------------------------------
function ListenerGlue.new(firstListener, secondListener)
return setmetatable({ mFirstListener = firstListener, mSecondListener = secondListener,
    callback = function(a1, var, ...)
        print("ListenerGlue.callback ", a1.mFirstListener)
        a1.mFirstListener[a1.nameFunc](a1.mFirstListener, ...);
        a1.mSecondListener[a1.nameFunc](a1.mSecondListener, ...);
    end
    }, {__index = function (t, k)
        t[k] = Callback.new(t, t.callback);
        t.nameFunc = k;
        print("add key ", k);
        return t[k];
end})
end

-----------------------------------
