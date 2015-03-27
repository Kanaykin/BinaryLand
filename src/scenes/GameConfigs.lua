require "src/base/AlignmentHelper"

gLocations = {
	{
		id = "mercury",
		image = "mercury.png",
		position = Coord(0.15, 0.5, 0, -87),
		opened = true,
		levels = {
			{
				--opened = true,
				ccbFile = "Level1_1p1",
				tileMap = "Level1_1_map.tmx",
				cellSize = 32,
				tutorial = true,
				backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                customProperties = "src/levels/Level1_1",
                id = "1_1"
			},
			{
				--opened = true,
				ccbFile = {"Level1_2p1", "Level1_2p2"},
				tileMap = "Level1_2_map.tmx",
				cellSize = 32,
				tutorial = false,
				time = 120,
				backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                id = "1_2",
                bonusRoom = {
                    --opened = true,
                    ccbFile = "BonusRoom",
                    tileMap = "Level1_1_map.tmx",
                    cellSize = 32,
                    tutorial = false,
--                    time = 30,
                    backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                    id = "1_2_bonus_room"
                }
			},
			{
                --opened = true,
                ccbFile = "Level1_3p1",
                tileMap = "Level1_1_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 12,
                backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                id = "1_3",
                bonusLevel = {
                    --opened = true,
                    ccbFile = "Level1_4p1",
                    tileMap = "Level1_1_map.tmx",
                    cellSize = 32,
                    tutorial = false,
                    time = 30,
                    backgroundMusic = "sounds/Music/Hall_Of_The_Death_Angel.mp3",
                    customProperties = "src/levels/Level1_3_bonus",
                    id = "1_3_bonus"
                }

			},
			{
                --opened = true,
                ccbFile = {"Level1_2p1", "Level1_2p2"},
                tileMap = "Level1_2_map.tmx",
                cellSize = 32,
                tutorial = false,
                time = 120,
                backgroundMusic = "sounds/Music/TrainOfConsequences.mp3",
                id = "1_4"
			},
			{

			}
		}
	},
	{
		id = "venus",
		image = "venus.png",
		position = Coord(0.32, 0.5, 0, -215)
	},
	{
		id = "earth",
		image = "earth.png",
		position = Coord(0.52, 0.5, 0, -235)
	},
	{
		id = "mars",
		image = "mars.png",
		position = Coord(0.78, 0.5, 0, -120)
	},
}