class mw.World
	constructor: (@data) ->
		console.log 'new world'

		#if mw.models
		#	true

		@props = []
		@cached = 0
		for p in @data
			@cache p.model

		

	cachcb: () ->
		@cached++
		if @cached >= @data.length
			@ransack()

		true

	ransack: () ->
		for p in @data
			@props.push new mw.Prop p

		true

	cache: (model) ->
		cb = (object) ->
			mw.models[model] = object
			console.log "put #{model}"
			mw.world.cachcb()

		# console.log loader
		loader = new THREE.OBJMTLLoader
		loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

		true

	fuckoff: ->
		true