class mw.Prop
	constructor: (@raw) ->
		@model = @raw.model
		@x = @raw.x
		@y = @raw.y
		@z = @raw.z
		@r = @raw.r

		@mesh = mw.models[@model].clone()
		@mesh.position.set @x, @y, @z
		@mesh.rotation.z = @r * Math.PI / 180
		
		console.log @mesh
		for c, i in @mesh.children
			c.material.wireframe = true if i is @mesh.children.length-1
		#@mesh.material.wireframe = true
		
		mw.scene.add @mesh

	idiot: (idiot) ->
		true

	idiot: ->
		true # if this is idiot