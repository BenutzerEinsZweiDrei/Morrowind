root = exports ? this

mw = root.mw =
	world: null

$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	#$.getJSON "seydaneen.json", (data) ->
		#mw.world = new mw.World data

	loader = new THREE.OBJMTLLoader
	loader.load 'male02/male02.obj', 'male02/male02_dds.mtl', (object) ->
		object.position.y = - 80
		mw.scene.add object
		console.log 'added male02 to scene'
		true

	true