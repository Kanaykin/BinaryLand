require "src/base/Inheritance"

FoxHelpEffect = inheritsFrom(nil)
FoxHelpEffect.mAnchorBaseNode = nil;
FoxHelpEffect.mBubbleSprite = nil;
FoxHelpEffect.mLabel = nil;
FoxHelpEffect.mBaseNode = nil;
FoxHelpEffect.mGame = nil;
FoxHelpEffect.mDependAnimation = nil;

FoxHelpEffect.BUBBLE_NODE_TAG = 10;
FoxHelpEffect.BASE_NODE_TAG = 11;
FoxHelpEffect.LABEL_TAG = 12;

--------------------------------
function FoxHelpEffect:init(node, game)
    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local nodeCCB = ccpproxy:readCCBFromFile("FoxHelpEffect", reader, false);

    node:addChild(nodeCCB);

    self.mBaseNode = nodeCCB:getChildByTag(FoxHelpEffect.BASE_NODE_TAG);
    self.mAnchorBaseNode = self.mBaseNode:getAnchorPoint();

    self.mBubbleSprite = tolua.cast(self.mBaseNode:getChildByTag(FoxHelpEffect.BUBBLE_NODE_TAG), "cc.Sprite");
    self.mGame = game;
    self.mLabel = tolua.cast(self.mBaseNode:getChildByTag(FoxHelpEffect.LABEL_TAG), "cc.Label");
    print("FoxHelpEffect:init self.mLabel ", self.mLabel );
    setDefaultFont(self.mLabel, self.mGame:getScale());
end

--------------------------------
function FoxHelpEffect:setVisible(visible)
    if self.mBaseNode:isVisible() ~= visible then
        self.mBaseNode:setVisible(visible);
    end
end

--------------------------------
function FoxHelpEffect:setDependAnimation(animation)
    self.mDependAnimation = animation;
end

--------------------------------
function FoxHelpEffect:getDependAnimation()
    return self.mDependAnimation;
end

--------------------------------
function FoxHelpEffect:updateFlip(flipped)
    local pos = Vector.new(self.mBaseNode:getPosition());
    local mult = flipped and 1 or -1;

    self.mBubbleSprite:setFlippedX(flipped);

    self.mBaseNode:setAnchorPoint({ x = self.mAnchorBaseNode.x * mult, y = self.mAnchorBaseNode.y});
end


