require "src/base/Inheritance"

EditorFileLoader = inheritsFrom(nil)
EditorFileLoader.BUSH_ID = 1;
EditorFileLoader.HUNTER_ID = 2;
EditorFileLoader.DOG_ID = 3;
EditorFileLoader.CAGE_ID = 4;
EditorFileLoader.FOX_GIRL_ID = 5;
EditorFileLoader.FOX_ID = 6;
EditorFileLoader.COIN_ID = 7;
EditorFileLoader.FOXY_ID = 8;

--------------------------------
function EditorFileLoader:createLoveCage(pos, cellSize, fieldNode)
    info_log("EditorFileLoader:createLoveCage ");

    local node = CCSprite:create("Baby.png");

    --pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0.0));
    node:setPosition(pos);
    node:setTag(FactoryObject.LOVE_CAGE_TAG);

    -- create trigers
    local trigger1 = CCNode:create();
    trigger1:setContentSize(cc.size(cellSize * 1.2, cellSize * 1.2));
    trigger1:setPosition(cc.p(pos.x + cellSize, pos.y));
    trigger1:setAnchorPoint(cc.p(0.5, 0.0));
    trigger1:setTag(FactoryObject.FINISH_TAG);
    fieldNode:addChild(trigger1);

    local trigger2 = CCNode:create();
    trigger2:setContentSize(cc.size(cellSize * 1.2, cellSize * 1.2));
    trigger2:setPosition(cc.p(pos.x - cellSize, pos.y));
    trigger2:setAnchorPoint(cc.p(0.5, 0.0));
    trigger2:setTag(FactoryObject.FINISH_TAG);
    fieldNode:addChild(trigger2);

    return node;
end

--------------------------------
function EditorFileLoader:createCoin(pos, cellSize)
    info_log("EditorFileLoader:createCoin ");

    local node = CCSprite:create("Coin.png");

    --pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, -0.3));
    node:setPosition(pos);
    node:setTag(FactoryObject.BONUS_TAG);
    return node;
end


--------------------------------
function EditorFileLoader:createCage(pos, cellSize)
    info_log("EditorFileLoader:createCage ");

    local node = CCSprite:create("cage.png");

    pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0.3));
    node:setPosition(pos);
    node:setTag(FactoryObject.WEB_TAG);
    return node;
end

--------------------------------
function EditorFileLoader:createDog(pos, cellSize)
    info_log("EditorFileLoader:createDog ");

    local node = CCSprite:create("Dog.png");

    pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0.5));
    node:setPosition(pos);
    node:setTag(FactoryObject.DOG_TAG);
    return node;
end

--------------------------------
function EditorFileLoader:createHunter(pos, cellSize)
    info_log("EditorFileLoader:createHunter ");
    local node = CCSprite:create("Hunter.png");

    pos.y = pos.y + cellSize / 2.0;
    node:setAnchorPoint(cc.p(0.5, 0.35));
    node:setPosition(pos);
    node:setTag(FactoryObject.HUNTER_TAG);
    return node;
end

--------------------------------
function EditorFileLoader:createBush(pos)
	info_log("EditorFileLoader:createBush ");
	local tree = CCSprite:create("bush.png");
    
    info_log("EditorFileLoader:loadEditorFile tree ", tree);
    tree:setAnchorPoint(cc.p(0.5, 0.0));
    tree:setPosition(pos);
    return tree;
end

--------------------------------
function EditorFileLoader:createFox(pos, cellSize)

    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("Fox", reader, false);
    node:setTag(FactoryObject.FOX_TAG);
    pos.y = pos.y + cellSize / 2.0;
    node:setPosition(pos);
    return node;
end

--------------------------------
function EditorFileLoader:createFoxGirl(pos, cellSize)

    local ccpproxy = CCBProxy:create();
    local reader = ccpproxy:createCCBReader();
    local node = ccpproxy:readCCBFromFile("Fox", reader, false);
    node:setTag(FactoryObject.FOX2_TAG);
    pos.y = pos.y + cellSize / 2.0;
    node:setPosition(pos);
    return node;
end

EditorFileLoader.CreateFunctions = {
	[EditorFileLoader.BUSH_ID] = EditorFileLoader.createBush,
	[EditorFileLoader.FOX_ID] = EditorFileLoader.createFox,
	[EditorFileLoader.FOX_GIRL_ID] = EditorFileLoader.createFoxGirl,
	[EditorFileLoader.HUNTER_ID] = EditorFileLoader.createHunter,
    [EditorFileLoader.DOG_ID] = EditorFileLoader.createDog,
    [EditorFileLoader.CAGE_ID] = EditorFileLoader.createCage,
    [EditorFileLoader.COIN_ID] = EditorFileLoader.createCoin,
    [EditorFileLoader.FOXY_ID] = EditorFileLoader.createLoveCage
};

--------------------------------
function EditorFileLoader:loadEditorFile(levelData, G_EditorScene, levelScene)
    info_log("LevelScene:loadEditorFile G_EditorScene: ", G_EditorScene.m);
    info_log("LevelScene:loadEditorFile G_EditorSceneW: ", G_EditorScene.w);
    info_log("LevelScene:loadEditorFile G_EditorSceneH: ", G_EditorScene.h);
    if G_EditorScene then
        --self.mField = Field:create();

        local visibleSize = CCDirector:getInstance():getVisibleSize();

        --compute size field
        local cellSize = levelData.cellSize * levelScene.mSceneManager.mGame:getScale();
        info_log("LevelScene:loadEditorFile cellSize: ", cellSize);
        local width = cellSize * G_EditorScene.w;
        local height = cellSize * G_EditorScene.h;
        info_log("LevelScene:loadEditorFile width : ", width);
        info_log("LevelScene:loadEditorFile height : ", height);

        info_log("LevelScene:loadEditorFile visibleSize.width : ", visibleSize.width);
        info_log("LevelScene:loadEditorFile visibleSize.height : ", visibleSize.height);

        if width > visibleSize.width then
            width = visibleSize.width;
        end

        local layers = {};
        local nodes = {};
        local count_display = math.ceil(height / visibleSize.height);
        info_log("LevelScene:loadEditorFile count_display : ", count_display);

        for i = 1, count_display do
            local node = CCNode:create();
            local anchor = node:getAnchorPoint();
            info_log("LevelScene:loadEditorFile anchor.x ", anchor.x, " anchor.y ", anchor.y);
            --node:setAnchorPoint(cc.p(0.5, 0.5));
            node:setContentSize(cc.size(visibleSize.width, visibleSize.height));
            --node:setAnchorPoint(cc.p(0.5, 0.5));
            table.insert(layers, node);
            info_log("LevelScene:loadEditorFile create node ");

            local fieldNode = CCNode:create();
            node:addChild(fieldNode);

            fieldNode:setTag(LevelScene.FIELD_NODE_TAG);
            fieldNode:setContentSize(cc.size(G_EditorScene.w * cellSize, visibleSize.height));
            local anchor = fieldNode:getAnchorPoint();
            info_log("LevelScene:loadEditorFile fieldNode anchor.x ", anchor.x, " anchor.y ", anchor.y);
            fieldNode:setPosition(cc.p(visibleSize.width / 2.0, 0.0));
            fieldNode:setAnchorPoint(cc.p(0.5, 0.0));
            table.insert(nodes, fieldNode);

--local layerSize = node:getContentSize();
--local fieldSize = fieldNode:getContentSize();
--node:setContentSize(cc.size(layerSize.width, fieldSize.height));
        end

        levelScene.mScrollView = ScrollView:create();
        levelScene.mScrollView:initLayers(layers);
        levelScene.mScrollView:setTouchEnabled(false);

        levelScene:loadTileMap("Level1_2_map.tmx");

		for i, val in ipairs(G_EditorScene.m) do
			if EditorFileLoader.CreateFunctions[val] ~= nil then
                local child = EditorFileLoader.CreateFunctions[val](EditorFileLoader, cc.p(((i - 1) % G_EditorScene.w) * cellSize + cellSize / 2.0,
                    math.floor(G_EditorScene.h - i / G_EditorScene.w) * cellSize), cellSize, nodes[1]);

				nodes[1]:addChild(child);
			end

        end
        for i=1, G_EditorScene.w do
            local child = self:createBush(cc.p(((i - 1) % G_EditorScene.w) * cellSize + cellSize / 2.0,
                G_EditorScene.h * cellSize), cellSize, nodes[1]);

            nodes[1]:addChild(child);
        end

        levelScene.mSceneGame:addChild(levelScene.mScrollView.mScroll);
        levelScene.mField = Field:create();
        levelScene.mField:init(nodes, levelScene.mScrollView.mScroll, levelData, levelScene.mSceneManager.mGame);
        levelScene.mField:setStateListener(levelScene);
        return true;
    end
    return false;
end