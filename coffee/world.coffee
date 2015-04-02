class mw.World
	constructor: (@data) ->
		console.log 'new world'

		#if mw.models
		#	true

		@props = []
		@cached = 0
		@queue = 0

		for p in @data
			if typeof p is "object"
				@cache p.model

	cachcb: () ->
		@cached++
		if @cached >= @queue
			@ransack()

		true

	ransack: () ->
		for p in @data
			if typeof p is "object"
				@props.push new mw.Prop p

		true

	cache: (model) ->
		@queue++
		cb = (object) ->
			mw.models[model] = object
			for c, i in object.children
				if c.material.map
					c.material.map.needsUpdate = true
					c.material.map.onUpdate = ->
						if @wrapS isnt THREE.RepeatWrapping or @wrapT isnt THREE.RepeatWrapping
							@wrapS = THREE.RepeatWrapping
							@wrapT = THREE.RepeatWrapping
							@needsUpdate = true
			mw.world.cachcb()

		# console.log loader
		loader = new THREE.OBJMTLLoader
		loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

		true

	fuckoff: ->
		true