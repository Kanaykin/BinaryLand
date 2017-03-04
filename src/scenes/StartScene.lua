require "src/scenes/BaseScene"
require "src/scenes/StartMovieStep"
require "src/base/Log"


local LOADSCEENIMAGE = "StartScene.png"
--[[
start scene - loading screen
--]]
StartScene = inheritsFrom(BaseScene)
StartScene.mCurrentStep = nil;

StartScene.COUNT_FRAME = 5;

local MovieTexts = {"  Далеко-далеко, на краю мира, раскинулся Вечный Лес... место, где до сих пор жива магия природы.",
"Здесь, под сенью древних деревьев, живёт дивный народ волшебных лис.",
"Тысячи лет они охраняли Вечный Лес и его обитателей от посягательств извне.",
"Но злые охотники хитростью проникли в зачарованную чащу и похитили всех беззащитных лисят.",
"Теперь клетки с ними разбросаны и по Вечному Лесу, и далеко за его пределами...",
"Пришло время помочь взрослым лисам вернуть своё потомство!"
}

--------------------------------
function StartScene:init(sceneMan, params)
	self:superClass().init(self, sceneMan, {background = LOADSCEENIMAGE});
	info_log("StartScene:init");

	-- create menu elements
	self:createMenuElements();

    local statistic = extend.Statistic:getInstance();
    statistic:sendScreenName("StartScene");

    self:loadScene(sceneMan.mGame);
end

--------------------------------
function StartScene:skipMovie()
    self.mSceneManager:runNextScene();
end

--------------------------------
function StartScene:nextStep(index, game)
    if index == StartScene.COUNT_FRAME then
        self.mSceneManager:runNextScene({fromTutorial = true});
        return;
    end
    index = index + 1;
    debug_log("StartScene:loadScene nextStep ", index)
    self.mCurrentStep = StartMovieStep:create();
    self.mCurrentStep:init(self.mSceneGame, "StartMovieStep" .. index, Callback.new(self, StartScene.nextStep, index, game), game, self);
end

--------------------------------
function StartScene:loadScene(game)

    self:nextStep(0, game);

end

--------------------------------
function StartScene:createMenuElements()
	
	self:createGuiLayer();
end

---------------------------------
function StartScene:tick(dt)
	self:superClass().tick(self, dt);
    if self.mCurrentStep then
        self.mCurrentStep:tick(dt);
    end
end
