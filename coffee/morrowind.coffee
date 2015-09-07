root = exports ? this

mw = root.mw =
	freeze: false
	gots: 0
	gets: 3

	keys: []
	world: null
	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]
	pretex: [ # most horrible name
		'cat.dds'
		'tx_sky_clear.dds'
		'tx_bc_mud.dds'
		'tx_bc_dirt.dds'
		'tx_bc_moss.dds'
	]
	blues: {
		'230': 'tx_bc_moss.dds'
		'214': 'tx_bc_dirt.dds'
		'247': 'tx_bc_mud.dds'
	}
	textures: []
	wireframe: new THREE.MeshBasicMaterial wireframe: true, transparent: true, opacity: .5


$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	mw.produceterrain.call mw

	mw.resources.call mw

	true

document.onkeydown = document.onkeyup = (event) ->
	k = event.keyCode

	if event.type is 'keydown' and mw.keys[k] isnt 2
		mw.keys[k] = 1
	else if event.type is 'keyup'
		#console.log('key up')
		mw.keys[k] = 0

	if not mw.keys[ k ]
		delete mw.keys[k]

	if k is 114
		event.preventDefault()
	
	#console.log mw.keys

	if mw.lightbox
		mw.lightbox.key()

	true

mw.resources = ->
	@vvardenfell = new Image 2688, 2816
	@vvardenfell.src = 'textures/vvardenfell.bmp'

	@vclr = new Image 2688, 2816
	@vclr.src = 'textures/vvardenfell-vclr.bmp'

	@vtex = new Image 672, 704
	@vtex.src = 'textures/vvardenfell-vtex3.bmp'

	@pretex.push "water/water#{n}.dds" for n in [0..31]

	@gets += @pretex.length

	for f, i in @pretex
		go = ->
			a = f
			loader = new THREE.DDSLoader
			loader.load "textures/#{f}", (asd) ->
				asd.wrapS = asd.wrapT = THREE.RepeatWrapping
				asd.anisotropy = mw.maxAnisotropy
				asd.repeat.set 64, 64
				mw.textures[a] = asd
				console.log "got #{a}"
				mw.got.call mw

		go()
	
	@vvardenfell.onload = @vclr.onload = @vtex.onload = ->
		mw.got.call mw

	true

mw.got = ->
	if ++@gots is @gets
		console.log 'got all preloads'
		@after()

	true

mw.after = ->
	$.getJSON "seydaneen.json", (data) ->
		mw.world = new mw.World data
		
	mw.animate()

	true

# definitions of insanity

mw.texture = (file) ->
	p = file

	THREE.ImageUtils.loadTexture p

	if mw.textures[p]
		return  mw.textures[p]
	else
		go = ->
			loader = new THREE.TGALoader
			console.log loader
			i = p
			loader.load p, (asd) ->
				#asd.wrapS = asd.wrapT = THREE.RepeatWrapping
				#asd.repeat.set 64, 64
				mw.textures[i] = asd
				return

		go()

	true