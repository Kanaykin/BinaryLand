require "src/animations/Animation"
require "src/base/Log"

EmptyAnimation = inheritsFrom(IAnimation)
EmptyAnimation.mTexture = nil;
EmptyAnimation.mAnchor = nil;
EmptyAnimation.mNode = nil;
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
	info_log("EmptyAnimation:init ", self.mTextureSize.width, ", ", self.mTextureSize.height);
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

----------------------------
function EmptyAnimation:play()
	if self.mAnchor then
		self.mNode:setAnchorPoint(self.mAnchor);
	end
	if self.mTexture then
		info_log("EmptyAnimation:play self.mNode ", self.mNode);
		info_log("EmptyAnimation:play self.mTextureSize ", self.mTextureSize.width);
		tolua.cast(self.mNode, "cc.Sprite"):setTexture(self.mTexture);
		tolua.cast(self.mNode, "cc.Sprite"):setTextureRect(cc.rect(0, 0, self.mTextureSize.width, self.mTextureSize.height));
	end
end