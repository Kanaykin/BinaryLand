require "src/base/Inheritance"

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
function IAnimation:isDone()
	
end

--------------------------------
function IAnimation:tick(dt)
end
