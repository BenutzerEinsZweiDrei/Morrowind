root = exports ? this

mw = root.mw =
	gots: 0
	gets: 2+31

	world: null
	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]
	waters: []


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

	for i in [0..31]
		go = ->
			loader = new THREE.TGALoader
			n = if i < 10 then "0#{i}" else i
			loader.load "models/water#{n}.tga", (asd) ->
				asd.wrapS = asd.wrapT = THREE.RepeatWrapping
				asd.repeat.set 64, 64
				mw.waters[parseInt n] = asd
				console.log "got #{n}"
				mw.got.call mw

		go()
	
	@vclr.onload = @vvardenfell.onload = @vclr.onload = ->
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

