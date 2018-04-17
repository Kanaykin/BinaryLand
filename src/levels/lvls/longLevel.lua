local map = {0,0,8,0,0,0,0,1,0,1,0,0,1,0,0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,0,1,1,4,1,1,0,0,4,0,0,1,0,1,0,1,0,0,1,0,0,0,1,1,1,3,0,7,1,7,0,1,7,1,7,1,0,7,1,7,0,0,7,1,7,0,0,7,1,7,0,0,5,1,6,0}
local levelParams = {
				tileMap = "Level2_7_map.tmx",
				time = 20,
				backgroundMusic = "sounds/Music/level_theme.mp3",
--                customProperties = "src/levels/Level1_2",
--                id = "1_2",
                bonusRoom = {
                    --opened = true,
                    ccbFile = "BonusRoom",
                    tileMap = "Level1_1_map.tmx",
                    cellSize = 32,
                    tutorial = false,
--                    time = 30,
                    backgroundMusic = "sounds/Music/level_theme.mp3",
                    id = "1_2_bonus_room"
                }
			}
return {m=map,w=5,h=18, levelParams = levelParams}
