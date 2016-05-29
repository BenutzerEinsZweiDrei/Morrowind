# this init is necessary or we corrupt the matrix
mw.mouseX = 0
mw.mouseY = 0

windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2


mw.boot = () ->
	container = document.createElement 'div'
	document.body.appendChild container

	@camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 20, 20000
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

	# dawn 0x424a57
	# day 0x898ca0
	# neutral 0x777777
	
	# from Morrowind.ini
	# Sky Sunrise Color=255,100,5
	# Sky Day Color=255,255,255
	# Sky Sunset Color=130,50,130
	# Sky Night Color=020,000,050
	
	# Fog Sunrise Color=255,155,155
	# Fog Day Color=255,201,115
	# Fog Sunset Color=255,100,255
	# Fog Night Color=000,000,150

	AmbientSunrise = 	0x424a57 # Ambient Sunrise Color=066,074,087
	@AmbientDay = 		0x8991a0 # Ambient Day Color=137,145,160
	# Ambient Sunset Color=071,080,092
	# Ambient Night Color=032,039,054

	SunSunrise = 		0xf1b163 # Sun Sunrise Color=241,177,099 f1b163
	SunDay = 			0xffecdd # Sun Day Color=255,236,221
	# Sun Sunset Color=255,089,000
	# Sun Night Color=077,091,124
	# Sun Disc Sunset Color=150,000,000

	@scene.add new THREE.AmbientLight @AmbientDay

	@sun = new THREE.DirectionalLight SunDay, 1
	@sun.name = 'Sun ^^'
	@sun.position.set -9736.193505934018, -71181.47477616863, 1385.0809414861014
	@sun.target.position.set -11224, -70869, 300

	@sun.castShadow = true
	# @sun.shadow.bias = - 0.01
	@sun.shadow.darkness = 5

	@sun.shadow.camera.near = 5
	@sun.shadow.camera.far = 6000
	@sun.shadow.camera.right = 2000
	@sun.shadow.camera.left = -2000
	@sun.shadow.camera.top	= 2000
	@sun.shadow.camera.bottom = -2000

	@sun.shadow.mapSize.width = 2048
	@sun.shadow.mapSize.height = 2048
	@scene.add @sun
	@scene.add @sun.target
	# @scene.add new THREE.CameraHelper @sun.shadow.camera

	###wisp = new THREE.SpotLight( 0x0000cc );
	wisp.name = 'Zrrvrbbr';
	# wisp.angle = Math.PI / 5;
	wisp.penumbra = 0.3
	wisp.position.set -10894, -71081, 1760
	wisp.target.position.set -11374, -70615, 642
	@scene.add wisp.target

	wisp.castShadow = true
	wisp.shadow.camera.near = 8
	wisp.shadow.camera.far = 3000
	wisp.shadow.mapSize.width = 1024
	wisp.shadow.mapSize.height = 1024

	@scene.add wisp
	@scene.add new THREE.CameraHelper wisp.shadow.camera

	@wisp = wisp###

	# test cube:
	###m = new THREE.MeshPhongMaterial
			color: 0xff0000
			shininess: 150
			specular: 0x222222
			shading: THREE.SmoothShading

	g = new THREE.BoxGeometry 1000, 100, 100

	cube = new THREE.Mesh g, m
	cube.position.set -11224, -70869, 300
	cube.castShadow = true
	cube.receiveShadow = true

	@scene.add cube###

	# model

	THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader
	#THREE.Loader.Handlers.add /\.tga$/i, new THREE.TGALoader

	@renderer = new THREE.WebGLRenderer antialias: true

	@maxAnisotropy = @renderer.getMaxAnisotropy()
	#@renderer.shadowMapEnabled = true
	#@renderer.shadowMapType = THREE.PCFSoftShadowMap;

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

	#@camera.lookAt new THREE.Vector3 -12000.271,-70296.516, 270.629 #@scene.position
	#@camera.rotation.y += 180 * Math.PI / 180

	if mw.water
		mw.water.render()

	THREE.AnimationHandler.update clock.getDelta()

	@renderer.render @scene, @camera

	return