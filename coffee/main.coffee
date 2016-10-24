gm =
	TILE_SIZE: 30
	WIDTH: 800
	HEIGHT: 600
	DARK_TINT: 0xffffff#0xcccccc
	Mode:
		REAL: 1
		RE: 1
		IMAGINARY: 2
		IM: 2
	Direction:
		UP: 1
		TOP: 1
		RIGHT: 2
		DOWN: 3
		BOTTOM: 3
		LEFT: 4
	data:
		items:
			1:
				name: 'lamp'
			2:
				name: 'rope'
			3:
				name: 'gear'
			4:
				name: 'pulley'
			5:
				name: 'bucket'
		levels:
			1:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			2:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			3:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			4:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			5:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			6:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			7:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			8:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}
			9:
				backgrounds: {1: 'wall_1', 2: 'wall_2'}
				defaultPlatforms: {1: 'platform_1', 2: 'platform_2'}

window.gm = gm

window.addEventListener 'load', =>
	game = new gm.Game()
	gm.game = game