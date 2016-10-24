class gm.Spike extends gm.Trap
	constructor: (game, xx, yy, triggers, data) ->
		super game, xx, yy, 1, 1, 'spike', 'spike', triggers, data
		@alpha = 0
		@anchor.setTo(0.5,0.5)
		@x += gm.TILE_SIZE/2
		@y += gm.TILE_SIZE/2
		if data.angle
			@angle=+data.angle

	update: ->
		super()
		allfired = @allTriggersFired()
		if !allfired
			@alpha = 0
		else if @enabled
			@alpha = 1
		#@body.checkCollision.all = if allfired then false else true
		@body.checkCollision.none = if allfired and @enabled then false else true


	applyEffect: (sprite) ->
