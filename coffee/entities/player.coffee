class gm.Player extends Phaser.Sprite
	
	constructor: (@game, @xx, @yy) ->
		super @game, xx * gm.TILE_SIZE, yy * gm.TILE_SIZE, 'player'

		@animations.add('run_right', [4, 7, 10, 7])
		@animations.add('run_left', [5, 8, 11, 8])
		@animations.add('idle_right', [3])
		@animations.add('front', [6])
		@animations.add('back', [0])
		@animations.add('idle_left', [9])
		@animations.add('jump_right', [1])
		@animations.add('jump_left', [2])
		@blockJump = false

		@direction = gm.Direction.RIGHT
		@speed = 280
		@frozen = false
		@cursors = @game.input.keyboard.createCursorKeys();
		@jumpButton = @game.input.keyboard.addKey(Phaser.Keyboard.UP);
		@inventory = new gm.Inventory(@game)
		@game.add.existing @inventory
		@game.physics.enable(this, Phaser.Physics.ARCADE)
		
		
		@body.setSize(30, 80, 10, 10)
		@body.checkCollision.up = false;
		@tint = gm.DARK_TINT
		@game.add.existing this
		@lastText = 0
		@sayWhat = game.add.text(0, 0, '', {fontFamily: 'sans-serif', fontSize: 20, fill: 'white'})
		
	freeze: -> @frozen = true
	unfreeze: -> @frozen = false

	say: (text) ->
		@sayWhat.text = text
		@lastText = Date.now()

	update: ->
		@sayWhat.x = @x - @sayWhat.text.length * 6 + 50
		@sayWhat.y = @y - 30
		@sayWhat.alpha = 1

		if Date.now() - @lastText > 5000
			@sayWhat.alpha = 0

		@body.velocity.x *= .7

		if not @frozen
			
			state = 'run'
			if @cursors.left.isDown
				@direction = gm.Direction.LEFT
				@body.velocity.x = -@speed
			else if @cursors.right.isDown
				@direction = gm.Direction.RIGHT
				@body.velocity.x = @speed
			else if Math.abs(@body.velocity.x) < 20
				state = 'idle'

			if @jumpButton.isDown && @body.touching.down && !@blockJump
				@body.velocity.y = -850

		dir = (if @direction == gm.Direction.RIGHT then 'right' else 'left')
		if @body.touching.down
			@animations.play(state + '_' + dir, 8, true)
		else
			@animations.play('jump_' + dir)

		

		@xx = ~~((@body.x+@body.width/2) / gm.TILE_SIZE)
		@yy = ~~((@body.y+@body.height-gm.TILE_SIZE/2) / gm.TILE_SIZE)