class mw.Terrain
	constructor: (@x, @y) ->
		@maps()
		@vtexmaps()

		@geometry = new THREE.PlaneGeometry 4096*2, 4096*2, 64, 64

		@mx = mx = (@x * 8192) + 4096
		@my = my = (@y * 8192) + 4096

		#console.log "mx #{mx}, my #{my}"

		#@mesh = new THREE.Mesh @geometry, new THREE.MeshBasicMaterial map: @height, wireframe: true
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

		#document.body.appendChild canvas

		#if @x is -2 and @y is -9
			#console.log 'there'
			#$('canvas').css 'position', 'absolute'

		canvas = document.createElement 'canvas'
		context = canvas.getContext '2d'
		canvas.width = 65
		canvas.height = 65

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

		context.restore() # pop
		context.drawImage mw.vvardenfell, x, y

		@height = new THREE.Texture canvas
		@height.needsUpdate = true
		@height.magFilter = THREE.NearestFilter
		@height.minFilter = THREE.LinearMipMapLinearFilter

		# VERTEX COLOUR MAP
		canvas = document.createElement 'canvas'
		context = canvas.getContext '2d'
		canvas.width = 65
		canvas.height = 65
		context.restore() # pop
		context.translate 1, 0
		context.drawImage mw.vclr, x, y
		@vclr = new THREE.Texture canvas
		@vclr.needsUpdate = true
		@vclr.magFilter = THREE.NearestFilter
		@vclr.minFilter = THREE.LinearMipMapLinearFilter

		# TEXTURE PLACEMENT MAP
		canvas = document.createElement 'canvas'
		#document.body.appendChild canvas
		canvas.width = 18
		canvas.height = 18
		context = canvas.getContext '2d'

		context.translate 1, 1
		#context.scale 1, 1
		context.drawImage mw.vtex, x/4, y/4

		@blues = context.getImageData(0, 0, 18, 18).data;
		@vtex = new THREE.Texture canvas
		@vtex.needsUpdate = true

		@vtexl = new THREE.Texture canvas
		@vtexl.needsUpdate = true
		@vtexl.magFilter = THREE.NearestFilter
		@vtexl.minFilter = THREE.LinearMipMapLinearFilter
		
		#document.body.appendChild canvas
		#if @x is -2 and @y is -9
		#	console.log 'there'
		#	$('canvas').css 'position', 'absolute'

		#context.restore() # pop
		#context.drawImage mw.vvardenfell, x, y

		true

	vtexmaps: ->
		#console.log @blues
		#console.log @blues.length

		masks = []

		blues = []
		for i in [0..@blues.length/4]
			b = @blues[(i*4)+2]

			if blues.indexOf(b) == -1
				blues.push b
		
		color = 3
		for b in blues

			if ++color is 4
				canvas = document.createElement 'canvas'
				$(canvas).attr 'mw', "cell #{@x}, #{@y}"
				document.body.appendChild canvas if @x is -2 and @y is -9
				context = canvas.getContext '2d'
				canvas.width = 18
				canvas.height = 18
				color = 0
				data = context.createImageData 18, 18
				#data = new Array 18*18*4
				masks.push canvas

			for i in [0..@blues.length/4]
				v = @blues[(i*4)+2]
				data.data[(i*4)+color] = if v is b then 255 else 0

			console.log data
			context.putImageData data, 0, 0

		for m, i in masks
			t = new THREE.Texture m
			t.needsUpdate = true
			masks[i] = t
			console.log m


		#for j in [0..16*16*4]
		#	data.length/4

		console.log "#{blues.length} blues for #{@x}, #{@y}"

		@masks = masks
		#@blues = blues

		#console.log blues

	splat: ->
		###a = new THREE.ImageUtils.loadTexture 'cloud.png'
		a.wrapS = a.wrapT = THREE.RepeatWrapping
		a.repeat.set 64, 64

		b = new THREE.ImageUtils.loadTexture 'water.jpg'
		b.wrapS = b.wrapT = THREE.RepeatWrapping
		b.repeat.set 64, 64###

		material = new THREE.ShaderMaterial
			uniforms:
				texturePlacement:	{ type: "t", value: @vtex }
				texturePlacementLinear:	{ type: "t", value: @vtexl }
				vertexColour: 		{ type: "t", value: @vclr }

				mossTexture: 		{ type: "t", value: mw.textures['tx_bc_moss.dds'] }
				dirtTexture: 		{ type: "t", value: mw.textures['tx_bc_dirt.dds'] }
				mudTexture: 		{ type: "t", value: mw.textures['tx_bc_mud.dds'] }

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