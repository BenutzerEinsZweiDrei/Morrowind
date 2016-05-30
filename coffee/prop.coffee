class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = @raw.x
		@y = @raw.y
		@z = @raw.z
		@r = Math.abs @raw.r - 360
		
		@scale = @raw.scale or 0
		@transparent = @raw.transparent or false

		# return unless mw.models[@model]?

		return unless mw.models[@model] isnt -1

		return if @raw.hidden

		@mesh = mw.models[@model].scene.clone()

		#@mesh.castShadow = true
		#@mesh.receiveShadow = true

		@mesh.position.set @x, @y, @z

		
		@mesh.scale.set @scale, @scale, @scale if @scale
		
		@mesh.rotation.z = @r * Math.PI / 180

		if @model is 'ex_common_house_tall_02'
			mw.target = this

		mw.scene.add @mesh

	step: ->

		true