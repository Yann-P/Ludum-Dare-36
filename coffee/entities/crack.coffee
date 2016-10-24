class gm.Crack extends gm.Entity

	constructor: (game, xx, yy, mode)->
		super game, xx, yy, 'crack_1', mode
		@height -= 30
		@y -= @height - gm.TILE_SIZE
		@game.physics.enable(this, Phaser.Physics.ARCADE)
		@body.setSize(10, 50, 50, 50)
		@body.allowGravity = false
		@body.immovable = true
		@body.checkCollision.up = false
		@body.checkCollision.down = false