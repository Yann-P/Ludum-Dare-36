class gm.Counterweight extends gm.LiftablePlatform
	constructor: (@game, xx, yy, triggers, data) ->
		super @game, xx, yy, 3, 3, 'counterweight', 'counterweight', triggers, data
		@rope = @game.add.tileSprite(@x+@width/2-7, 0, 15, -@y-1000, 'chain')
		@rope.tint = gm.DARK_TINT
		
	update: ->
		super()
		@rope.alpha = @alpha
		@rope.y = @y