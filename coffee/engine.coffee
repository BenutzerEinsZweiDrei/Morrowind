# this init is necessary or we corrupt the matrix
mw.mouseX = 0
mw.mouseY = 0

windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2


mw.boot = () ->
	container = document.createElement 'div'
	document.body.appendChild container

	@camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 20, 50000
	@camera.position.set -13088.357563362384, -70417.86172521245, 675.7888756651994
	@camera.up = new THREE.Vector3 0, 0, 1

	@controls = new THREE.FirstPersonControls @camera
	@controls.movementSpeed = 1000
	@controls.lookSpeed = 0.25

	#@controls.object.lookAt new THREE.Vector3 -11812.294149667212, -70441.11573786382, 417.64573489132664

	# scene
	@scene = new THREE.Scene
	#@scene.fog = new THREE.FogExp2 0xefd1b5, 0.0002
	@scene.fog = new THREE.Fog 0xefd1b5, 2250, 9000
	#@scene.rotation.z = 180 * Math.PI / 180

	@scene.add new THREE.AmbientLight mw.AmbientDay

	@sun = new THREE.DirectionalLight mw.SunDay, 1
	@sun.name = 'Sun ^^'
	@sun.position.set -9736.193505934018, -71181.47477616863, 1385.0809414861014

	# @sun.rotation.set -2.861205354046808, -0.9215890070515675, -2.9161043692883983
	@sun.target.position.set -11224, -70869, 300

	@sun.castShadow = true
	# @sun.shadow.bias = - 0.01
	@sun.shadow.darkness = 5

	span = 1500
	@sun.shadow.camera.near = 5
	@sun.shadow.camera.far = 6000
	@sun.shadow.camera.right = span
	@sun.shadow.camera.left = -span
	@sun.shadow.camera.top	= span
	@sun.shadow.camera.bottom = -span

	@sun.shadow.mapSize.width = 2048
	@sun.shadow.mapSize.height = 2048
	@scene.add @sun
	@scene.add @sun.target
	# @scene.add new THREE.CameraHelper @sun.shadow.camera

	wisp = new THREE.Light 0x0000cc
	wisp.position.set -11738.976, -70195.289, 385.415
	@scene.add wisp

	THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader

	@renderer = new THREE.WebGLRenderer antialias: true

	@maxAnisotropy = @renderer.getMaxAnisotropy()

	@renderer.setPixelRatio window.devicePixelRatio
	@renderer.setSize window.innerWidth, window.innerHeight
	@renderer.shadowMap.enabled = true
	@renderer.shadowMap.type = THREE.PCFShadowMap

	@stats = new Stats()
	@stats.domElement.style.position = 'absolute'
	@stats.domElement.style.top = '0px'
	container.appendChild @stats.domElement
	

	container.appendChild @renderer.domElement

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

	if mw.keys[77] is 1
		mw.freeze = ! mw.freeze

	if mw.keys[20] is 1
		mw.slow = ! mw.slow

		if mw.slow
			mw.controls.movementSpeed = 200
			mw.controls.lookSpeed = 0.15
		else
			mw.controls.movementSpeed = 1000
			mw.controls.lookSpeed = 0.25

	if mw.world
		mw.world.step()

	if mw.water
		mw.water.material.uniforms.time.value += 1.0 / 60.0;

	render.call mw
	mw.stats.update()

	for k, i in mw.keys
		if k
			mw.keys[i] = 2

	return

clock = new THREE.Clock()
render = ->

	angle = Date.now()/200 * Math.PI;
	# @sun.position.x	= -13222.207 + (Math.cos(angle*-0.1)*600);
	# @sun.position.y	= -72304.219 + (Math.sin(angle*-0.1)*600);
	# @sun.position.z	= 800 + (Math.sin(angle*0.5)*100);

	x = -11576.443208275043 - -9736.193505934018
	y = -70815.55892959078 - -71181.47477616863
	z = 381.1055788146208 - 1385.0809414861014
	mw.sun.position.set mw.camera.position.x - x, mw.camera.position.y - y, mw.camera.position.z - z

	x = -11224 - -9736.193505934018
	y = -70869 - -71181.47477616863
	z = 300 - 1385.0809414861014
	mw.sun.target.position.set mw.sun.position.x + x, mw.sun.position.y + y, mw.sun.position.z + z

	#@camera.lookAt new THREE.Vector3 -12000.271,-70296.516, 270.629 #@scene.position
	#@camera.rotation.y += 180 * Math.PI / 180

	if mw.water
		mw.water.render()

	THREE.AnimationHandler.update clock.getDelta()

	@renderer.render @scene, @camera

	return