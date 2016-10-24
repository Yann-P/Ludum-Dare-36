class gm.ItemTrigger extends gm.Trigger

	constructor: (id, x, y, mode, automatic, item_id, data) ->
		@item_id = item_id
		super id, x, y, mode, automatic, data