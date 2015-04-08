class mw.World
	constructor: (@data) ->

		@x = -2
		@y = -9

		@cells = []

		for i in [0..8]
			@cells.push new mw.Cell @x + mw.circle[i].x, @y + mw.circle[i].y
		#new mw.Cell @x, @y

		#if mw.models
		#	true
		
		@doskybox()

		@props = []
		@cached = 0
		@queue = 0

		for p in @data
			if typeof p is "object"
				@cache p.model

		@waterStep = 0
		@waterMoment = 0

	doskybox: ->
		geometry = new THREE.CubeGeometry 8192*3, 8192*3, 8192
		
		t = mw.textures['tx_sky_clear.dds']
		t.repeat.set 1, 1

		array = []
		for i in [0..5]
			array.push new THREE.MeshBasicMaterial
				map: t
				side: THREE.BackSide

		material = new THREE.MeshFaceMaterial array
		@skybox = new THREE.Mesh geometry, material
		@skybox.position.set (@x * 8192) + 4096, (@y * 8192) + 4096, -255
		mw.scene.add @skybox
	
		true

	cachcb: () ->
		@cached++
		if @cached >= @queue
			@ransack()

		true

	ransack: () ->
		for p in @data
			if typeof p is "object"
				@props.push new mw.Prop p

		mw.watershed.call mw

		true

	cache: (model) ->
		@queue++
		cb = (object) ->
			mw.models[model] = object
			console.log object if model is 'ex_common_house_tall_02'
			
			for c, i in object.children
				#if not c.name
					#c.visible = false

				if m = c.material.map
					m.needsUpdate = true
					m.repeat.y = -1
					###c.material.map.onUpdate = ->
						@repeat.y = -1
						if @wrapS isnt THREE.RepeatWrapping or @wrapT isnt THREE.RepeatWrapping
							@wrapS = THREE.RepeatWrapping
							@wrapT = THREE.RepeatWrapping
							@needsUpdate = true###
			mw.world.cachcb()

		# console.log loader
		loader = new THREE.OBJMTLLoader
		loader.load "models/#{model}.obj", "models/#{model}.mtl", cb

		true

	step: ->
		
		if mw.water
			THREE.ShaderLib['mirror'].uniforms.time.value += mw.delta

		return

		if mw.water
			@waterMoment += mw.delta

			if @waterMoment >= 0.08
				#console.log 'yep'
				@waterStep = if @waterStep < 30 then @waterStep + 1 else 0
				
				t = mw.textures["water/water#{@waterStep}.dds"]
				t.repeat.set 64, 64

				mw.waterMaterial.map = t

				@waterMoment = 0

		true