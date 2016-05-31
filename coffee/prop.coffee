class mw.Prop
	constructor: (@data) ->
		@model = @data.model
		@x = @data.x
		@y = @data.y
		@z = @data.z
		@r = Math.abs @data.r - 360
		
		@scale = @data.scale or 0
		@transparent = @data.transparent or false

		# return unless mw.models[@model]?

		return unless mw.models[@model] isnt -1

		# return if @data.hidden

		@mesh = mw.models[@model].scene.clone()

		#@mesh.castShadow = true
		#@mesh.receiveShadow = true

		@mesh.scale.set @scale, @scale, @scale if @scale

		@pose()

		if @model is 'ex_common_house_tall_02'
			mw.target = this

		mw.scene.add @mesh

	pose: ->
		@mesh.position.set @x, @y, @z
		@mesh.rotation.z = @r * Math.PI / 180
		return

	step: ->

		true