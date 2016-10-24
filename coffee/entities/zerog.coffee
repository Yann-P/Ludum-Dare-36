class gm.ZeroG extends gm.Entity
	constructor: (game, xx, yy, ww, hh, enabledByDefault, @enableTriggers, @disableTriggers, data)->
		super game, xx, yy, null, parseInt(data.mode) or null
		@width = ww * gm.TILE_SIZE
		@height = hh * gm.TILE_SIZE
		@game.physics.enable(this, Phaser.Physics.ARCADE)
		@body.allowGravity = false
		@body.immovable = true
		@direction = +data.direction or gm.Direction.UP
		@force = +data.force or 1000
		@working = enabledByDefault
		@setupEmitter()

	setupEmitter: ->
		@emitter = @game.add.emitter(@x+30, @y+50)

		@emitter.makeParticles('steam')

		@emitter.setAlpha(0.5, 0, 1000, Phaser.Easing.Cubic.In)
		@emitter.setScale(3, 8, 3, 8, 1000, Phaser.Easing.Cubic.Out)
		@emitter.gravity = -@game.physics.arcade.gravity.y-100

		factor = -1
		if @direction == gm.Direction.UP or @direction == gm.Direction.LEFT
			factor = 1


		if @direction == gm.Direction.UP or @direction == gm.Direction.DOWN

			@emitter.minParticleSpeed.set(-50, -100*factor)
			@emitter.maxParticleSpeed.set(50, -300*factor)

		if @direction == gm.Direction.LEFT or @direction == gm.Direction.RIGHT

			@emitter.minParticleSpeed.set(-100*factor, -50)
			@emitter.maxParticleSpeed.set(-300*factor, 50)
			

		#	false means don't explode all the sprites at once, but instead release at a rate of one particle per 100ms
		#	The 5000 value is the lifespan of each particle before it's killed
		@emitter.start(false, 1000, 100)

	update: ->
		@emitter.on = @working && @enabled
		if not @working
			for t in @enableTriggers
				if t.fired
					@working = true
		else

			for t in @disableTriggers
				if t.fired
					@working = false
					

		for t in @enableTriggers.concat @disableTriggers
			t.reset()

	applyForce: (sprite) ->
		forceX = (if @direction == gm.Direction.RIGHT then @force else if @direction == gm.Direction.LEFT then -@force else 0)
		forceY = (if @direction == gm.Direction.UP then -@force else if @direction == gm.Direction.DOWN then @force else 0)
		sprite.body.velocity.x += forceX
		sprite.body.velocity.y += forceY