require "src/scenes/BaseScene"
require "src/math/Rect"
require "src/base/Log"

ScrollView = inheritsFrom(nil)
ScrollView.mScroll = nil;
ScrollView.mClickableChildren = nil;
-- private members. don't use it on the outside
ScrollView.mIsMoved = false;
ScrollView.mPointBegan = nil;

------------------------------
function ScrollView:addChild(child)
	self.mScroll:addChild(child);
end

------------------------------
function ScrollView:findChildByPoint(point)
	for i, childinfo in ipairs(self.mClickableChildren) do
		local child = childinfo[1];
		info_log("i ", i, "child ", table.getn(self.mClickableChildren));
		local xPos, yPos = child:getPosition();
		local size = child:getContentSize();
		local bbox = Rect.new(child:getBoundingBox());
		if bbox:containsPoint(point) then
			return childinfo;
		end
	end
	return nil;
end

------------------------------
function ScrollView:onTouchHandler(action, position)
    info_log("ScrollView:onTouchHandler ", position.x)
	local offset = self.mScroll:getContentOffset();
    if action == "began" then
    	self.mIsMoved = false;
    	self.mPointBegan = Vector.new(position.x, position.y);
    elseif action == "moved" then
    	local newPos = Vector.new(position.x, position.y);
    	if (newPos - self.mPointBegan):len() > 2 then
    		self.mIsMoved = true;
    	end
    elseif action == "ended" and not self.mIsMoved then
    	local locinfo = self:findChildByPoint(cc.p(position.x - offset.x, position.y - offset.y ));
    	if(locinfo ~= nil) then
    		locinfo[2][locinfo[3]](locinfo[2]);
    	end
    end
end

------------------------------
function ScrollView:setTouchEnabled(enable)
	self.mScroll:setTouchEnabled(enable);
end

------------------------------
function ScrollView:setContentOffset(offset)
	self.mScroll:setContentOffset(offset);
end

------------------------------
function ScrollView:setClickable(clickable)
	local scrollviewlayer = self.mScroll:getContainer();
	local scrollView = self;
	if clickable then
		--------------------
		local function onTouchHandler(action, var1, var2)
            if not var1 or not var2 then
                return false;
            end
			info_log("onTouchHandler ", action, "var1 ", var, "var2 ", var2);
			info_log("onTouchHandler ", action, "x = ", var1, " y = ", var2);
    		scrollView:onTouchHandler(action, cc.p(var1, var2));
    		return true;
    	end
        --------------------
        local function onKeypadHandler(action, var1, var2)
			info_log("onKeypadHandler ", action, "var1 ", var, "var2 ", var2);
        end

    	scrollviewlayer:registerScriptTouchHandler(onTouchHandler, false, 1, false);
        scrollviewlayer:registerScriptKeypadHandler(onKeypadHandler);
	else
		scrollviewlayer:unregisterScriptTouchHandler();
	end
	info_log("ScrollView:setClickable (", clickable);
	scrollviewlayer:setTouchEnabled(clickable);
end

------------------------------
function ScrollView:addClickableChild(child, obj, callback)
	self.mScroll:addChild(child);
	table.insert(self.mClickableChildren, {child, obj, callback});
end

------------------------------
function ScrollView:initLayers(layers)
	local visibleSize = CCDirector:getInstance():getVisibleSize();
	local scrollviewlayer = CCLayer:create();

	-- compute size
	local height = 0;
	for i, layer in ipairs(layers) do
		local layerSize = layer:getContentSize();
        info_log("ScrollView:initLayers layerSize.height ", layerSize.height)
		height = height + layerSize.height;
	end

	scrollviewlayer:setContentSize(cc.size(visibleSize.width, height));

	self.mScroll = CCScrollView:create(cc.size(visibleSize.width, visibleSize.height), scrollviewlayer);
	self.mScroll:setBounceable(false);
	self.mScroll:setZoomScale(3.0, false);

	local layersOffset = 0;
	for i, layer in ipairs(layers) do
		scrollviewlayer:addChild(layer);

		local layerSize = layer:getContentSize();
		info_log("ScrollView:initLayers height ", layerSize.height);
		local posX, posY = layer:getPosition();
		info_log("ScrollView:initLayers posX ", posX);
		layer:setPosition(posX, posY + layersOffset);
		layersOffset = layersOffset + layerSize.height;
	end
end

------------------------------
function ScrollView:init(sizeScale, images)
	self.mClickableChildren = {};
	local visibleSize = CCDirector:getInstance():getVisibleSize();
	local scrollviewlayer = CCLayer:create();
	scrollviewlayer:setContentSize(cc.size(visibleSize.width * sizeScale.width, visibleSize.height * sizeScale.height));

	self.mScroll = CCScrollView:create(cc.size(visibleSize.width, visibleSize.height), scrollviewlayer);
	self.mScroll:setBounceable(false);
	self.mScroll:setZoomScale(3.0, false);

	local textureOffset = 0;
	-- add images to view scroll
	for i, imageName in ipairs(images) do
		local sp1 = CCSprite:create(imageName);
		info_log("sp1 ", sp1, " name ", imageName);
		if not sp1 then 
			break;
		end
		scrollviewlayer:addChild(sp1);
		local imageSize = sp1:getContentSize();
		local scale = visibleSize.height / imageSize.height;
		sp1:setPosition(textureOffset + imageSize.width / 2 * scale, visibleSize.height / 2);
		textureOffset = textureOffset + imageSize.width * scale;
		sp1:setScaleY(scale);
		sp1:setScaleX(scale);
	end

end
