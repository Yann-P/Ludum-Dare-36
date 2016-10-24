# THIS CODE IS UGLY.

class gm.Level extends Phaser.State

	constructor: (@game) ->

	init: (@levelid) ->
		@data = gm.data.levels[@levelid]
		@game.physics.startSystem(Phaser.Physics.ARCADE)
		@game.physics.arcade.gravity.y = 2500
		@actionButton = @game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
		@nl = @game.input.keyboard.addKey(Phaser.Keyboard.Z)
		@pl = @game.input.keyboard.addKey(Phaser.Keyboard.A)
		
		@ww  = @data.width
		@hh = @data.height
		@mode = gm.Mode.REAL
		@frozen = false

		@triggersById = {} # access via [id]
		@triggers = for x in [0...@data.height]
  			for y in [0...@data.width]
  				[]

	create: ->
		@game.world.setBounds(0, 0, @ww*gm.TILE_SIZE, @hh*gm.TILE_SIZE);
		@backgroundRe = @game.add.tileSprite(0, 0, @game.world.width, @game.world.height, @data.backgrounds[gm.Mode.RE]);
		@backgroundIm = @game.add.tileSprite(0, 0, @game.world.width, @game.world.height, @data.backgrounds[gm.Mode.IM]);
		#@backgroundRe.tint = @backgroundIm.tint = gm.DARK_TINT

		
		@platforms = @game.add.group()
		@zerog = @game.add.group()
		@items = @game.add.group()
		@scenery = @game.add.group()
		@lights = @game.add.group()
		@cracks = @game.add.group()
		@addTriggers(@data.triggers)

		@addPlatforms(
			@data.platforms, 
			@data.defaultPlatforms[gm.Mode.RE],
			@data.defaultPlatforms[gm.Mode.IM]
		)
		@addItems(@data.items)
		
		@addScenery(@data.scenery)
		@addCracks(@data.cracks)

		@player = new gm.Player(@game, @data.player[0], @data.player[1])
		@game.camera.follow(@player, Phaser.Camera.FOLLOW_PLATFORMER) 

		@setupHint()
		@actionButton.onDown.add @onActionCallback, this
		@addLights(@data.lights)
		
		@overlay = @game.add.tileSprite(0, 0, @game.world.width, @game.world.height, "overlay")
		@overlay.alpha = 0
		@overlayRed = @game.add.tileSprite(0, 0, @game.world.width, @game.world.height, "overlay_red")
		@overlayRed.alpha = 0
		@switchMode(gm.Mode.RE, true)    

	freeze: -> 
		@frozen = true
		@player.freeze()
	unfreeze: -> 
		@frozen = false
		@player.unfreeze()
		
	switchMode: (mode, instant) ->

		if instant
			@_switchMode(mode)
			return
		if @frozen 
			return

		@player.animations.play('back', 8, true)
		tween = @game.add.tween(@overlay).to({alpha: 0.2}, 300)
		tween3 = @game.add.tween(@player).to({alpha: 0}, 500)
		tween3.start()
		tween.onComplete.add ->
			@player.animations.play('front', 8, true)
			@_switchMode()

			tween2 = @game.add.tween(@overlay).to({alpha: 0}, 500)
			tween2.start()
			tween4 = @game.add.tween(@player).to({alpha: 1}, 200)
			tween4.start()
			
			tween2.onComplete.add ->
				@player.alpha = 1
				@unfreeze()
			, this
			
			

		, this

		tween.start()
		@freeze()

	_switchMode: (mode) ->
		if mode
			@mode = mode
		else
			@mode = (if @mode == gm.Mode.RE then gm.Mode.IM else gm.Mode.RE)

		for p in @cracks.children
			if @mode == gm.Mode.RE
				p.blendMode = PIXI.blendModes.NORMAL
			else if @mode == gm.Mode.IM
				p.blendMode = PIXI.blendModes.MULTIPLY

		for p in @platforms.children
			p.enable()
			if p.mode && p.mode != @mode
				p.disable()

		for i in @items.children
			i.enable()
			if i.mode && i.mode != @mode
				i.disable()

		for i in @scenery.children
			i.enable()
			if i.mode && i.mode != @mode
				i.disable()

		for i in @zerog.children
			i.enable()
			if i.mode && i.mode != @mode
				i.disable()

		#if @mode == gm.Mode.RE
		#	@movePlayerToSpawn()


		@backgroundRe.alpha = @mode == gm.Mode.RE
		@backgroundIm.alpha = @mode != gm.Mode.RE

	gameOver: ->
		@freeze()
		@player.body.velocity.y = -800
		@player.body.velocity.x = 200
		@player.angle = -50
		@player.body.checkCollision.none = true
		tween = @game.add.tween(@overlayRed).to({alpha: 0.8}, 700, Phaser.Easing.Quadratic.In)
		tween.onComplete.add ->
			@game.state.start('level', true, false, @levelid)
		, this

		tween.start()
		@freeze()

		@game.state.s

	addItems: (data) ->
		for i in data
			@items.add new gm.Item(@game, i.id, i.x, i.y, i.mode)

	addTrap: (data) ->
		for i in data
			@traps.add new gm.Spike(@game, i.id, i.x, i.y, i.mode)

	addLights: (data) ->
		for i in data
			@lights.add new gm.LightBeam(@game, i.x, i.y)

	addScenery: (data) ->
		for i in data
			@scenery.add gm.Scenery.make(@game, i.x, i.y, i.id, i.properties)

	addCracks: (data) ->
		for i in data
			@cracks.add new gm.Crack(@game, i.x, i.y)

	movePlayerToSpawn: ->
		@player.x = @data.player[0] * gm.TILE_SIZE
		@player.y = (@data.player[1] - 2) * gm.TILE_SIZE

	addPlatforms: (data, keyIm, keyRe) ->
		for p in data
			if p.type == 'platform'
				@platforms.add new gm.Platform(
					@game, 
					p.x, 
					p.y, 
					p.w, 
					p.h, 
					keyIm,
					keyRe,
					p.properties
				)
			else if p.type in ['liftableplatform', 'counterweight', 'spike']
				allTriggers = []
				if 'trigger' of p.properties and p.properties.trigger.length > 0
					if p.properties.trigger.indexOf(",") == -1
						allTriggers.push @getTriggerById(+p.properties.trigger)
					else
						for t in p.properties.trigger.split(',')
							allTriggers.push @getTriggerById(+t)

				if p.type == 'liftableplatform'
					@platforms.add new gm.LiftablePlatform(
						@game, 
						p.x, 
						p.y, 
						p.w, 
						p.h,
						keyIm,
						keyRe,
						allTriggers,
						p.properties
					)
				else if p.type == 'spike'
					@platforms.add new gm.Spike(
						@game, 
						p.x, 
						p.y, 
						allTriggers,
						p.properties
					)
				else if p.type == 'counterweight'
					@platforms.add new gm.Counterweight(
						@game, 
						p.x, 
						p.y, 
						allTriggers,
						p.properties
					)

				else throw 'lol'

			else if p.type == 'zerog'
				triggers = {
					enable: [],
					disable: []
				}
				for type in ['enable', 'disable']
					if type of p.properties and p.properties[type].length > 0
						if p.properties[type].indexOf(",") == -1
							triggers[type].push @getTriggerById(p.properties[type])
						else
							for t in p.properties[type].split(',')
								trigges[type].push @getTriggerById(t)

				@zerog.add new gm.ZeroG(
					@game, 
					p.x, 
					p.y, 
					p.w, 
					p.h,
					('default' of p.properties), #enabled by default
					triggers.enable,
					triggers.disable,
					p.properties
				)
				
			else throw 'caca'

	getTriggerById: (id) ->
		return @triggersById[+id]

	addTriggers: (data) ->
		for t in data
			@addTrigger(t)

	addTrigger: (t) ->
		if t.id of @triggersById
			throw "a trigger with id #{t.id} is already registered"
		if t.type == 'texttrigger'
			t = new gm.TextTrigger t.id, t.x, t.y, t.mode, t.text, t.properties
		else if t.type == 'positiontrigger'
			t = new gm.PositionTrigger t.id, t.x, t.y, t.mode, t.automatic, t.properties
		else if t.type == 'itemtrigger'
			t = new gm.ItemTrigger t.id, t.x, t.y, t.mode, t.automatic, +t.item_id, t.properties
		else throw 'not implemented ' + t.type
		@triggers[+t.y][+t.x].push t
		@triggersById[+t.id] = t

		
	onActionCallback: ->
		

	getTriggersAt:(x, y) ->
		if x >= 0 && y >= 0 && x < @ww && y < @hh
			return @triggers[+y][+x]
		return []

	nextLevel: ->
		@player.inventory.items = []
		@player.inventory.rerender()
		if ((@levelid + 1) of gm.data.levels)
			try
				localStorage.setItem('level', @levelid + 1)
			catch e
				console.warn('cant use localstorage')
			@game.state.start('level', true, false, @levelid + 1)
		else
			@game.state.start('win', true, false)

	update: ->
		### TODO RM
		if @pl.isDown && @pl.repeats is 1
			@game.state.start('level', true, false, @levelid-1)
		if @nl.isDown && @nl.repeats is 1
			@game.state.start('level', true, false, @levelid+1)
		## /TODO RM ###

		if @player.yy >= @hh
			return @gameOver()

		@player.blockJump = false
		

		actionPressed = @actionButton.isDown && @actionButton.repeats == 1

		@hint.x = @player.x
		@hint.y = @player.y
		@hint.scale.setTo((if @actionButton.isDown then 1.2 else 0.8), (if @actionButton.isDown then 1.2 else 0.8))
		@setHint(false)


		
		if not @frozen
			if @player.xx == @data.exit[0] and @player.yy == @data.exit[1] and @mode == gm.Mode.RE
				@setHint(true)
				for o in @scenery.children
					if o instanceof gm.Scenery.BadassDoor
						o.animations.play('open', 10, true)
				if actionPressed
					@nextLevel()

			if @game.physics.arcade.overlap(@player, @cracks)
				@setHint(true)
				if actionPressed
					@switchMode()

		# TRIGGERS MESS
		for t in @getTriggersAt(@player.xx, @player.yy)
			wereFired = false
			if t and (!t.mode or t.mode == @mode)
				if !t.automatic and !t.fired
					@setHint(true)
				if actionPressed or t.automatic
					if t instanceof gm.TextTrigger and !t.fired
						@player.say(t.text)
						t.fire()
						wereFired = true
					else if t instanceof gm.PositionTrigger
						t.fire()
						wereFired = true
					else if t instanceof gm.ItemTrigger
						if @player.inventory.hasItem(+t.item_id)
							@player.inventory.removeItem(+t.item_id)
							t.fire()
							wereFired = true
						else
							@player.say("I need a " + gm.data.items[+t.item_id].name + " to trigger that")

					if wereFired and t.data.cmsid and t.data.cmsmethod
						for o in @scenery.children
							if +o.extra.cmsid == +t.data.cmsid
								o[t.data.cmsmethod]()

		@game.physics.arcade.collide(@player, @items, (player, item) =>
			@items.remove(item, true)
			@player.inventory.addItem(item.id)
		)

		@game.physics.arcade.collide(@player, @platforms, (player, p) =>
			if p instanceof gm.Spike and (!p.mode or p.mode == @mode) and p.allTriggersFired() 
				@gameOver()
		)

		@game.physics.arcade.overlap(@player, @zerog, (player, z) =>
			@player.blockJump = true
			if (!z.mode or z.mode == @mode) and z.working
				if @game.rnd.rnd() < 0.001
					@player.say("wwweeeeeeee!")
				z.applyForce(player)
		)

		
	
	setupHint: ->
		@hint = @game.add.sprite(0, 0, 'hint')
		@hint.anchor.setTo(0.5, 0.5)
		@hint.blendMode = PIXI.blendModes.ADD
		@hint.alpha = 0
		@tween = @game.add.tween(@hint).to( {angle: 360}, 3000, Phaser.Easing.Linear.None, true).loop(true);
	
	setHint: (onoff) ->
		@hint.alpha = +onoff * 0.8
