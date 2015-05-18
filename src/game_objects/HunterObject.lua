require "src/game_objects/MobObject"
require "src/animations/PlistAnimation"
require "src/base/Log"

HunterObject = inheritsFrom(MobObject)
HunterObject.mDogId = nil;
HunterObject.mDog = nil;
HunterObject.oldVelocity = nil;
HunterObject.FOUND_PLAYER = MobObject.LAST_STATE + 1;

--------------------------------
function HunterObject:initAnimation()
	info_log("HunterObject:initAnimation");
    self.mAnimations = {};

	info_log("Texture ", tolua.cast(self.mNode, "cc.Sprite"):getTexture():getName());
	local animation = PlistAnimation:create();
	animation:init("HunterWalkSide.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

	local sideAnimation = RepeatAnimation:create();
	sideAnimation:init(animation);
	sideAnimation:play();

    self.mAnimation = MobObject.DIRECTIONS.SIDE;
    self.mAnimations[MobObject.DIRECTIONS.SIDE] = sideAnimation;

    ------------------------
    -- Front animation
    local animationFront = PlistAnimation:create();
    animationFront:init("HunterWalkFront.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local frontAnimation = RepeatAnimation:create();
    frontAnimation:init(animationFront);
    self.mAnimations[MobObject.DIRECTIONS.FRONT] = frontAnimation;

    ------------------------
    -- Back animation
    local animationBack = PlistAnimation:create();
    animationBack:init("HunterWalkBack.plist", self.mNode, self.mNode:getAnchorPoint(), nil, 0.3);

    local backAnimation = RepeatAnimation:create();
    backAnimation:init(animationBack);
    self.mAnimations[MobObject.DIRECTIONS.BACK] = backAnimation;
end

---------------------------------
function HunterObject:setCustomProperties(properties)
    info_log("HunterObject:setCustomProperties ");

    HunterObject:superClass().setCustomProperties(self, properties);

    if properties.dog_id then
        info_log("HunterObject:setCustomProperties dog_id ", properties.dog_id);
        self.mDogId = properties.dog_id;
    end
end

--------------------------------
function HunterObject:onMoveFinished( )
    info_log ("HunterObject:onMoveFinished #self.mPath ", #self.mPath);
    if self.oldVelocity and #self.mPath == 0 then
        debug_log("self.mGridPosition x ", self.mGridPosition.x, " y ", self.mGridPosition.y);
        self.mVelocity = self.oldVelocity;
        self.oldVelocity = nil;
    end
    HunterObject:superClass().onMoveFinished(self);
end

---------------------------------
function HunterObject:onEnterFightTriggerImpl()
    HunterObject:superClass().onEnterFightTriggerImpl(self);

    if self.mDog then
        self.mDog:onHunterDead();
    end
end

--------------------------------
function HunterObject:updateDog()
    -- get dog by id
    if self.mDogId and not self.mDog then
        self.mDog = self.mField:getObjectById(self.mDogId);
        info_log("HunterObject:updateDog self.mDog ", self.mDog);
    end

    if self.mDog and self.mState ~= MobObject.DEAD then
        local playerPos = self.mDog:getFoundPlayerPos();
        if playerPos and self.mState ~= HunterObject.FOUND_PLAYER then

            info_log("HunterObject:updateDog player found !!! ");
            self.oldVelocity = self.mVelocity;
            self.mVelocity = self.mVelocity * 4;
            self.mPath = {};
            self:startMoving(playerPos);
            self.mState = HunterObject.FOUND_PLAYER;
        elseif not playerPos and self.mState == HunterObject.FOUND_PLAYER then
            self.mVelocity = self.oldVelocity;
            self.oldVelocity = nil;
        end
    end
end

--------------------------------
function HunterObject:tick(dt)
    self:updateDog();
    HunterObject:superClass().tick(self, dt);
end