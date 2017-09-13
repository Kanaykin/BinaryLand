require "src/animations/Animation"
require "src/base/Log"
require "src/base/Utils"

EmptyAnimation = inheritsFrom(IAnimation)
EmptyAnimation.mTexture = nil;
EmptyAnimation.mAnchor = nil;
EmptyAnimation.mNode = nil;
EmptyAnimation.mFrame = nil;
EmptyAnimation.mTextureSize = nil;

--------------------------------
function EmptyAnimation:init(texture, node, anchor)
	self.mNode = node;
	self.mTexture = texture;
	self.mAnchor = anchor;
	self.mTextureSize = self.mNode:getContentSize();
    if texture then
        self.mTextureSize = texture:getContentSize();
    end
	--info_log("EmptyAnimation:init ", self.mTextureSize.width, ", ", self.mTextureSize.height);
end

--------------------------------
function EmptyAnimation:setFrame(frame)
	--debug_log("EmptyAnimation:setFrame ", frame);
	self.mFrame = frame
end

--------------------------------
function EmptyAnimation:getAction()
	return nil;
end

--------------------------------
function EmptyAnimation:setAnchor(anchor)
    self.mAnchor = anchor;
end

--------------------------------
function EmptyAnimation:getNode()
	return self.mNode;
end

---------------------------------
function EmptyAnimation:isDone()
	return true;
end

---------------------------------
function EmptyAnimation:pause()
	--local className = utils.getfield(self:class());
	--debug_log("EmptyAnimation:pause ", className);
	--if className ~= "EmptyAnimation" then
	--	self:assert()
	--end
end

----------------------------
function EmptyAnimation:play()
	--debug_log("EmptyAnimation:play ", self.mFrame);
	if self.mAnchor then
		self.mNode:setAnchorPoint(self.mAnchor);
	end
	if self.mFrame then
		--info_log("EmptyAnimation:play self.mFrame ", self.mFrame);
		tolua.cast(self.mNode, "cc.Sprite"):setTexture(nil);
		tolua.cast(self.mNode, "cc.Sprite"):setSpriteFrame(self.mFrame);
		--tolua.cast(self.mNode, "cc.Sprite"):setTextureRect(cc.rect(0, 0, self.mTextureSize.width, self.mTextureSize.height));
	elseif self.mTexture then
		--info_log("EmptyAnimation:play self.mNode ", self.mNode);
		--info_log("EmptyAnimation:play self.mTextureSize ", self.mTextureSize.width);
		tolua.cast(self.mNode, "cc.Sprite"):setTexture(self.mTexture);
		tolua.cast(self.mNode, "cc.Sprite"):setTextureRect(cc.rect(0, 0, self.mTextureSize.width, self.mTextureSize.height));
	end
end
