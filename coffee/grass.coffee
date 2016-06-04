# this is plural
shrubbery =
	Green:
		width: 120
		height: 120
		texture: 'grass/vurt_grass04.dds'

class mw.Grass extends mw.Prop
	constructor: (data) ->

		@shrub = shrubbery[ data.shrub ] or shrubbery.Green

		data.z += @shrub.height / 2
		@r = Math.PI - mw.camera.rotation.y
		
		super data

		@pose()

		@type = 'Grass'

	
	# @Override
	shape: ->
		material = new THREE.MeshLambertMaterial
				map: mw.textures[ @shrub.texture]
				side: THREE.DoubleSide
				transparent: true
				color: 0xcc0000

		geometry = new THREE.PlaneBufferGeometry @shrub.width, @shrub.height, 1

		@mesh = new THREE.Mesh geometry, material
		@mesh.rotation.x = -Math.PI/2
		# @mesh.scale.z = -1

		1

	# @Override
	pose: ->
		@mesh.position.set @x, @y, @z

		@mesh.rotation.y = @r

		0

	# pose: ->