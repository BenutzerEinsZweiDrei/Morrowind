mw.models = [
	"ex_de_docks_steps_01"
]

mw.modelsum = 0

mw.loadmodel = (model) ->
	#hit = @models[model]

	#return unless hit

	model = model

	cb = (object) ->
		mw.models[model] = object
		mw.mesh = object
		#object.position.y = - 80;
		#scene.add object
		console.log "done load"
		mw.modelcb()

	loader = new THREE.OBJMTLLoader
	console.log loader
	loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

	console.log "happens-before load #{mw.mesh}"

	true

mw.modelcb = ->
	if 