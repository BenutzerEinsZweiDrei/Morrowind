stats = 0

# this init is necessary or we corrupt the matrix
mw.mouseX = 0
mw.mouseY = 0

windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2


mw.boot = () ->
	container = document.createElement 'div'
	document.body.appendChild container

	@camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 1, 10000000
	@camera.position.set -13088.357563362384, -70417.86172521245, 675.7888756651994
	@camera.up = new THREE.Vector3 0, 0, 1


	@controls = new THREE.FirstPersonControls @camera
	@controls.movementSpeed = 200
	@controls.lookSpeed = 0.1

	#@controls.object.lookAt new THREE.Vector3 -11812.294149667212, -70441.11573786382, 417.64573489132664

	# scene
	@scene = new THREE.Scene
	#@scene.fog = new THREE.FogExp2 0xefd1b5, 0.0002
	@scene.fog = new THREE.Fog 0xefd1b5, 2500, 10000
	#@scene.rotation.z = 180 * Math.PI / 180

	# dawn 0x424a57
	# day 0x898ca0
	# neutral 0x777777
	@scene.add new THREE.AmbientLight 0xffffff
	
	@sun = new THREE.SpotLight 0xffeedd
	#@sun.shadowCameraNear 
	@sun.castShadow = true
	@sun.shadowDarkness = 0.5
	@sun.shadowCameraVisible = true

	@sun.target.position.set( -12722.207, -71304.219, 0 );
	#@sun.position.set( -13722.207, -71304.219, 500 ) #.normalize()
	@sun.shadowMapWidth = @sun.shadowMapHeight = 2048
	#@scene.add @sun

	# model

	THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader
	#THREE.Loader.Handlers.add /\.tga$/i, new THREE.TGALoader

	@renderer = new THREE.WebGLRenderer
	#@renderer.shadowMapEnabled = true
	#@renderer.shadowMapType = THREE.PCFSoftShadowMap;

	@renderer.setPixelRatio window.devicePixelRatio
	@renderer.setSize window.innerWidth, window.innerHeight
	

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

	render.call mw

	for k, i in mw.keys
		if k
			mw.keys[i] = 2

	return

render = ->

	angle = Date.now()/200 * Math.PI;
	@sun.position.x	= -13222.207 + (Math.cos(angle*-0.1)*600);
	@sun.position.y	= -72304.219 + (Math.sin(angle*-0.1)*600);
	@sun.position.z	= 800 + (Math.sin(angle*0.5)*100);

	#@camera.position.x = -11699.271 + @mouseX
	#@camera.position.y = -70396.516 + @mouseY

	#@camera.lookAt new THREE.Vector3 -12000.271,-70296.516, 270.629 #@scene.position
	#@camera.rotation.y += 180 * Math.PI / 180

	if mw.water
		mw.mirror.render()

	@renderer.render @scene, @camera

	return