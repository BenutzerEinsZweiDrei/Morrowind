class mw.Terrain
	constructor: (@x, @y) ->
		@maps()
		@soul()

		@geometry = new THREE.PlaneGeometry 8192, 8192, 64, 64

		@mx = mx = (@x * 8192) + 4096
		@my = my = (@y * 8192) + 4096

		@patch = new THREE.Geometry
		@patch.vertices = [
			new THREE.Vector3 0, 128, 0		# 0
			new THREE.Vector3 128, 128, 0	# 1
			new THREE.Vector3 0, 0, 0		# 2
			new THREE.Vector3 128, 0, 0		# 3
			new THREE.Vector3 0, -128, 0	# 4
			new THREE.Vector3 0, 0, 0		# 5 (dupe)
			new THREE.Vector3 128, -128, 0	# 6
			new THREE.Vector3 128, 0, 0		# 7 (dupe)
			new THREE.Vector3 0, -128, 0	# 8 (dupe)
			new THREE.Vector3 -128, -128, 0	# 9
			new THREE.Vector3 0, 0, 0		# 10 (dupe)
			new THREE.Vector3 -128, 0, 0	# 11
			new THREE.Vector3 0, 128, 0		# 12 (dupe)
			new THREE.Vector3 0, 0, 0		# 13 (dupe)
			new THREE.Vector3 -128, 128, 0	# 14
			new THREE.Vector3 -128, 0, 0	# 15 (dupe)
		]
		@patch.faces = [
			new THREE.Face3 0, 2, 1
			new THREE.Face3 2, 3, 1
			new THREE.Face3 4, 6, 5
			new THREE.Face3 6, 7, 5
			new THREE.Face3 8, 10, 9
			new THREE.Face3 10, 11, 9
			new THREE.Face3 12, 14, 13
			new THREE.Face3 14, 15, 13
		]
		@patch.verticesNeedUpdate = true
		@patch.elementsNeedUpdate = true
		@patch.morphTargetsNeedUpdate = true
		@patch.uvsNeedUpdate = true
		@patch.normalsNeedUpdate = true
		@patch.colorsNeedUpdate = true
		@patch.tangentsNeedUpdate = true

		###
		# create ground patch
		array = [[0, 0], [0, -1], [-1, -1], [-1, 0]]
		Neo = (new THREE.Matrix4()).identity()
		for i in [0..3]
			patch = new THREE.PlaneGeometry 128, 128, 1, 1

			r = (i*90) * Math.PI / 180

			Neo.makeRotationZ r

			patch.applyMatrix Neo

			j = i #Math.abs i-3

			for i in [0..patch.vertices.length-1]
				patch.vertices[i].x = patch.vertices[i].x + (array[j][0]*128)
				patch.vertices[i].y = patch.vertices[i].y + (array[j][1]*128)

			@patch.merge patch

		console.log @patch
		###

		@patches = new THREE.Geometry
		for y in [0..31]
			for x in [0..31]
				g = @patch.clone()
				for i in [0..g.vertices.length-1]
					g.vertices[i].x += ((x-16) * 256) + 128
					g.vertices[i].y += ((y-16) * 256) + 128

				@patches.merge g

		mw.assignUVs @patches

		if @x is -2 and @y is -9

			@geometry = @patches

			mesh = new THREE.Mesh @geometry, new THREE.MeshBasicMaterial
				wireframe: true#, map: mw.textures['tx_bc_mud.dds']
			mesh.position.set mx, my, 0
			mw.scene.add mesh

			#console.log 'patches:'
			#console.log @patches.vertices
		else

			mS = (new THREE.Matrix4()).identity()
			mS.elements[0] = -1
			mS.elements[10] = -1
			@geometry.applyMatrix mS

			mesh = new THREE.Mesh @geometry, mw.wireframe
			mesh.position.set mx, my, 0
			mw.scene.add mesh

		for i in [0..@geometry.vertices.length-1]

			x = @geometry.vertices[i].x
			y = @geometry.vertices[i].y

			px = ((4096+x)/64)
			px /= 2
			py = ((4096+y)/64)
			py /= 2

			#console.log "#{px}, #{py} is #{x}, #{y}"

			p = ((py*65)+px)*4
			#p -= 1

			r = @heights[p]
			g = @heights[p+1]
			b = @heights[p+2]

			if r is 255
				@geometry.vertices[i].z = h
				h = -(255-b) + (255*((g-255)/8))
				262
				h *= 
			else if g
				h = (255*(g/8))+b
			else
				h = b
			
			@geometry.vertices[i].z = h


		@mkground()

		true

	mkground: ->
		m = new THREE.MeshBasicMaterial map: mw.textures['tx_bc_mud.dds']

		@ground = new THREE.Mesh @geometry, @splat()
		@ground.position.set @mx, @my, 0

		mw.scene.add @ground

		true

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
		#@vclr.magFilter = THREE.NearestFilter
		#@vclr.minFilter = THREE.LinearMipMapLinearFilter

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
		
		#document.body.appendChild canvas
		#if @x is -2 and @y is -9
		#	console.log 'there'
		#	$('canvas').css 'position', 'absolute'

		#context.restore() # pop
		#context.drawImage mw.vvardenfell, x, y

		true

	soul: ->
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
			@textures.push mw.textures[mw.blues[b]] if mw.blues[b]
			#console.log "#{b} is #{mw.blues[b]}"

			if ++color is 4
				canvas = document.createElement 'canvas'
				$(canvas).attr 'mw', "cell #{@x}, #{@y}"
				#document.body.appendChild canvas if @x is -2 and @y is -9
				context = canvas.getContext '2d'
				canvas.width = 18
				canvas.height = 18
				color = 0
				data = context.createImageData 18, 18
				#data = new Array 18*18*4
				@masks.push canvas

			for i in [0..@blues.length/4]
				v = @blues[(i*4)+2]
				data.data[(i*4)+color] = if v is b then 255 else 1

			context.putImageData data, 0, 0

		#

		for m, i in @masks
			t = new THREE.Texture m
			t.needsUpdate = true
			@masks[i] = t

		#console.log "#{blues.length} blues for #{@x}, #{@y}"

		@textures.pop() while @textures.length > 9
		#console.log "#{@textures.length} t length"

		true

	splat: ->
		###a = new THREE.ImageUtils.loadTexture 'cloud.png'
		a.wrapS = a.wrapT = THREE.RepeatWrapping
		a.repeat.set 64, 64

		b = new THREE.ImageUtils.loadTexture 'water.jpg'
		b.wrapS = b.wrapT = THREE.RepeatWrapping
		b.repeat.set 64, 64###

		#console.log @masks

		material = new THREE.ShaderMaterial
			uniforms:
				vertexColour: 		{ type: "t", value: @vclr }

				uTextures: 			{ type: "tv", value: @textures }
				amount:				{ type: "i", value: @textures.length }
				uMasks: 			{ type: "tv", value: @masks }

				fogColor:			{ type: "c", value: mw.scene.fog.color }
				fogDensity:			{ type: "f", value: mw.scene.fog.density }
				fogNear:			{ type: "f", value: mw.scene.fog.near }
				fogFar:				{ type: "f", value: mw.scene.fog.far }

			vertexShader:   document.getElementById( 'splatVertexShader'   ).textContent
			fragmentShader: document.getElementById( 'splatFragmentShader' ).textContent
			fog: true
			transparent: true
			side: THREE.DoubleSide

		return material