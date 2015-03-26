class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = @raw.x
		@y = @raw.y
		@z = @raw.z
		@r = @raw.r

		@mesh = mw.models[@model]

		mw.scene.add @mesh

	idiot: (idiot) ->
		true

	idiot: ->
		true # if this is idiot