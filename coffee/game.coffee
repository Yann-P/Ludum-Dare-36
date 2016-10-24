
class gm.Game extends Phaser.Game

	constructor: ->
		
		super(gm.WIDTH, gm.HEIGHT, Phaser.CANVAS, 'game')
		@state.add 'load', gm.Load, true
		@state.add 'level', gm.Level, false
		@state.add 'title', gm.Title, false


		