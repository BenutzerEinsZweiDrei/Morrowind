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
			for c, i in object.children
				console.log "traversing #{i}"
				if c.material.map
					c.material.map.needsUpdate = true
					c.material.map.onUpdate = ->
						console.log 'onupdate'
						if @wrapS isnt THREE.RepeatWrapping or @wrapT isnt THREE.RepeatWrapping
							@wrapS = THREE.RepeatWrapping
							@wrapT = THREE.RepeatWrapping
							@needsUpdate = true
			console.log "put #{model}"
			mw.world.cachcb()

		# console.log loader
		loader = new THREE.OBJMTLLoader
		loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

		true

	fuckoff: ->
		true