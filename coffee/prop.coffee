class mw.Prop
	constructor: (@data) ->
		d = @data

		@type = 'Prop'

		@x = d.x
		@y = d.y
		@z = d.z

		unless @r
			@r = Math.abs d.r - 360
			@r *= mw.DEGTORAD

		@mesh = null

		@shape()
		@pose()

		@mesh.updateMatrix()
		@mesh.updateMatrixWorld()

		@mesh.matrixAutoUpdate = false

		mw.scene.add @mesh if @mesh?

	shape: ->
		@model = @data.model

		return unless mw.models[@model]? and mw.models[@model] isnt -1

		@mesh = mw.models[@model].scene.clone()

		@mesh.name = 'Prop'

		@mesh.scale.set @scale, @scale, @scale if @data.scale

		0

	pose: ->
		@mesh.position.set @x, @y, @z
		@mesh.rotation.z = @r
		0

	step: ->

		true