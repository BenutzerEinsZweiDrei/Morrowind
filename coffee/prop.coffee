class mw.Prop
	constructor: (@data) ->
		data = @data

		@type = 'Prop'

		@model = data.model
		@x = data.x
		@y = data.y
		@z = data.z
		@r = Math.abs data.r - 360
		@r *= mw.DEGTORAD
		
		@scale = data.scale or 0
		@transparent = data.transparent or false

		@mesh = null

		@shape()
		@pose()

		@mesh.updateMatrix()
		@mesh.updateMatrixWorld()

		@mesh.matrixAutoUpdate = false

		mw.scene.add @mesh if @mesh?

	shape: ->
		return unless mw.models[@model]? and mw.models[@model] isnt -1

		@mesh = mw.models[@model].scene.clone()

		@mesh.scale.set @scale, @scale, @scale if @scale

		0

	pose: ->
		@mesh.position.set @x, @y, @z
		@mesh.rotation.z = @r
		0

	step: ->

		true