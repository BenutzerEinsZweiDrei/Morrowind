# this init is necessary or we corrupt the matrix
mw.mouseX = 0
mw.mouseY = 0

windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2


mw.boot = () ->
	container = document.createElement 'div'
	document.body.appendChild container

	camera = @camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 20, 50000
	# mw.camera.position.set -10608, -71283, 1008 # Arrille's View
	mw.camera.position.set -10500, -74902, 997 # Ship's View
	
	camera.up = new THREE.Vector3 0, 0, 1

	###
	camera.rotation.y = 1
	camera.rotation.x = 1.1063848995163013
	camera.rotation.z = 0.40295405886168556
	###

	controls = @controls = new THREE.FirstPersonControls camera
	controls.movementSpeed = 1000 # 100
	controls.lookSpeed = .25 # 0.01

	# Arrille's View
	# controls.lat = -26.743659000000005
	# controls.lon = -137.39699074999993

	# Ship's View
	controls.lat = -18
	controls.lon = -36

	# @controls.object.lookAt new THREE.Vector3 -11812, -70441, 417

	scene = @scene = new THREE.Scene

	# @scene.fog = new THREE.FogExp2 0xefd1b5, 0.0002
	scene.fog = new THREE.Fog mw.Fog, 2250, 9000

	scene.add new THREE.AmbientLight mw.Ambient

	sun = @sun = new THREE.DirectionalLight mw.Sun, 1
	sun.name = 'Sun ^^'
	sun.position.set -9736-1000, -71181+1200, 1385
	sun.target.position.set -11224-1000, -70869+1200, 300

	sun.castShadow = true
	sun.shadow.darkness = 5

	sun.shadow.camera.near = 5
	sun.shadow.camera.far = 3000
	sun.shadow.camera.right = 1000
	sun.shadow.camera.left = -800
	sun.shadow.camera.top	= 500
	sun.shadow.camera.bottom = -1500

	sun.shadow.mapSize.width = 2048
	sun.shadow.mapSize.height = 2048
	scene.add sun
	scene.add sun.target
	# scene.add new THREE.CameraHelper sun.shadow.camera

	wisp = new THREE.PointLight 0xf58c28, 1, 100
	wisp.position.set -11738.976, -70195.289, 385.415
	scene.add wisp

	THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader

	renderer = @renderer = new THREE.WebGLRenderer antialias: true

	@maxAnisotropy = renderer.getMaxAnisotropy()

	renderer.setPixelRatio window.devicePixelRatio
	renderer.setSize window.innerWidth, window.innerHeight
	renderer.shadowMap.enabled = true
	renderer.shadowMap.type = THREE.PCFShadowMap

	# stats = @stats = new Stats()
	# stats.domElement.style.position = 'absolute'
	# stats.domElement.style.top = '0px'
	# container.appendChild stats.domElement

	container.appendChild renderer.domElement

	document.addEventListener 'mousemove', onDocumentMouseMove, false

	window.addEventListener 'resize', onWindowResize, false

	@clock = new THREE.Clock()

	true

audios: ->
	loader = new THREE.SEA3D
		autoPlay : true # Auto play animations
		container : scene # Container to add models

onWindowResize = () ->

	windowHalfX = window.innerWidth / 2
	windowHalfY = window.innerHeight / 2

	mw.camera.aspect = window.innerWidth / window.innerHeight
	mw.camera.updateProjectionMatrix()

	mw.renderer.setSize window.innerWidth, window.innerHeight

	return

onDocumentMouseMove = ( event ) ->

	mw.mouseX = ( event.clientX - windowHalfX ) * 2
	mw.mouseY = ( event.clientY - windowHalfY ) * 2

	return

mw.animate = () ->

	requestAnimationFrame mw.animate

	mw.delta = mw.clock.getDelta()

	if not mw.freeze
		mw.controls.update mw.delta

	if mw.keys[77] is 1 # m
		mw.freeze = ! mw.freeze

	if mw.keys[78] is 1 # n
		mw.shadowing = ! mw.shadowing

		if not mw.shadowing
			mw.sun.position.set -9736-1000, -71181+1200, 1385
			mw.sun.target.position.set -11224-1000, -70869+1200, 300

	if mw.keys[20] is 1 # caps lock
		mw.slow = ! mw.slow

		if mw.slow
			mw.controls.movementSpeed = 200
			mw.controls.lookSpeed = 0.15
		else
			mw.controls.movementSpeed = 1000
			mw.controls.lookSpeed = 0.25

	if mw.keys[72] is 1
		;
		# remove hud

	if mw.world?
		mw.world.step()

	if mw.water
		mw.water.material.uniforms.time.value += 1.0 / 60.0;

	render.call mw

	# mw.stats.update()

	for k, i in mw.keys
		if k
			mw.keys[i] = 2

	return

clock = new THREE.Clock()
render = ->

	if mw.shadowing
		x = -11576 - -9736
		y = -70815 - -71181
		z = 381 - 1385
		mw.sun.position.set mw.camera.position.x - x, mw.camera.position.y - y, mw.camera.position.z - z

		x = -11224 - -9736
		y = -70869 - -71181
		z = 300 - 1385
		mw.sun.target.position.set mw.sun.position.x + x, mw.sun.position.y + y, mw.sun.position.z + z

	if mw.water
		mw.water.render()

	THREE.AnimationHandler.update clock.getDelta()

	@renderer.render @scene, @camera

	return