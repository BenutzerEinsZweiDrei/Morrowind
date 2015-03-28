mw.boot = ->
	container = document.createElement 'div'
	document.body.appendChild container

	@camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 1, 2000
	@camera.position.z = 100

	@scene = new THREE.Scene()

	@scene.add new THREE.AmbientLight 0x444444

	directionalLight = new THREE.DirectionalLight 0xffeedd
	directionalLight.position.set( 0, 0, 1 ).normalize()
	@scene.add directionalLight

	THREE.Loader.Handlers.add /\.dds$/i, new THREE.DDSLoader
	THREE.Loader.Handlers.add /\.tga$/i, new THREE.TGALoader

	@renderer = new THREE.WebGLRenderer
	@renderer.setPixelRatio window.devicePixelRatio
	@renderer.setSize window.innerWidth, window.innerHeight
	container.appendChild @renderer.domElement

	document.addEventListener 'mousemove', onDocumentMouseMove, false

	#window.addEventListener 'resize', onWindowResize, false

	animate()

	true

onDocumentMouseMove = (event) ->
	windowHalfX = window.innerWidth / 2
	windowHalfY = window.innerHeight / 2

	mw.mouseX = ( event.clientX - windowHalfX ) / 2
	mw.mouseY = ( event.clientY - windowHalfY ) / 2
	
	true

animate = ->
	requestAnimationFrame animate
	render.call mw

	true

render = ->
	@camera.position.x += ( @mouseX - @camera.position.x ) * .05
	@camera.position.y += ( - @mouseY - @camera.position.y ) * .05

	@camera.lookAt @scene.position

	@renderer.render @scene, @camera

	true