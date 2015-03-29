root = exports ? this

mw = root.mw =
	world: null

$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	#$.getJSON "seydaneen.json", (data) ->
		#mw.world = new mw.World data
		
	mw.animate()

	true

