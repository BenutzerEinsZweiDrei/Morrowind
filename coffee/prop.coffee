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

		if @scale
			@mesh.scale.set @scale, @scale, @scale

		###rotWorldMatrix = new THREE.Matrix4()
		rotWorldMatrix.makeRotationAxis new THREE.Vector3(0,0,1).normalize(), 0 * Math.PI / 180
		rotWorldMatrix.multiply @mesh.matrix
		@mesh.matrix = rotWorldMatrix
		@mesh.rotation.setFromRotationMatrix @mesh.matrix###
		
		@mesh.rotation.z = @r * Math.PI / 180

		mw.scene.add @mesh