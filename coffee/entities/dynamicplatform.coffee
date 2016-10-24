class gm.DynamicPlatform extends gm.Platform

	constructor: (@game, xx, yy, ww, hh, keyRe, keyIm, triggers, data) ->
		super game, xx, yy, ww, hh, keyRe, keyIm, data
		@triggers = triggers or []

	applyEffect: (sprite) ->

	resetTriggers: ->	
		for t in @triggers	
			t.reset()

	allTriggersFired: ->
		for t in @triggers
			if !t.fired
				return false
		return true		
