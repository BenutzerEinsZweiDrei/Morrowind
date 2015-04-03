root = exports ? this

mw = root.mw =
	gots: 0
	gets: 3

	world: null
	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]


$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	mw.resources.call mw

	mw.after.call mw

	true

mw.resources = ->
	@vvardenfell = new Image 2688, 2816
	@vvardenfell.src = 'vvardenfell.bmp'

	@vclr = new Image 2688, 2816
	@vclr.src = 'vvardenfell-vclr.bmp'

	loader = new THREE.TGALoader
	loader.load 'models/water00.tga', (asd) ->
		asd.wrapS = asd.wrapT = THREE.RepeatWrapping
		asd.repeat.set 32, 32
		mw.watertga = asd
		mw.got.call mw
	
	@vvardenfell.onload = @vclr.onload = ->
		mw.got.call mw

	true

mw.got = ->
	if ++@gots is @gets
		@after()

	true

mw.after = ->
	$.getJSON "seydaneen.json", (data) ->
			mw.world = new mw.World data
		
	mw.animate()

	true

# definitions of insanity

