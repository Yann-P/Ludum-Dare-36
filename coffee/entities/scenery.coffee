gm.Scenery = {}
class gm.Scenery.Item extends gm.Entity
	constructor: (game, x, y, id, mode, @extra={}) ->
		super game, x, y, id, (parseInt(extra.mode) or null)
		@x -= @width/2-gm.TILE_SIZE/2
		@y -= @height/2-gm.TILE_SIZE/2
		if @extra.scale
			@scale.setTo(+@extra.scale, +@extra.scale)

class gm.Scenery.Lamp extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, null, extra
		@animations.add('anim', [0, 1])
		@animations.play('anim', 10, true)

class gm.Scenery.GearTrigger extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, gm.Mode.IM, extra
		@blendMode = PIXI.blendModes.ADD
		@anchor.setTo(0.5, 0.5)
		@scale.set(0.3, 0.3)
		@x += gm.TILE_SIZE
		@y += gm.TILE_SIZE
		@tween = @game.add.tween(@).to( {
			angle: 90
		}, 5000, Phaser.Easing.Bounce.InOut, true).loop(true)
	update: ->
		super()
		if @alpha != 0
			@alpha = 0.3

class gm.Scenery.Scaffolding extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, gm.Mode.IM, extra
		@x += gm.TILE_SIZE

class gm.Scenery.Warrior extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@x += gm.TILE_SIZE
		@y +=gm.TILE_SIZE/2

class gm.Scenery.Kiwi extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@x += gm.TILE_SIZE


class gm.Scenery.Arch extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@x += gm.TILE_SIZE



class gm.Scenery.Gear extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@anchor.setTo(0.5, 0.5)
		angle = 360
		if @extra.reverse
			angle *= -1
		@tween = @game.add.tween(@).to( {angle: angle}, 3000, Phaser.Easing.Linear.None, true).loop(true);

class gm.Scenery.Gear2 extends gm.Scenery.Gear
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id+'2', extra


class gm.Scenery.BadassDoor extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@animations.add('closed', [1])
		@animations.add('open', [0])
		@animations.play('closed', 10, true)

		@y -= gm.TILE_SIZE/2
		@x += gm.TILE_SIZE*2.5

class gm.Scenery.Furnace extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@animations.add('on', [1])
		@animations.add('off', [0])
		@animations.play((if extra.on then 'on' else 'off'), 10, true)
		@anchor.setTo(.5,.5)

		@x += @width-gm.TILE_SIZE*1.5
		@y += @height-gm.TILE_SIZE/2

	turnon: ->
		@animations.play('on', 10, true)
	turnoff: ->
		@animations.play('off', 10, true)

class gm.Scenery.Pipe extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id + (if extra.small then '_small' else ''), extra.mode, extra
		@animations.add('down', [3])
		@animations.add('up', [2])
		@animations.add('left', [0])
		@animations.add('right', [1])
		@animations.play(extra.side.toLowerCase(), 10, true)
		@x +=gm.TILE_SIZE/2
		@y +=gm.TILE_SIZE/2

class gm.Scenery.PipeBend extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id + (if extra.small then '_small' else '') + (if extra.out then '_out' else '_in'), extra.mode, extra
		@animations.add('nw', [3])
		@animations.add('ne', [2])
		@animations.add('se', [0])
		@animations.add('sw', [1])
		@animations.play(extra.side, 10, true)

		@y += gm.TILE_SIZE*1.5
		@x += gm.TILE_SIZE*1.5
		
class gm.Scenery.PipeSide extends gm.Scenery.Item
	constructor: (game, x, y, id, extra) ->
		super game, x, y, id, extra.mode, extra
		@animations.add('up', [0])
		@animations.add('down', [2])
		@animations.add('left', [3])
		@animations.add('right', [1])
		@animations.play(extra.side, 10, true)
		@anchor.setTo(.5,.5);
		@y +=gm.TILE_SIZE*3.5
		@x +=gm.TILE_SIZE*3.5
	
		
		if extra.flip == 'x'
			@scale.x *= -1
		if extra.flip == 'y'
			@scale.y *= -1


gm.Scenery.make = (game, x, y, id, extra) ->
	res = null
	switch id
		when 'torch'
			res = new gm.Scenery.Lamp(game, x, y, 'torch', extra)
		when 'geartrigger'
			res = new gm.Scenery.GearTrigger(game, x, y, 'gear', extra)
		when 'gear'
			res = new gm.Scenery.Gear(game, x, y, 'gear', extra)
		when 'gear2'
			res = new gm.Scenery.Gear2(game, x, y, 'gear', extra)
		when 'badassdoor'
			res = new gm.Scenery.BadassDoor(game, x, y, 'badassdoor', extra)
		when 'arch'
			res = new gm.Scenery.Arch(game, x, y, 'arch', extra)
		when 'furnace'
			res = new gm.Scenery.Furnace(game, x, y, 'furnace', extra)
		when 'kiwi'
			res = new gm.Scenery.Kiwi(game, x, y, 'kiwi', extra)
		when 'warrior'
			res = new gm.Scenery.Warrior(game, x, y, 'warrior', extra)
		when 'pipe'
			res = new gm.Scenery.Pipe(game, x, y, 'pipe', extra)
		when 'scaffolding'
			res = new gm.Scenery.Scaffolding(game, x, y, 'scaffolding', extra)
		when 'pipeside'
			res = new gm.Scenery.PipeSide(game, x, y, 'pipeside', extra)
		when 'pipebend'
			res = new gm.Scenery.PipeBend(game, x, y, 'pipebend', extra)
		else throw 'jconnais pas ' + id + ' batar'
	return res