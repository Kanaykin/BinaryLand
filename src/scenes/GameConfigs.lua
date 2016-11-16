require "src/base/AlignmentHelper"

gLocations = {
	{
		id = 1,
		description = "Forest",
		position = Coord(0.15, 0.5, 0, -87),
		opened = true,
        countStars = 0,
		levels = {
			{
				--opened = false,
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
                 id = "1_2"
			},
			{
                opened = true,
                ccbFile = "Level1_3p1",--"Level1_3p1",
                tileMap = "Level1_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "1_3"
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
                ccbFile = "Level1_7p1",
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
                ccbFile = {"Level1_8p1", "Level1_8p2"},
                --ccbFile = "Level1_1p1",
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_8",
                id = "1_8"
            },
            {
                opened = false,
                isBonus = true,
                ccbFile = "Level1_bonusp1",
                --ccbFile = "Level1_1p1",
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                customProperties = "src/levels/Level1_8",
                id = "1_bonus"
            }

		}
	},
	{
		id = 2,
		description = "Sand",
		position = Coord(0.32, 0.5, 0, -215),
        opened = true,
        countStars = 30,
        levels = {
            {
                opened = false,
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
                opened = false,
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
                opened = false,
                ccbFile = "Level2_3p1",
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_3",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_3"
            },
            {
                opened = false,
                ccbFile = "Level2_4p1",-- "Level2_1p2"},
                tileMap = "Level2_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_4",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_4"
            },
            {
                opened = false,
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
                opened = false,
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
                opened = false,
                ccbFile = {"Level2_7p1", "Level2_1p2"},
                tileMap = "Level2_7_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level2_7",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "2_7"
            },
            {
                opened = false,
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
        countStars = 30,
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
                opened = true,
                ccbFile = {"Level3_5p1", "Level3_5p2"}, 
                tileMap = "Level3_5_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_5",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_5"
            },
            {
                opened = true,
                ccbFile = { "Level3_6p1", "Level2_1p2"},
                tileMap = "Level3_6_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_6",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_6"
            },
            {
                opened = true,
                ccbFile = {"Level3_7p1", "Level2_1p2"},
                tileMap = "Level3_7_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_7",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_7"
            },
            {
                opened = false,
                ccbFile = {"Level3_8p1", "Level3_8p2"},
                tileMap = "Level3_8_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                customProperties = "src/levels/Level3_8",
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "3_8"
            }
        }
	},
	{
		id = 4,
		description = "Forest",
		position = Coord(0.78, 0.5, 0, -120),
        opened = true,
        countStars = 30,
        levels = {
            {
                opened = false,
                ccbFile = {"Level4_1p1", "Level4_1p2"},
                tileMap = "Level4_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_1",
                id = "4_1"
            },
            {
                opened = false,
                ccbFile = {"Level4_2p1", "Level4_2p2"},
                tileMap = "Level4_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_2",
                id = "4_2"
            },
            {
                opened = false,
                ccbFile = {"Level4_3p1", "Level2_1p2"},
                tileMap = "Level4_3_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_3",
                id = "4_3"
            },
            {
                opened = false,
                ccbFile = {"Level4_4p1", "Level2_1p2"},
                tileMap = "Level4_4_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_4",
                id = "4_4"
            },
            {
                opened = false,
                ccbFile = {"Level4_5p1", "Level4_5p2"},
                tileMap = "Level4_4_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_5",
                id = "4_5"
            },
            {
                opened = false,
                ccbFile = {"Level4_6p1", "Level4_6p2"},
                tileMap = "Level4_6_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_6",
                id = "4_6"
            },
            {
                opened = false,
                ccbFile = "Level4_7p1",
                tileMap = "Level4_7_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_7",
                id = "4_7"
            },
            {
                opened = false,
                ccbFile = {"Level4_8p1", "Level4_8p2"},
                tileMap = "Level4_8_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 180,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level4_8",
                id = "4_8"
            }
        }
	},
    {
        id = 5,
        description = "Vulcano",
        position = Coord(0.9, 0.5, 0, -120),
        opened = true,
        countStars = 30,
        levels = {
            {
                opened = true,
                ccbFile = {"Level5_1p1", "Level2_1p2"},
                tileMap = "Level5_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_1",
                id = "5_1"
            },
            {
                opened = true,
                ccbFile = {"Level5_2p1", "Level5_2p2"},
                tileMap = "Level5_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_2",
                id = "5_2"
            },
            {
                opened = true,
                ccbFile = {"Level5_3p1", "Level5_3p2"},
                tileMap = "Level5_3_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_3",
                id = "5_3"
            },
            {
                opened = true,
                ccbFile = {"Level5_4p1", "Level5_4p2"},
                tileMap = "Level5_4_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_4",
                id = "5_4"
            },
            {
                opened = true,
                ccbFile = {"Level5_5p1", "Level5_5p2"},
                tileMap = "Level5_5_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_5",
                id = "5_5"
            },
            {
                opened = true,
                ccbFile = {"Level5_5p1", "Level5_5p2"},
                tileMap = "Level5_5_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_5",
                id = "5_6"
            },
            {
                opened = true,
                ccbFile = {"Level5_5p1", "Level5_5p2"},
                tileMap = "Level5_5_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_5",
                id = "5_7"
            },
            {
                opened = true,
                ccbFile = {"Level5_8p1", "Level5_8p2"},
                tileMap = "Level5_8_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level5_5",
                id = "5_8"
            }
        }
    },

}