require "src/base/Inheritance"

LevelScore = inheritsFrom(nil)
LevelScore.mNode = nil
LevelScore.mLabelScore = nil
LevelScore.mGame = nil

LevelScore.LABEL_TAG = 10

--------------------------------
function LevelScore:init(node, game)
    self.mNode = node;
    local label = self.mNode:getChildByTag(LevelScore.LABEL_TAG);
    self.mLabelScore = label;
    self.mGame = game;
    setDefaultFont(self.mLabelScore, self.mGame:getScale());

    self:setValue(0);
end

--------------------------------
function LevelScore:setValue(score)
    self.mLabelScore:setString(string.format("%07d", score));
end
