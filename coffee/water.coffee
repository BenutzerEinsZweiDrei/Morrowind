mw.watershed = ->
	
	geometry = new THREE.PlaneGeometry 8192*3, 8192*3

	x = (mw.world.x * 8192) + 4096
	y = (mw.world.y * 8192) + 4096

	@waterNormals = new THREE.TextureLoader().load 'textures/waternormals.jpg'
	@waterNormals.wrapS = @waterNormals.wrapT = THREE.RepeatWrapping; 

	@water = new THREE.Water mw.renderer, mw.camera, mw.scene,
			map: mw.textures['water/water0.dds']
			textureWidth: 512,
			textureHeight: 512
			waterNormals: @waterNormals
			alpha: .3
			# transparent: true
			# sunDirection: # mw.sun.position.normalize()
			sunColor: 0xffffff
			waterColor: 0x001e0f
			distortionScale: 50.0
			fog: true


	aMeshMirror = new THREE.Mesh geometry, @water.material
	aMeshMirror.position.set x, y, 0.5

	aMeshMirror.add @water
	# aMeshMirror.rotation.x = - Math.PI * 0.5;
	
	mw.scene.add aMeshMirror

	true