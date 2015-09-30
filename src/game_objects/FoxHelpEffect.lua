require "src/base/Inheritance"
require "src/base/Log"

FoxHelpEffect = inheritsFrom(nil)
FoxHelpEffect.mAnchorBaseNode = nil;
FoxHelpEffect.mBubbleSprite = nil;
FoxHelpEffect.mLabel = nil;
FoxHelpEffect.mBaseNode = nil;
FoxHelpEffect.mGame = nil;
FoxHelpEffect.mDependAnimations = nil;

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
    local anchor = self.mBaseNode:getAnchorPoint();
    self.mAnchorBaseNode = anchor--{ x = anchor.x * game:getScale(), y = anchor.y * game:getScale()};

    self.mBubbleSprite = tolua.cast(self.mBaseNode:getChildByTag(FoxHelpEffect.BUBBLE_NODE_TAG), "cc.Sprite");
    self.mGame = game;
    self.mLabel = tolua.cast(self.mBaseNode:getChildByTag(FoxHelpEffect.LABEL_TAG), "cc.Label");
    info_log("FoxHelpEffect:init self.mLabel ", self.mLabel );
    setDefaultFont(self.mLabel, self.mGame:getScale());

    self.mDependAnimations = {};
end

--------------------------------
function FoxHelpEffect:setVisible(visible)
    if self.mBaseNode:isVisible() ~= visible then
        self.mBaseNode:setVisible(visible);
    end
end

--------------------------------
function FoxHelpEffect:addDependAnimation(animation)
    table.insert(self.mDependAnimations, animation);
end

--------------------------------
function FoxHelpEffect:isDependAnimation(animation)
    for i, anim in ipairs(self.mDependAnimations) do
        if anim == animation then
            return true;
        end
    end
    return false;
end

--------------------------------
function FoxHelpEffect:updateFlip(flipped)
    local pos = Vector.new(self.mBaseNode:getPosition());
    local mult = flipped and 1 or -1;

    self.mBubbleSprite:setFlippedX(flipped);

    self.mBaseNode:setAnchorPoint({ x = self.mAnchorBaseNode.x * mult, y = self.mAnchorBaseNode.y});
end


