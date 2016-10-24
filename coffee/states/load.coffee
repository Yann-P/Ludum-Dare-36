class gm.Load extends Phaser.State

	constructor: (@game) ->
		@nbLevels = Object.keys(gm.data.levels).length
		@nbItems = Object.keys(gm.data.items).length

	
	preload: ->
		@game.load.image 'platform', 'assets/platform.png'
		@game.load.image 'ropeline', 'assets/ropeline.png'
		@game.load.image 'chain', 'assets/chain.png'
		@game.load.image 'scaffolding', 'assets/scaffolding.png'
		@game.load.image 'spike', 'assets/spike.png'
		@game.load.image 'kiwi', 'assets/kiwi.png'
		@game.load.image 'warrior', 'assets/warrior.png'
		@game.load.image 'title', 'assets/title.png'

		@game.load.spritesheet 'torch', 'assets/torch.png', 30, 90, 2
		@game.load.spritesheet 'badassdoor', 'assets/badassdoor.png', 120, 180, 2
		@game.load.spritesheet 'furnace', 'assets/furnace.png', 180, 180, 2
		@game.load.spritesheet 'pipe_small', 'assets/pipe_small.png', 30, 120, 4
		@game.load.spritesheet 'pipebend_small', 'assets/pipebend_small.png', 60, 60, 4
		@game.load.spritesheet 'pipe', 'assets/pipe.png', 60, 60, 4
		@game.load.spritesheet 'pipebend_out', 'assets/pipebend_out.png', 120, 120, 4
		@game.load.spritesheet 'pipebend_in', 'assets/pipebend_in.png', 120, 120, 4
		@game.load.spritesheet 'pipeside', 'assets/pipeside.png', 120, 120, 4

		@game.load.image 'gear', 'assets/gear.png'
		@game.load.image 'gear2', 'assets/gear2.png'
		@game.load.image 'arch', 'assets/arch.png'
		@game.load.image 'geartrigger', 'assets/geartrigger.png'
		@game.load.image 'wall_1', 'assets/wall_1.png'
		@game.load.image 'wall_2', 'assets/wall_2.png'
		@game.load.image 'counterweight', 'assets/counterweight.png'
		@game.load.image 'crack_1', 'assets/crack_1.png'
		@game.load.image 'crack_2', 'assets/crack_2.png'
		@game.load.image 'lightbeam', 'assets/lightbeam.png'
		@game.load.image 'platform_1', 'assets/platform_1.png'
		@game.load.image 'platform_2', 'assets/platform_2.png'
		#@game.load.image 'player', 'assets/player.png'
		@game.load.image 'hint', 'assets/hint.png'
		@game.load.image 'steam', 'assets/steam.png'
		@game.load.image 'overlay', 'assets/overlay.png'
		@game.load.image 'overlay_red', 'assets/overlay_red.png'
		@game.load.script('webfont', '//ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js');

		for i in [1 .. @nbItems]
			@game.load.image 'item_' + i, 'assets/item_' + i + '.png'

		@game.load.spritesheet 'player', 'assets/player_prod.png', 60, 90, 12, 3, 3

		for i in [1 .. @nbLevels ]
			@game.load.json('level_' + i, 'maps/' + i + '.json');

	parseLevelData: ->

		for i in [1 .. @nbLevels]

			json = this.game.cache.getJSON('level_' + i);
			res = gm.Load.parseTiledJSON(json);

			for key in Object.keys res
				gm.data.levels[i][key] = res[key]

	create: ->
		@parseLevelData()
		WebFontConfig = {
		    google: {
		      families: ['MedievalSharp']
		    }
		}
		@game.state.start('title')


gm.Load.parseTiledJSON = (data) ->
	SIZE = 20
	res =
		height: data.layers[0].height
		width: data.layers[0].width
		platforms: []
		cracks: []
		triggers: []
		scenery: []
		items: []
		lights: []
		player: null
		exit: null

	if data.layers[0].name != 'platforms'
		throw "layer 0 must be platforms layer named 'platforms'"
	if data.layers[1].name != 'triggers'
		throw "layer 1 must be triggers layer named 'triggers'"
	if data.layers[2].name != 'items'
		throw "layer 2 must be items layer named 'items'"
	if data.layers[3].name != 'scenery'
		throw "layer 3 must be scenery layer named 'scenery'"
	if data.layers[4].name != 'lights'
		throw "layer 4 must be lights layer named 'lights'"
	if data.layers[5].name != 'cracks'
		throw "layer 5 must be cracks layer named 'cracks'"
	

	all = []
	for l, i in data.layers
		all = all.concat data.layers[i].objects

	# PLATEFORMES
	for o, i in all

		if o.type == ""
			o.type = 'platform'
		
		if o.type in ['platform', 'liftableplatform', 'counterweight', 'spike', 'zerog']
			res.platforms.push({
				type: o.type
				x: o.x/SIZE
				y: o.y/SIZE
				w: o.width/SIZE
				h: o.height/SIZE
				properties: o.properties
			})

		else if o.type == "player"
			res.player = [o.x/SIZE, o.y/SIZE]
		else if o.type == "exit"
			res.exit = [o.x/SIZE, o.y/SIZE]
		
		else if o.type in ['positiontrigger', 'texttrigger', 'itemtrigger']
			d =
				type: o.type
				id: o.properties.id
				x: o.x/SIZE
				y: o.y/SIZE
				automatic: o.properties.automatic
				mode: o.properties.mode
				properties: o.properties
			
			if o.type == "positiontrigger"
				res.triggers.push d
			else if o.type == 'texttrigger'
				d.text = o.properties.text
				res.triggers.push d
			else if o.type == 'itemtrigger'
				d.item_id = parseInt(o.properties.item_id)
				res.triggers.push d
			else 
				throw "unknown (type=#{o.type}) on trigger layer"
	
		else if o.type in ['item']
			if o.type == "item"
				res.items.push({
					id: o.properties.id
					x: o.x/SIZE
					y: o.y/SIZE
					mode: o.properties.mode
				})
			else 
				throw "unknown (type=#{o.type}) on items layer"

		else if o.type in ['sceneryitem']

			if o.type == "sceneryitem"
				res.scenery.push({
					x: o.x/SIZE
					y: o.y/SIZE
					id: o.properties.id
					properties: o.properties
				})
			else 
				throw "unknown (type=#{o.type}) on scenery layer"


		else if o.type in ['light']
			if o.type == "light"
				res.lights.push({
					x: o.x/SIZE
					y: o.y/SIZE
				})
			else 
				throw "unknown (type=#{o.type}) on light layer"

		else if o.type in ['crack']
			if o.type == "crack"
				res.cracks.push({
					x: o.x/SIZE
					y: o.y/SIZE
				})
			else 
				throw "unknown (type=#{o.type}) on cracks layer"

	
	return res
	