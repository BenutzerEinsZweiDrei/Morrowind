class mw.World
	constructor: (data) ->
		console.log 'new world'

		#if mw.models
		#	true

		@props = []
		for p in data
			@cache p.model

		for p in data
			@props.push new mw.Prop p

	cached: () ->

		true

	cache: (model) ->
		cb = (object) ->
			mw.models[model] = object
			mw.world.cached()

		# console.log loader
		loader = new THREE.OBJMTLLoader
		loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

		true

	fuckoff: ->
		true