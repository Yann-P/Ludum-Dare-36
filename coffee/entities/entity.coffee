class gm.Entity extends Phaser.Sprite

	constructor: (@game, @xx, @yy, key, @mode=null) ->
		super @game, @xx*gm.TILE_SIZE, @yy*gm.TILE_SIZE, key
		#@tint = gm.DARK_TINT
		@enabled = true

	enable: ->
		@enabled = true
		@alpha = 1

	disable: ->
		@enabled = false
		@alpha = 0