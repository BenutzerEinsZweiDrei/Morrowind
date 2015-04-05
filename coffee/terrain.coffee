class mw.Terrain
	constructor: (@x, @y) ->
		@data = @heights()

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

			r = @data[p]
			g = @data[p+1]
			b = @data[p+2]

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
		@ground = new THREE.Mesh @geometry, new THREE.MeshLambertMaterial map: @vclr
		@ground.position.set @mx, @my, 0

		mw.scene.add @ground

	heights: ->
		@canvas = canvas = document.createElement 'canvas'

		document.body.appendChild canvas

		if @x is -2 and @y is -9
			console.log 'there'
			$('canvas').css 'position', 'absolute'

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
		imgd = context.getImageData 0, 0, 65, 65

		context.drawImage mw.vclr, x, y
		@vclr = new THREE.Texture @canvas
		@vclr.needsUpdate = true
		@vclr.magFilter = THREE.NearestFilter
		@vclr.minFilter = THREE.LinearMipMapLinearFilter
		#document.body.appendChild @img

		#context.restore() # pop
		#context.drawImage mw.vvardenfell, x, y

		return imgd.data

mw.splat = ->
	noiseTexture = new THREE.ImageUtils.loadTexture 'cloud.png'
	noiseTexture.wrapS = noiseTexture.wrapT = THREE.RepeatWrapping
	noiseTexture.repeat.set 64, 64

	waterTexture = new THREE.ImageUtils.loadTexture 'water.jpg'
	waterTexture.wrapS = waterTexture.wrapT = THREE.RepeatWrapping
	noiseTexture.repeat.set 64, 64

	@splatMaterial = new THREE.ShaderMaterial
		uniforms:
			oceanTexture:  { type: "t", value: waterTexture }
			sandyTexture: { type: "t", value: noiseTexture }
		vertexShader:   document.getElementById( 'splatVertexShader'   ).textContent
		fragmentShader: document.getElementById( 'splatFragmentShader' ).textContent
		transparent: true

	true