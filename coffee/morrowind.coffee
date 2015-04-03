root = exports ? this


$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	$.getJSON "seydaneen.json", (data) ->
		mw.world = new mw.World data
		
	mw.animate()

	true


# definitions of insanity

mw = root.mw =
	world: null
	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]
