class mw.World
	constructor: (@data) ->
		console.log 'new world'

		mw.terrain = new mw.Terrain

		#if mw.models
		#	true
		

		@props = []
		@cached = 0
		@queue = 0

		for p in @data
			if typeof p is "object"
				@cache p.model

		@doskybox()

	doskybox: ->

		#imagePrefix = "models/dawnmountain-";
		#directions  = ["xpos", "xneg", "ypos", "yneg", "zpos", "zneg"];
		#imageSuffix = ".png";
		geometry = new THREE.CubeGeometry 8192*2, 8192*2, 4069

		shader = THREE.ShaderUtils.lib["cube"]
		uniforms = THREE.UniformsUtils.clone shader.uniforms
		uniforms['tCube'].texture = asd
		
		loader = new THREE.TGALoader
		loader.load 'models/tx_sky_clear.tga', (asd) ->
			asd.wrapS = asd.wrapT = THREE.RepeatWrapping
			#asd.repeat.set 1, 1

			material = new THREE.MeshShaderMaterial
				fragmentShader: shader.fragmentShader
			    vertexShader: shader.vertexShader
			    uniforms: uniforms

			@skybox = new THREE.Mesh geometry, material
			#@skybox.position.set mw.terrain.mx, mw.terrain.my, -500

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