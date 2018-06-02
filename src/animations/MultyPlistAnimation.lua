require "src/animations/PlistAnimation"

MultyPlistAnimation = inheritsFrom(PlistAnimation)

--------------------------------
function MultyPlistAnimation:init(plistName, node, anchor, texture, delayPerUnit, count)

	PlistAnimation:superClass().init(self, texture, node, anchor);

    if not delayPerUnit then
        delayPerUnit = 1 / 10;
    end

    local arrayFrames = {}
    for i = 0, count do
    	local name = string.gsub(plistName, "{n}", tostring(i));
    	debug_log("MultyPlistAnimation:init " .. name);

    	self:loadFramesFromFile(name, arrayFrames);
    end

   	table.sort( arrayFrames, function(x, y)
   		return y > x;
   	end );

   	local cache = cc.SpriteFrameCache:getInstance();
    
    self.mAnimation = cc.Animation:create();
    self.mLastFrame = cache:getSpriteFrame(arrayFrames[#arrayFrames]);
    for i, val in ipairs(arrayFrames) do
   		local frame = cache:getSpriteFrame(val);
   		--info_log("PlistAnimation frame ", frame);
   		self.mAnimation:addSpriteFrame(frame);
      if not texture and i == 1 then
        self:setFrame(frame);
      end
   	end

    self.mAnimation:setDelayPerUnit(delayPerUnit);
    self.mAnimation:setRestoreOriginalFrame(true);

    local action = cc.Animate:create(self.mAnimation);
    self.mAction = action;--CCActionInterval:create(action, 1);
    self.mAction:retain();
end
