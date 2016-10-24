class gm.Trigger

	constructor: (@id, @x, @y, mode, @automatic=false, @data={}) ->
		@mode = parseInt(mode) ? null
		@fired = false

	fire: ->
		@fired = true

	reset: ->
		@fired = false