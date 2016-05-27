class mw.World
	constructor: (@data) ->

		@x = -2
		@y = -9

		@cells = []

		#for i in [0..8]
		#	@cells.push new mw.Cell @x + mw.circle[i].x, @y + mw.circle[i].y
		#new mw.Cell @x, @y

		#if mw.models
		#	true
		
		@doskybox()

		@props = []
		@cached = 0
		@queue = 0

		for p in @data
			if typeof p is "object"
				@cache p

		@waterStep = 0
		@waterMoment = 0

		@cellcheck()

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

	cache: (p) ->
		model = p.model

		@queue++

		cb = (dae) ->
			console.log dae

			dad = dae.scene

			mw.models[model] = dad

			dad.scale.x = dad.scale.y = dad.scale.z = 1
			dad.updateMatrix()

			dad.traverse (child) ->
				if child instanceof THREE.Mesh
					console.log 'crayons'
					child.material.vertexColors = THREE.VertexColors

			mw.world.cachcb()
			return

		loader = new THREE.ColladaLoader
		loader.load "models/#{model}.dae", cb

		true

	cellcheck: ->
		#for c in @cells
			#if 2 > Math.abs(c.x - mw.ply.x) or 2 > Math.abs(c.y - mw.ply.y)
				#console.log 'outside boundary'
				# out of context

		for i in [0..8] # makes 9
			@cells.push new mw.Cell @x + mw.circle[i].x, @y + mw.circle[i].y
		0

	step: ->


		#if mw.water
			#THREE.ShaderLib['mirror'].uniforms.time.value += mw.delta

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