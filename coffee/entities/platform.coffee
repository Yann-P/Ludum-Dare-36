class gm.Platform extends Phaser.TileSprite

	constructor: (@game, xx, yy, ww, hh, keyRe, keyIm, props={}) ->
		mode = (parseInt(props.mode) ? null)
		@hidden = false
		super game, 
			xx*gm.TILE_SIZE, 
			yy*gm.TILE_SIZE, 
			ww*gm.TILE_SIZE, 
			hh*gm.TILE_SIZE, 
			(if mode and mode == gm.Mode.IM then keyIm else keyRe)
		@game.physics.enable(this, Phaser.Physics.ARCADE)


		@mode = mode
		@height = gm.TILE_SIZE * hh
		@width = gm.TILE_SIZE * ww
		@body.immovable = true 
		@body.allowGravity = false # fuck la gravité
		@game.add.existing this
		@enabled = true
		#@tint = gm.DARK_TINT

	update: ->

	enable: ->
		@enabled = true
		@alpha = 1
		@body.checkCollision.none = false
		

	disable: ->
		@enabled = false
		@alpha = 0
		@body.checkCollision.none = true
