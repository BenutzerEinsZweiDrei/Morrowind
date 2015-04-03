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
	@controls.movementSpeed = 1000
	@controls.lookSpeed = 0.5

	#@controls.object.lookAt new THREE.Vector3 -11812.294149667212, -70441.11573786382, 417.64573489132664

	# scene
	@scene = new THREE.Scene
	@scene.fog = new THREE.FogExp2 0xefd1b5, 0.00015
	#@scene.rotation.z = 180 * Math.PI / 180

	ambient = 
	@scene.add new THREE.AmbientLight 0x444444

	directionalLight = new THREE.DirectionalLight 0xffeedd
	directionalLight.position.set( 0, 0, 1 ).normalize()
	@scene.add directionalLight

	# model

	#THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader
	THREE.Loader.Handlers.add /\.tga$/i, new THREE.TGALoader

	@renderer = new THREE.WebGLRenderer
	@renderer.setPixelRatio window.devicePixelRatio
	@renderer.setSize window.innerWidth, window.innerHeight
	container.appendChild @renderer.domElement

	document.addEventListener 'mousemove', onDocumentMouseMove, false

	window.addEventListener 'resize', onWindowResize, false

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

	mw.controls.update 0.016

	render.call mw

	return

render = ->

	#@camera.position.x = -11699.271 + @mouseX
	#@camera.position.y = -70396.516 + @mouseY

	#@camera.lookAt new THREE.Vector3 -12000.271,-70296.516, 270.629 #@scene.position
	#@camera.rotation.y += 180 * Math.PI / 180

	@renderer.render @scene, @camera

	return