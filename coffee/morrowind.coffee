root = exports ? this

mw = root.mw =
	freeze: false
	gots: 0
	gets: 3

	keys: []
	models: {}
	world: null
	ply: null

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

	# from Morrowind.ini
	# Sky Sunrise Color=255,100,5
	# Sky Day Color=255,255,255
	# Sky Sunset Color=130,50,130
	# Sky Night Color=020,000,050
	
	# Fog Sunrise Color=255,155,155
	# Fog Day Color=255,201,115
	# Fog Sunset Color=255,100,255
	# Fog Night Color=000,000,150

	AmbientSunrise: 	0x424a57 # Ambient Sunrise Color=066,074,087
	AmbientDay: 		0x8991a0 # Ambient Day Color=137,145,160
	# Ambient Sunset Color=071,080,092
	# Ambient Night Color=032,039,054

	SunSunrise: 		0xf1b163 # Sun Sunrise Color=241,177,099 f1b163
	SunDay:				0xffecdd # Sun Day Color=255,236,221
	# Sun Sunset Color=255,089,000
	# Sun Night Color=077,091,124
	# Sun Disc Sunset Color=150,000,000


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
				# console.log "got #{a}"
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

	loader = new THREE.TextureLoader()
	loader.load p
	loader = null

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