class mw.Terrain
	constructor: (@x, @y) ->
		@maps()
		@makemasks()

		@geometry = mw.patches.clone()

		@mx = mx = (@x * 8192) + 4096
		@my = my = (@y * 8192) + 4096

		for i in [0..@geometry.vertices.length-1]

			x = @geometry.vertices[i].x
			y = @geometry.vertices[i].y

			px = ((4096+x)/64)
			px /= 2
			py = ((4096+y)/64)
			py /= 2

			# console.log "#{px}, #{py} is #{x}, #{y}"

			p = ((py*65)+px)*4
			#p -= 1

			r = @heights[p]
			g = @heights[p+1]
			b = @heights[p+2]

			if r is 255
				@geometry.vertices[i].z = h
				h = -(255-b) + (255*((g-255)/8))
			else if g
				h = (255*(g/8))+b
			else
				h = b
			
			@geometry.vertices[i].z = h


		@mkground()

		true

	mkground: ->
		m = new THREE.MeshPhongMaterial
			color: 0xa0adaf
			shininess: 150
			specular: 0xffffff
			shading: THREE.SmoothShading

		@material = @splat()

		# geometry = new THREE.PlaneGeometry 8192, 8192

		@geometry.normalsNeedUpdate = true
		@geometry.computeFaceNormals()

		@ground = new THREE.Mesh @geometry, @material
		@ground.position.set @mx, @my, 0

		@ground.receiveShadow = true
		# @ground.castShadow = true

		mw.scene.add @ground

		true

	maps: ->

		# -~= HEIGHTS

		canvas = document.createElement 'canvas'
		context = canvas.getContext '2d'
		canvas.width = 65
		canvas.height = 65

		context.save() # push
		context.translate 1, 65
		context.scale 1, -1

		x = -( 18 + @x ) *64
		y = -( 27 - @y ) *64
		#y -= 64
		context.drawImage mw.vvardenfell, x, y

		# console.log "#{@x}, #{@y} is #{x}, #{y}"
		context.getImageData 0, 0, 65, 65
		@heights = context.getImageData(0, 0, 65, 65).data

		context.restore() # pop
		context.drawImage mw.vvardenfell, x, y

		@height = new THREE.Texture canvas
		@height.needsUpdate = true
		@height.magFilter = THREE.NearestFilter
		@height.minFilter = THREE.LinearMipMapLinearFilter

		# -~= VERTEX COLOUR MAP

		canvas = document.createElement 'canvas'
		context = canvas.getContext '2d'
		canvas.width = 128
		canvas.height = 128
		context.restore() # pop
		context.translate 1, 63
		context.drawImage mw.vclr, x, y
		@vclr = new THREE.Texture canvas
		@vclr.needsUpdate = true
		# @vclr.magFilter = THREE.NearestFilter
		# @vclr.minFilter = THREE.LinearMipMapLinearFilter

		# -~= TEXTURE PLACEMENT MAP

		canvas = document.createElement 'canvas'
		#document.body.appendChild canvas
		canvas.width = 18
		canvas.height = 18
		context = canvas.getContext '2d'

		context.translate 1, 1
		#context.scale 1, 1
		context.drawImage mw.vtex, x/4, y/4

		@blues = context.getImageData(0, 0, 18, 18).data;
		
		#document.body.appendChild canvas
		#if @x is -2 and @y is -9
		#	console.log 'there'
		#	$('canvas').css 'position', 'absolute'

		#context.restore() # pop
		#context.drawImage mw.vvardenfell, x, y

		true

	makemasks: ->
		#console.log @blues
		#console.log @blues.length

		@masks = []
		@textures = []

		blues = []
		for i in [0..@blues.length/4]
			b = @blues[(i*4)+2]

			if blues.indexOf(b) == -1
				blues.push b
		
		color = 3
		for b in blues
			@textures.push mw.textures[ mw.blues[ b ] or 'cat.dds' ]
			#console.log "#{b} is #{mw.blues[b]}"

			if ++color is 4
				canvas = document.createElement 'canvas'
				$(canvas).attr 'mw', "cell #{@x}, #{@y}"
				#document.body.appendChild canvas if @x is -2 and @y is -9
				context = canvas.getContext '2d'
				canvas.width = 32
				canvas.height = 32
				color = 0
				data = context.createImageData 18, 18
				#data = new Array 18*18*4
				@masks.push canvas

			for i in [0..@blues.length/4]
				v = @blues[(i*4)+2]
				data.data[(i*4)+color] = if v is b then 255 else 1

			context.putImageData data, 7, 7

		#

		for m, i in @masks
			t = new THREE.Texture m
			t.needsUpdate = true
			@masks[i] = t

		# console.log "#{blues.length} blues for #{@x}, #{@y}"

		@textures.pop() while @textures.length > 9
		# console.log "#{@textures.length} t length"

		true

	splat: ->

		a = new THREE.TextureLoader().load "textures/cat.dds"

		material = new THREE.ShaderMaterial
			uniforms:
				THREE.UniformsUtils.merge([
						THREE.UniformsLib[ 'common' ],
						THREE.UniformsLib[ 'aomap' ],
						THREE.UniformsLib[ 'lightmap' ],
						THREE.UniformsLib[ 'emissivemap' ],
						THREE.UniformsLib[ 'fog' ],
						THREE.UniformsLib[ 'lights' ]
				])

			vertexShader:   document.getElementById( 'splatVertexShader'   ).textContent
			fragmentShader: document.getElementById( 'splatFragmentShader' ).textContent
			lights: true
			fog: true
			shading: THREE.FlatShading
			side: THREE.FrontSide

		material.uniforms.emissive = 	type: "c", 	value: new THREE.Color 0x000000
		material.uniforms.diffuse = 	type: "c", 	value: new THREE.Color mw.Ambient
		material.uniforms.cat = 		type: "t", 	value: mw.textures['cat.dds']
		material.uniforms.pastels =		type: "tv", value: @textures
		material.uniforms.amount =		type: "i", 	value: @textures.length
		material.uniforms.masks = 		type: "tv", value: @masks
		material.uniforms.vclr = 		type: "tv", value: @vclr

		# draadstaal = new THREE.MeshBasicMaterial wireframe: true, color: 0xc1c1c1
		# mesh = new THREE.Mesh @geometry, draadstaal
		# mesh.position.set @mx, @my, 0
		# mesh.scale.x = mesh.scale.y = 0.99

		# mw.scene.add mesh


		return material