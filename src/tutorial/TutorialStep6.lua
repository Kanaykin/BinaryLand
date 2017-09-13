require "src/tutorial/TutorialStepTextBase"
require "src/base/Log"

TutorialStep6 =  inheritsFrom(TutorialStepTextBase)

TutorialStep6.mCCBFileName = "Step6";
TutorialStep6.mNextStep = "TutorialStep7";
TutorialStep6.mFoxAnimation = "FoxGirl";
TutorialStep6.mGirlPlayer = nil;

--------------------------------
function TutorialStep6:init(gameScene, field, tutorialManager)
	TutorialStep6:superClass().init(self, gameScene, field, tutorialManager);

	self.mTutorialManager:getMainUI():getFightButton():setBlocked(false);

    local players = self.mField:getPlayerObjects();
    for i, player in pairs(players) do
        if player:isInTrap() then
            self.mGirlPlayer = player;
        end
    end
end

----------------------------------
function TutorialStep6:onTouchHandler(action)
end

--------------------------------
function TutorialStep6:tick(dt)
	TutorialStep6:superClass().tick(self, dt);

    if self.mGirlPlayer and not self.mGirlPlayer:isInTrap() then
        self.mIsFinished = true;
    end
end
