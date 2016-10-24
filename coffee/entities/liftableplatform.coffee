class gm.LiftablePlatform extends gm.DynamicPlatform

	constructor: (@game, xx, yy, ww, hh, keyRe, keyIm, triggers, data) ->
		super game, xx, yy, ww, hh, keyRe, keyIm, triggers, data
		@amplitude = parseInt(data.amplitude ? 0)
		@direction = parseInt(data.direction ? gm.Direction.UP) # gm.Direction
		@duration = parseInt(data.duration ? 1000)
		@used = false
		@busy = false
		@originalX = @body.x
		@originalY = @body.y

		@lastLiftTime = 0
		@resetTime = null
		if data.resettime
			@resetTime = parseInt(data.resettime)
			
	lift: (reverse=false) ->
		@busy = true

		if !reverse
			xDiff = @body.x +
				if @direction == gm.Direction.LEFT then -@amplitude
				else if @direction == gm.Direction.RIGHT then @amplitude 
				else 0
			yDiff = @body.y +
				if @direction == gm.Direction.DOWN then @amplitude
				else if @direction == gm.Direction.UP then -@amplitude
				else 0

			@used = true
		else
			xDiff = @originalX
			yDiff = @originalY

			@used = false


		tween = @game.add.tween(@body).to( 
			{x: xDiff, y: yDiff},
			@duration, 
			Phaser.Easing.Linear.None, 
			true
		)
		tween.onComplete.add ->
			@lastLiftTime = Date.now()
			@busy = false
		, this
		tween.start()

	reset: ->
		console.log 'triggers reset'
		@lift(true)
		@resetTriggers()

	update: ->
		if @allTriggersFired() && !@used && !@busy
			@lift()
		else if !@busy && @used && @resetTime && @lastLiftTime != 0 && Date.now() - @lastLiftTime > @resetTime
			@reset()


