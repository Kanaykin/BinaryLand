require "src/base/Inheritance"
require "src/base/Utils"

IAnimation = inheritsFrom(nil)

----------------------------
function IAnimation:play()
end

----------------------------
function IAnimation:stop()
end

----------------------------
function IAnimation:currentAnimation()
    return self;
end

---------------------------------
function IAnimation:destroy()
	
end

---------------------------------
function IAnimation:pause()
--	debug_log("IAnimation:pause ", utils.getfield(self:class()));
--	self:assert()
end

---------------------------------
function IAnimation:isDone()
	
end

--------------------------------
function IAnimation:tick(dt)
end
