class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = 0#@raw.x
		@y = -80#@raw.y
		@z = 0#@raw.z
		@r = 0#@raw.r

		#@mesh = mw.models[@model].clone()

		#mw.scene.add @mesh

	idiot: (idiot) ->
		true

	idiot: ->
		true # if this is idiot