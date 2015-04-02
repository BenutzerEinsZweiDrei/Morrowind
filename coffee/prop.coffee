class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = @raw.x
		@y = @raw.y
		@z = @raw.z
		@r = @raw.r - 360
		@scale = @raw.scale or 0


		@mesh = mw.models[@model].clone()
		@mesh.position.set @x, @y, @z
		
		@mesh.scale.set @scale, @scale, @scale if @scale
		
		@mesh.rotation.z = @r * Math.PI / 180

		mw.scene.add @mesh