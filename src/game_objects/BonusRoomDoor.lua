require "src/game_objects/Trigger"
require "src/base/Log"

BonusRoomDoor = inheritsFrom(Trigger)
BonusRoomDoor.mVisited = nil;
BonusRoomDoor.mAnimation = nil;
BonusRoomDoor.mBonusAnimation = nil;

--------------------------------
function BonusRoomDoor:init(field, node, enterCallback, leaveCallback)
    BonusRoomDoor:superClass().init(self, field, node, enterCallback, leaveCallback);
    info_log("BonusRoomDoor:init id ", self:getId());
    field:addEnemyEnterTriggerListener(self);

    self:createAnimation();

    self.mSize.height = self.mSize.height * 0.6;
    self:updateDebugBox();
end

--------------------------------
function BonusRoomDoor:createAnimation()
    local textureName = tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName();
        
    local textureEmpty = cc.Director:getInstance():getTextureCache():getFileNameForTexture(tolua.cast(self.mNode, "cc.Sprite"):getTexture());
    local _, file = string.match(textureEmpty, '(.+)/(.+)%..+');
    local animationName = file .. "Entrance.plist"
    debug_log("BonusRoomDoor !!!! animationName ", animationName);

    local array = cc.FileUtils:getInstance():getValueMapFromFile(animationName);
    if array["frames"] then
        debug_log("BonusRoomDoor:init array ", array["frames"]);

        local texture = tolua.cast(self.mNode, "cc.Sprite"):getTexture();
        texture:retain();

        local anim1 = EmptyAnimation:create();
        anim1:init(texture, self.mNode, self.mNode:getAnchorPoint());

        local delayAnim = DelayAnimation:create();
        delayAnim:init(anim1, 1);
        --------------------
        local repeat_idle = RepeatAnimation:create();
        local animation = PlistAnimation:create();
        local anchor = self.mNode:getAnchorPoint();
        animation:init(animationName, self.mNode, anchor, nil, 0.2);
        repeat_idle:init(animation, false, 4);

        --------------------
        local sequence = SequenceAnimation:create();
        sequence:init();

        sequence:addAnimation(delayAnim);
        sequence:addAnimation(repeat_idle);

        self.mAnimation = sequence;
    end
end

---------------------------------
function BonusRoomDoor:destroy()
    info_log("BonusRoomDoor:destroy ");

    BonusRoomDoor:superClass().destroy(self);

    if self.mAnimation then
        self.mAnimation:destroy();
    end
end

--------------------------------
function BonusRoomDoor:isHunter(enemy)
    return enemy:getTag() == 106;
end

--------------------------------
function BonusRoomDoor:onEnemyEnterTrigger(enemy)
    info_log("BonusRoomDoor:onEnemyEnterTrigger id ", enemy:getId());
    if self.mAnimation and self:isHunter(enemy) then
        self.mAnimation:play();
    end

end

---------------------------------
function BonusRoomDoor:setCustomProperties(properties)
    info_log("BonusRoomDoor:setCustomProperties animated ", properties.bonusAnimation);

    BonusRoomDoor:superClass().setCustomProperties(self, properties);
    self.mBonusAnimation = properties.bonusAnimation;
end

--------------------------------
function BonusRoomDoor:tick(dt)
    BonusRoomDoor:superClass().tick(self, dt);
    if self.mAnimation then
        self.mAnimation:tick(dt);
    end
end

---------------------------------
function BonusRoomDoor:onEnter(player)
    info_log("BonusRoomDoor:onEnter self.mVisited ", self.mVisited);
    if not self.mVisited then
        self.mVisited = true;
        BonusRoomDoor:superClass().onEnter(self, player);
    end
end

---------------------------------
function BonusRoomDoor:store(data)
    info_log("BonusRoomDoor:store self.mVisited ", self.mVisited);
    BonusRoomDoor:superClass().store(self, data);
    data.visited = self.mVisited;
end

---------------------------------
function BonusRoomDoor:restore(data)
    info_log("BonusRoomDoor:restore data.visited", data.visited);
    BonusRoomDoor:superClass().restore(self, data);
    self.mVisited = data.visited;
    if self.mVisited then
        self.mField:removeBonusRoomDoor(self);
    end
end
