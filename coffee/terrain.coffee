class mw.Terrain
	constructor: (@x, @y) ->

		@bmp = new Image 64, 64
		@bmp.src = "cells/#{@x},#{@y}.bmp"
		
		that = this
		@bmp.onload = ->
			that.got()

	got: ->
		@data = @heights()

		@geometry = new THREE.PlaneGeometry 4096*2, 4096*2, 64, 64

		map = THREE.ImageUtils.loadTexture "cells/#{@x},#{@y}.bmp"
		map.magFilter = THREE.NearestFilter
		map.minFilter = THREE.LinearMipMapLinearFilter

		@material = new THREE.MeshBasicMaterial
			map: map
			#color: 0xffff00
			wireframe: true

		#tx_ai_clover_02.tga

		#, side: THREE.DoubleSide

		@mesh = new THREE.Mesh @geometry, @material
		#@mesh.rotation.z = 180 * Math.PI / 180

		# 998, 2301 Seyda Neen cell
		# Seyda Neen is -2, -9
		# left corner -18, -16
		# right corner 24, 28
		# prop in -2, -9 reports -11879.539, -70898.875 which is -2.90, -17.30
		# x is from right to left
		# y is from top to bottom
		# map is 42 x 44 cells
		# bmp is 2688 x 2816
		# cell is 64*64 pixels, 4096 units
		# -13088, -70417, 675.7888756651994
		# -73632, -16480
		#px = (16)*64
		#py = (-9)*64

		@mx = mx = (@x * 8192) + 4096 - 128
		@my = my = (@y * 8192) + 4096 + 128

		#console.log "mx #{mx}, my #{my}"

		@mesh.position.set mx, my, 0

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

			console.log "#{px}, #{py} is #{x}, #{y}"

			p = ((py*64)+px)*4

			r = @data[p]
			g = @data[p+1]
			b = @data[p+2]

			if r is 255
				@geometry.vertices[i].z = h
				h = -(255-b)
			else if g
				h = (255*(g/8))+b
			else
				h = b
			
			@geometry.vertices[i].z = h


		mw.scene.add @mesh

		@mkground()

		true

	mkground: ->
		that = this

		loader = new THREE.TGALoader
		loader.load 'models/tx_ai_clover_02.tga', (asd) ->
			asd.wrapS = asd.wrapT = THREE.RepeatWrapping
			asd.repeat.set 32, 32

			geometry = new THREE.PlaneGeometry 8192*2, 8192*2, 64, 64

			that.ground = that.mesh.clone()
			that.ground.material = new THREE.MeshBasicMaterial map: asd

			mw.scene.add that.ground

	heights: ->
		console.log 'heights'
		
		img = @bmp

		canvas = document.createElement 'canvas'
		document.body.appendChild canvas
		$('canvas').css 'position', 'absolute'

		canvas.width = 64
		canvas.height = 64
		context = canvas.getContext '2d'

		#size = 128 * 128
		#data = new Float32Array size

		context.translate 0, 64
		#context.rotate 180 * Math.PI / 180
		context.scale 1, -1
		context.drawImage img, 0, 0
		

		imgd = context.getImageData 0, 0, 64, 64
		console.log imgd

		return imgd.data