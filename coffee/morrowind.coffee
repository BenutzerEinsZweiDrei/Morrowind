root = exports ? this

mw = root.mw =
	gots: 0
	gets: 2

	world: null
	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]
	preloads: [
		'models/tx_bc_dirt.tga'
		'models/tx_bc_moss.tga'
		'models/tx_bc_mud.tga'
	]
	textures: []


$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	mw.resources.call mw

	true

mw.resources = ->
	@vvardenfell = new Image 2688, 2816
	@vvardenfell.src = 'vvardenfell.bmp'

	@vclr = new Image 2688, 2816
	@vclr.src = 'vvardenfell-vclr.bmp'

	@vtex = new Image 672, 704
	@vtex.src = 'vvardenfell-vtex3.bmp'

	@preloads.push "models/water#{n}.tga" for n in [0..31]

	@gets += @preloads.length

	for f, i in @preloads
		go = ->
			a = f
			loader = new THREE.TGALoader
			loader.load a, (asd) ->
				asd.wrapS = asd.wrapT = THREE.RepeatWrapping
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