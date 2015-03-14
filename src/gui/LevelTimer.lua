require "src/base/Inheritance"

LevelTimer = inheritsFrom(nil)
LevelTimer.TIMER_TAG = 30;
LevelTimer.PROGRESS_TAG = 31;
LevelTimer.mNode = nil;
LevelTimer.mGame = nil;
LevelTimer.mTimeLabel = nil;
LevelTimer.mProgress = nil;
LevelTimer.mProgressMaxValue = nil;

--------------------------------
function LevelTimer:init(node, game)
    self.mNode = node;
    local time = self.mNode:getChildByTag(LevelTimer.TIMER_TAG);
    self.mTimeLabel = time;
    self.mGame = game;
    setDefaultFont(time, self.mGame:getScale());

    self.mProgress = tolua.cast(self.mNode:getChildByTag(LevelTimer.PROGRESS_TAG), "ccui.Scale9Sprite");
end

--------------------------------
function LevelTimer:setTimerInitValue(value)
    self.mProgressMaxValue = value;
end

--------------------------------
function LevelTimer:setVisible(visible)
    self.mNode:setVisible(visible);
end

--------------------------------
function LevelTimer:setTime(time)
    if time < 0 then
        time = 0
    end
    local second = math.floor(time);
    local minute = math.floor(second / 60)
    self.mTimeLabel:setString(tostring(minute)..":"..string.format("%02d", (second - minute * 60)));

    self.mProgressMaxValue = math.max(self.mProgressMaxValue, time);
    -- set progress
    self.mProgress:setScaleX(time / self.mProgressMaxValue);
end