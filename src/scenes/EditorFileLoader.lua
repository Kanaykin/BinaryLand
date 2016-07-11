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
EditorFileLoader.TIME_BONUS_ID = 11;
EditorFileLoader.CHEST_BONUS_ID = 12;
EditorFileLoader.HIDDEN_TRAP_ID = 13;
EditorFileLoader.BONUS_TREE_ID = 14;
EditorFileLoader.BONUS_DOOR_ID = 15;
EditorFileLoader.TORNADO_ID = 16;
EditorFileLoader.ICE_GROUND_ID = 17;
EditorFileLoader.SWAMP_GROUND_ID = 18;

EditorFileLoader.MAX_WIDTH = 15;

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
function EditorFileLoader:createTimeBonus(pos, cellSize)
	info_log("EditorFileLoader:createTimeBonus ");

    local node = CCSprite:create("Time.png");
    node:setAnchorPoint(cc.p(0, 0));
    node:setTag(BonusObject.FAKE_NODE_TAG);

    local mainNode = CCNode:create();
    mainNode:addChild(node);
    mainNode:setContentSize(node:getContentSize());

    --pos.y = pos.y + cellSize / 2.0;

    mainNode:setAnchorPoint(cc.p(0.5, 0));
    mainNode:setPosition(pos);
    mainNode:setTag(FactoryObject.BONUS_TIME_TAG);
    return mainNode;
end

--------------------------------
function EditorFileLoader:createChestBonus(pos, cellSize)
	info_log("EditorFileLoader:createChestBonus ");

    local node = CCSprite:create("Chest.png");

    --pos.y = pos.y + cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0));
    node:setPosition(pos);
    node:setTag(FactoryObject.BONUS_CHEST_TAG);
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
function EditorFileLoader:createHiddenTrap(pos, cellSize)
    info_log("EditorFileLoader:createHiddenTrap ");

    local node = CCSprite:create("HiddenTrapForest.png");

    pos.y = pos.y --+ cellSize / 2.0;

    node:setAnchorPoint(cc.p(0.5, 0.0));
    node:setPosition(pos);
    node:setTag(FactoryObject.HIDDEN_TRAP_TAG);
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

--------------------------------
function EditorFileLoader:createBonusTree(pos, cellSize)
	local tree = CCSprite:create("bush2.png");
    
    info_log("EditorFileLoader:createBonusTree tree ", tree);
    tree:setAnchorPoint(cc.p(0.5, 0.0));
    tree:setPosition(pos);
	tree:setTag(FactoryObject.BONUS_ROOM_DOOR_TAG);
    return tree;
end

--------------------------------
function EditorFileLoader:createBonusDoor(pos, cellSize)
	local tree = CCSprite:create("BonusDoorExit.png");
    
    info_log("EditorFileLoader:createBonusTree tree ", tree);
    tree:setAnchorPoint(cc.p(0.5, 0.0));
    tree:setPosition(pos);
	tree:setTag(FactoryObject.BONUS_ROOM_DOOR_TAG);
    return tree;
end

--------------------------------
function EditorFileLoader:createTornado(pos, cellSize)
	local tree = CCSprite:create("Tornado.png");
    
    info_log("EditorFileLoader:createTornado tree ", tree);
    --tree:setAnchorPoint(cc.p(0.5, 0.0));
    pos.y = pos.y + cellSize / 2.0;
    tree:setPosition(pos);
	tree:setTag(FactoryObject.TORNADO_TAG);
    return tree;
end

--------------------------------
function EditorFileLoader:createIceGround(pos, cellSize)
	local tree = CCSprite:create("IceGround.png");
    
    info_log("EditorFileLoader:createIceGround tree ", tree);
    --tree:setAnchorPoint(cc.p(0.5, 0.0));
    pos.y = pos.y + cellSize / 2.0;
    tree:setPosition(pos);
	tree:setTag(FactoryObject.ICE_GROUND_TAG);
    return tree;
end

--------------------------------
function EditorFileLoader:createSwampGround(pos, cellSize)
	local obj = CCSprite:create("SwampGround.png");
    
    info_log("EditorFileLoader:createSwampGround obj ", obj);
    --tree:setAnchorPoint(cc.p(0.5, 0.0));
    pos.y = pos.y + cellSize / 2.0;
    obj:setPosition(pos);
	obj:setTag(FactoryObject.SWAMP_GROUND_TAG);
    return obj;
end


--------------------------------
EditorFileLoader.CreateFunctions = {
	[EditorFileLoader.BUSH_ID] = EditorFileLoader.createBush,
	[EditorFileLoader.FOX_ID] = EditorFileLoader.createFox,
	[EditorFileLoader.FOX_GIRL_ID] = EditorFileLoader.createFoxGirl,
	[EditorFileLoader.HUNTER_ID] = EditorFileLoader.createHunter,
    [EditorFileLoader.DOG_ID] = EditorFileLoader.createDog,
    [EditorFileLoader.CAGE_ID] = EditorFileLoader.createCage,
    [EditorFileLoader.COIN_ID] = EditorFileLoader.createCoin,
    [EditorFileLoader.FOXY_ID] = EditorFileLoader.createLoveCage,
	[EditorFileLoader.TIME_BONUS_ID] = EditorFileLoader.createTimeBonus,
	[EditorFileLoader.CHEST_BONUS_ID] = EditorFileLoader.createChestBonus,
	[EditorFileLoader.HIDDEN_TRAP_ID] = EditorFileLoader.createHiddenTrap,
	[EditorFileLoader.BONUS_TREE_ID] = EditorFileLoader.createBonusTree,
	[EditorFileLoader.BONUS_DOOR_ID] = EditorFileLoader.createBonusDoor,
	[EditorFileLoader.TORNADO_ID] = EditorFileLoader.createTornado,
	[EditorFileLoader.ICE_GROUND_ID] = EditorFileLoader.createIceGround,
	[EditorFileLoader.SWAMP_GROUND_ID] = EditorFileLoader.createSwampGround
};

--------------------------------
function EditorFileLoader:createObjects(G_EditorScene, node, cellSize)

    for i, val in ipairs(G_EditorScene.m) do
        if EditorFileLoader.CreateFunctions[val] ~= nil then
            local child = EditorFileLoader.CreateFunctions[val](EditorFileLoader, cc.p(((i - 1) % G_EditorScene.w) * cellSize + cellSize / 2.0,
                math.floor(G_EditorScene.h - i / G_EditorScene.w) * cellSize), cellSize, node);

            node:addChild(child);
        end
    end

    for i=1, G_EditorScene.w do
        local child = self:createBush(cc.p((i - 1) * cellSize + cellSize / 2.0,
            G_EditorScene.h * cellSize), cellSize, node);

        node:addChild(child);
    end

    if (EditorFileLoader.MAX_WIDTH - 2) > G_EditorScene.w then
        for i=1, G_EditorScene.h + 1 do
            local child = self:createBush(cc.p(- cellSize / 2.0,
                (i - 1) * cellSize), cellSize, node);

            node:addChild(child);

            local child2 = self:createBush(cc.p(G_EditorScene.w * cellSize + cellSize / 2.0,
                (i - 1) * cellSize), cellSize, node);

            node:addChild(child2);
        end
    end

end

--------------------------------
function setProperty(inTable, outTable, nameProperty)
    debug_log("setProperty ", nameProperty, " prop ", inTable[nameProperty])
    if inTable and inTable[nameProperty] then
        outTable[nameProperty] = inTable[nameProperty]
    end
end

--------------------------------
function EditorFileLoader:updateLevelData(levelData, editorScene)
    debug_log("EditorFileLoader:updateLevelData ", editorScene.levelParams);
    setProperty( editorScene.levelParams, levelData, "time");
    setProperty( editorScene.levelParams, levelData, "backgroundMusic");
    setProperty( editorScene.levelParams, levelData, "tileMap");
    setProperty( editorScene.levelParams, levelData, "BonusLevelFile");
end

--------------------------------
function EditorFileLoader:loadEditorFile(levelData, G_EditorScene, levelScene)

    if type(G_EditorScene) == "table" then
		info_log("G_EditorScene ", G_EditorScene);
	    info_log("LevelScene:loadEditorFile G_EditorScene: ", G_EditorScene.m);
		info_log("LevelScene:loadEditorFile G_EditorSceneW: ", G_EditorScene.w);
		info_log("LevelScene:loadEditorFile G_EditorSceneH: ", G_EditorScene.h);

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

        end

        levelScene.mScrollView = ScrollView:create();
        levelScene.mScrollView:initLayers(layers);
        levelScene.mScrollView:setTouchEnabled(false);

        if G_EditorScene.levelParams and G_EditorScene.levelParams.tileMap then
            levelScene:loadTileMap(G_EditorScene.levelParams.tileMap);
        else
            levelScene:loadTileMap("Level1_2_map.tmx");
        end

        self:createObjects(G_EditorScene, nodes[1], cellSize);

        self:updateLevelData(levelData, G_EditorScene);

        levelScene.mSceneGame:addChild(levelScene.mScrollView.mScroll);
        levelScene.mField = Field:create();
        if G_EditorScene.CustomProperties then
            info_log("LevelScene:loadEditorFile CustomProperties ", G_EditorScene.CustomProperties);
            levelData.determinedCustomProperties = G_EditorScene.CustomProperties;
            --levelScene.mField:setCustomProperties(G_EditorScene.CustomProperties);
        end
        levelScene.mField:init(nodes, levelScene.mScrollView.mScroll, levelData, levelScene.mSceneManager.mGame);
        levelScene.mField:setStateListener(levelScene);
        return true;
    end
    return false;
end