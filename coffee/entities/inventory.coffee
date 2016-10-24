class gm.Inventory extends Phaser.Group

	constructor: (@game) ->
		super @game, null, 'inventory'
		@items = []

	addItem: (item_id) ->
		@items.push +item_id
		@rerender()


	hasItem: (item_id) ->
		return @items.indexOf(+item_id) != -1

	removeItem: (item_id) ->
		i = @items.indexOf +item_id
		if i != -1
			@items.splice(i, 1)
		@rerender()

	rerender: ->
		@removeAll(true)
		for item, i in @items
			s = @game.add.sprite(40*(i+1)-30, 30, 'item_' + item)
			ratio = s.width/s.height
			s.height = gm.TILE_SIZE
			s.width = gm.TILE_SIZE * ratio
			s.fixedToCamera = true
			@add s