class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = @raw.x
		@y = @raw.y
		@z = @raw.z
		@r = Math.abs @raw.r - 360
		@scale = @raw.scale or 0
		@transparent = @raw.transparent or false

		@mesh = mw.models[@model].clone()
		@mesh.position.set @x, @y, @z

		#@mesh.castShadow = true
		#@mesh.receiveShadow = false
		
		@mesh.scale.set @scale, @scale, @scale if @scale
		
		@mesh.rotation.z = @r * Math.PI / 180

		if @transparent
			console.log 'TRANSPARENT'
			console.log @mesh

		if @model is 'ex_common_house_tall_02'
			mw.target = this

		mw.scene.add @mesh

	step: ->

		true