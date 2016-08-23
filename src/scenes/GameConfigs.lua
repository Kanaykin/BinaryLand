require "src/base/AlignmentHelper"

gLocations = {
	{
		id = 1,
		description = "Forest",
		position = Coord(0.15, 0.5, 0, -87),
		opened = true,
		levels = {
			{
				--opened = true,
				ccbFile = "Level1_1p1_new",
				tileMap = "Level1_1_map.tmx",
				cellSize = 32,
				tutorial = true,
				backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level1_1",
                id = "1_1"
			},
			{
				opened = true,
				--ccbFile = {"Level1_2p1", "Level1_2p2"},
                ccbFile = "Level1_2p1_new",
				tileMap = "Level1_2_map.tmx",
				cellSize = 32,
				tutorial = false,
				time = 120,
				backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_2",
                 id = "1_2",
--                 bonusRoom = {
--                     --opened = false,
--                     ccbFile = "BonusRoom",
--                     tileMap = "Level1_1_map.tmx",
--                     cellSize = 32,
--                     tutorial = false,
-- --                    time = 30,
--                     backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
--                     id = "1_2_bonus_room"
--                 }
			},
			{
                opened = true,
                ccbFile = "Level1_3p1",--"Level1_3p1",
                tileMap = "Level1_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "1_3"--[[,
                bonusLevel = {
                    --opened = false,
                    ccbFile = "Level1_3bonus_p1",
                    tileMap = "Level1_1_map.tmx",
                    cellSize = 32,
                    tutorial = false,
                    time = 60,
                    backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                    customProperties = "src/levels/Level1_3_bonus",
                    id = "1_3_bonus"
                }]]

			},
			{
                opened = true,
                ccbFile = "Level1_4p1",--{"Level1_2p1", "Level1_2p2"},
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_4",
                id = "1_4"
			},
			{
                opened = true,
                ccbFile = {"Level1_5p1", "LevelEmpty_p2"},--{"Level1_2p1", "Level1_2p2"},
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_5",
                id = "1_5"
            },
            {
                opened = true,
                ccbFile = {"Level1_6p1", "Level2_1p2"},
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_6",
                id = "1_6"
            },
            {
                opened = true,
                ccbFile = {"Level1_7p1", "Level1_7p2"},
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_7",
                id = "1_7"
            },
            {
                opened = true,
                ccbFile = "Level1_8p1",
                --ccbFile = "Level1_1p1",
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_8",
                id = "1_8"
            }

		}
	},
	{
		id = 2,
		description = "Sand",
		position = Coord(0.32, 0.5, 0, -215),
        opened = true,
        levels = {
            {
                opened = true,
                ccbFile = "Level2_1p1_new",--{"Level2_1p1", "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_1",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_1"
            },
            {
                opened = true,
                ccbFile = "Level2_2p1",--{"Level2_1p1", "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_2",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_2"
            },
            {
                opened = true,
                ccbFile = {"Level2_3p1", "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_3",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_3"
            },
            {
                opened = true,
                ccbFile = {"Level2_4p1", "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_4",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_4"
            },
            {
                opened = true,
                ccbFile = {"Level2_5p1", "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_5",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_5"
            },
            {
                opened = true,
                ccbFile = "Level2_6p1",-- "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_6",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_6"
            },
            {
                opened = true,
                ccbFile = "Level2_7p1",--, "Level2_7p2"},
                tileMap = "Level2_7_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_7",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_7"
            },
            {
                opened = true,
                ccbFile = {"Level2_8p1", "Level2_8p2"},
                tileMap = "Level2_7_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_8",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_7"
            },
        }
	},
	{
		id = 3,
		description = "Snow",
		position = Coord(0.52, 0.5, 0, -235),
        opened = true,
        levels = {
            {
                opened = true,
                ccbFile = "Level3_1p1",
                tileMap = "Level3_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_1",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_1"
            },
            {
                opened = true,
                ccbFile = "Level3_2p1", 
                tileMap = "Level3_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                --customProperties = "src/levels/Level3_1",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_2"
            },
            {
                opened = true,
                ccbFile = {"Level3_3p1", "Level3_3p2"}, 
                tileMap = "Level3_3_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_3",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_3"
            },
            {
                opened = true,
                ccbFile = {"Level3_4p1", "Level3_4p2"}, 
                tileMap = "Level3_4_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                --customProperties = "src/levels/Level3_3",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_4"
            },
            {

            },
            {

            },
            {

            },
            {

            }
        }
	},
	{
		id = 4,
		description = "Forest",
		position = Coord(0.78, 0.5, 0, -120),
        opened = true,
        levels = {
            {
                opened = true,
                ccbFile = {"Level4_1p1", "Level2_1p2"},
                tileMap = "Level4_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_1",
                id = "4_1"
            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            }
        }
	},
    {
        id = 5,
        description = "Vulcano",
        position = Coord(0.9, 0.5, 0, -120),
        opened = false,
        levels = {
            {
                opened = false,
                ccbFile = {"Level5_1p1", "Level2_1p2"},
                tileMap = "Level5_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_1",
                id = "5_1"
            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            },
            {

            }
        }
    },

}