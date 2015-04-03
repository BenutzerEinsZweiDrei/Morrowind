class mw.Terrain
	constructor: ->

		@bmp = new Image 64, 64
		@bmp.src = 'cells/-2,-9.bmp'
		
		that = this
		@bmp.onload = ->
			that.got()

	got: ->
		@data = @heights()

		@geometry = new THREE.PlaneGeometry 8192*2, 8192*2, 128, 128

		map = THREE.ImageUtils.loadTexture 'cells/-2,-9.bmp'
		map.magFilter = THREE.NearestFilter
		map.minFilter = THREE.LinearMipMapLinearFilter

		@material = new THREE.MeshBasicMaterial
			map: map
			#color: 0xffff00
			wireframe: true


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

		@mx = mx = (-2 * 8192) + 4096 #+ 512
		@my = my = (-9 * 8192) + 4096 + 512
		console.log "mx #{mx}, my #{my}"

		@mesh.position.set mx, my, 0

		#console.log "at #{x}, #{y}"

		for i in [0..@geometry.vertices.length-1]

			x = @geometry.vertices[i].x
			y = @geometry.vertices[i].y

			px = ((8192+x)/64)
			px /= 4
			py = ((8192+y)/64)
			py /= 4

			px = Math.floor px
			py = Math.floor py



			console.log "#{px}, #{py} is #{x}, #{y}"

			p = ((py*64)+px)*4

			d = (@data[p+2]) or 0

			if @data[p+0] is 255 and @data[p+1] is 255
				@geometry.vertices[i].z = h
				h = -(255-d)
			else
				h = d

				###geometry = new THREE.BoxGeometry 2, 2, 2
				material = new THREE.MeshBasicMaterial color: 0x00ff00
				cube = new THREE.Mesh geometry, material
				cube.position.set mx-x, my-y, d*2
				mw.scene.add cube###
			
			@geometry.vertices[i].z = h


		mw.scene.add @mesh

		@water()

		true

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

	water: ->

		that = this
		loader = new THREE.TGALoader
		loader.load 'models/water00.tga', (asd) ->
			asd.wrapS = asd.wrapT = THREE.RepeatWrapping
			asd.repeat.set 32, 32

			geometry = new THREE.PlaneGeometry 8192*2, 8192*2, 64, 64

			material = new THREE.MeshBasicMaterial
				map: asd
				#transparent: true
				#opacity: .5

				#color: 0x747498
				#wireframe: true
				#ambient: 0xffffff

			mesh = new THREE.Mesh geometry, material
			mesh.position.set that.mx, that.my, 0

			console.log mesh

			mw.scene.add mesh

		true