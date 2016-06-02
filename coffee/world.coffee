class mw.World
	constructor: () ->

		# todo: revamp ygky

		@x = -2
		@y = -9

		@cells = []

		#for i in [0..8]
		#	@cells.push new mw.Cell @x + mw.circle[i].x, @y + mw.circle[i].y
		#new mw.Cell @x, @y
		
		@doskybox()

		@props = []

		@cached = 0
		@queue = 0

		for p in mw.props
			@cache p if typeof p is "object"

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
		console.log "#{@cached} >= #{@queue}"
		if @cached >= @queue
			mw.world.ransack()

		true

	ransack: () ->
		for data in mw.props
			if typeof data is "object" and not data.hidden
				@props.push mw.factory data

		for data in mw.grasses
			data.type = 'Grass'
			if typeof data is "object" and not data.hidden
				@props.push mw.factory data

		###mw.controls.movementSpeed = 200
		mw.controls.lookSpeed = 0.15
		mw.controls.lat = -26.743659000000005
		mw.controls.lon = -137.39699074999993
		mw.camera.position.set -10608, -71283, 1008###

		mw.watershed.call mw

		true

	cache: (p) ->
		model = p.model

		return if p.hidden

		if mw.models[model]
			console.log "#{model} already caching"
			return
			
		mw.models[model] = -1
		@queue++

		console.log "queued ##{@queue} #{model}"


		cb = (dae) ->
			showme = true if model is 'ex_common_house_tall_02'

			# console.log dae if showme

			dad = dae.scene

			dad.mw = model

			mw.models[model] = dae

			dad.scale.x = dad.scale.y = dad.scale.z = 1
			dad.updateMatrix()

			dad.traverse (child) ->

				if -1 is mw.noshadow.indexOf model
					child.castShadow = true
					child.receiveShadow = true
					
				if child instanceof THREE.SkinnedMesh

					animation = new THREE.Animation child, child.geometry.animation
					animation.play()

					console.log 'Oh ye'
										
				if child instanceof THREE.Mesh

					#child.geometry.normalsNeedUpdate = true
					#child.geometry.computeFaceNormals()

					child.material.vertexColors = THREE.VertexColors

					child.material.alphaTest = 0.5

					if map = child.material.map

						map.repeat.y = -1

						map.anisotropy = mw.maxAnisotropy

						# map.minFilter = THREE.NearestFilter


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

		p.step() for p in @props

		#if mw.water
			#THREE.ShaderLib['mirror'].uniforms.time.value += mw.delta

		if mw.water
			@waterMoment += mw.delta

			if @waterMoment >= 0.08
				#console.log 'yep'
				@waterStep = if @waterStep < 30 then @waterStep + 1 else 0
				
				t = mw.textures["water/water#{@waterStep}.dds"]
				t.repeat.set 64, 64

				mw.waterNormals.map = t

				@waterMoment = 0

		true