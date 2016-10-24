class gm.LightBeam extends Phaser.Sprite
	constructor: (@game, @xx, @yy) ->
		SIZE = 400
		super @game, xx * gm.TILE_SIZE - SIZE/2 + gm.TILE_SIZE/2, yy * gm.TILE_SIZE - SIZE/2 + gm.TILE_SIZE/2, 'lightbeam'
		@alpha = 0.85
		@tint = 0xffaa55
		@width = @height = SIZE
		@blendMode = PIXI.blendModes.ADD

		tween = @game.add.tween(@).to( 
			{x: @x+20, y: @y+20, width: @width-40, height: @height-40, alpha: 0.8},
			Math.random() * 1000 + 3000, 
			Phaser.Easing.Elastic.InOut, 
			true,
			0, 
			-1
		)
		tween.yoyo(true)