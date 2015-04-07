class mw.Terrain
	constructor: (@x, @y) ->
		@maps()

		@geometry = new THREE.PlaneGeometry 4096*2, 4096*2, 64, 64

		@mx = mx = (@x * 8192) + 4096
		@my = my = (@y * 8192) + 4096

		#console.log "mx #{mx}, my #{my}"

		#@mesh.position.set mx, my, 0

		#console.log "at #{x}, #{y}"

		for i in [0..@geometry.vertices.length-1]

			x = @geometry.vertices[i].x
			y = @geometry.vertices[i].y

			px = ((4096+x)/64)
			px /= 2
			py = ((4096+y)/64)
			py /= 2

			#if px is 64 or py is 64
				#console.log 'continuing'
				#continue

			#console.log "#{px}, #{py} is #{x}, #{y}"

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


		#mw.scene.add @mesh

		@mkground()

		true

	mkground: ->
		@ground = new THREE.Mesh @geometry, @splat()
		@ground.position.set @mx, @my, 0

		mw.scene.add @ground

	maps: ->
		canvas = document.createElement 'canvas'

		#document.body.appendChild canvas

		#if @x is -2 and @y is -9
			#console.log 'there'
			#$('canvas').css 'position', 'absolute'

		canvas.width = 65
		canvas.height = 65

		context = canvas.getContext '2d'

		context.save() # push
		context.translate 0, 65
		context.scale 1, -1

		x = -( 18 + @x ) *64
		y = -( 27 - @y ) *64
		#y -= 64
		context.drawImage mw.vvardenfell, x, y

		# console.log "#{@x}, #{@y} is #{x}, #{y}"
		context.getImageData 0, 0, 65, 65
		@heights = context.getImageData(0, 0, 65, 65).data

		# VERTEX COLOUR MAP
		#canvas.width = 64
		#canvas.height = 64
		context.restore() # pop
		context.translate 1, 0
		context.drawImage mw.vclr, x, y
		@vclr = new THREE.Texture canvas
		@vclr.needsUpdate = true
		#@vclr.magFilter = THREE.NearestFilter
		#@vclr.minFilter = THREE.LinearMipMapLinearFilter

		# TEXTURE PLACEMENT MAP
		canvas = document.createElement 'canvas'
		#document.body.appendChild canvas
		canvas.width = 16
		canvas.height = 16
		context = canvas.getContext '2d'

		#context.translate 0, 16
		#context.scale 1, -1
		context.drawImage mw.vtex, x/4, y/4
		
		@vtex = new THREE.Texture canvas
		@vtex.needsUpdate = true
		@vtex.magFilter = THREE.NearestFilter
		@vtex.minFilter = THREE.LinearMipMapLinearFilter

		#context.restore() # pop
		#context.drawImage mw.vvardenfell, x, y

		true

	splat: ->
		a = new THREE.ImageUtils.loadTexture 'cloud.png'
		a.wrapS = a.wrapT = THREE.RepeatWrapping
		a.repeat.set 64, 64

		b = new THREE.ImageUtils.loadTexture 'water.jpg'
		b.wrapS = b.wrapT = THREE.RepeatWrapping
		b.repeat.set 64, 64

		material = new THREE.ShaderMaterial
			uniforms:
				texturePlacement:	{ type: "t", value: @vtex }
				vertexColour: 		{ type: "t", value: @vclr }

				mossTexture: 		{ type: "t", value: mw.textures['models/tx_bc_moss.tga'] }
				dirtTexture: 		{ type: "t", value: mw.textures['models/tx_bc_dirt.tga'] }
				mudTexture: 		{ type: "t", value: mw.textures['models/tx_bc_mud.tga'] }

				fogColor:			{ type: "c", value: mw.scene.fog.color }
				fogDensity:			{ type: "f", value: mw.scene.fog.density }
				fogNear:			{ type: "f", value: mw.scene.fog.near }
				fogFar:				{ type: "f", value: mw.scene.fog.far }

			vertexShader:   document.getElementById( 'splatVertexShader'   ).textContent
			fragmentShader: document.getElementById( 'splatFragmentShader' ).textContent
			fog: true
			transparent: true

		return material

		true