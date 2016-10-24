class gm.Item extends gm.Entity

	constructor: (@game, @id, xx, yy, mode) ->

		super @game, xx, yy, 'item_' + @id, (parseInt(mode)) ? null
		@game.physics.enable(this, Phaser.Physics.ARCADE)		
		@body.allowGravity = false # fuck la gravité
		@game.add.existing this
		ratio = @width/@height
		@height = gm.TILE_SIZE
		@width = gm.TILE_SIZE * ratio
		
		@y -= @height/2-gm.TILE_SIZE/2+5

	enable: ->
		super()
		@body.checkCollision.none = false

	disable: ->
		super()
		@body.checkCollision.none = true
