class mw.Heightmap
	constructor: ->

		@bmp = new Image 64, 64
		@bmp.src = 'cells/-2,-9.bmp'
		
		hm = this
		@bmp.onload = ->
			hm.got()

	got: ->
		heights = @heights()

		@geometry = new THREE.PlaneGeometry 8192*2, 8192*2, 128, 128

		# put heightmap
		plane.vertices[i].position.z = data[i];

		map = THREE.ImageUtils.loadTexture 'seydaneen.bmp'
		map.magFilter = THREE.NearestFilter
		map.minFilter = THREE.LinearMipMapLinearFilter

		@material = new THREE.MeshBasicMaterial
			map: map
			#color: 0xffff00
			wireframe: true


		#, side: THREE.DoubleSide

		@mesh = new THREE.Mesh @geometry, @material

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

		x = (-2 * 8192) + 4096 + 512 + 128
		y = (-9 * 8192) + 256 + 128 #+ 4096

		@mesh.position.set x, y, 200

		#console.log "at #{x}, #{y}"

		mw.scene.add @mesh

		true

	heights: ->
		console.log 'heights'
		
		img = @bmp

		canvas = document.createElement 'canvas'
		canvas.width = 128
		canvas.height = 128
		context = canvas.getContext '2d'

		size = 128 * 128
		data = new Float32Array size

		context.drawImage img, 0, 0

		for i in [i..i-size-1]
			data[i] = 0
		

		imgd = context.getImageData 0, 0, 128, 128
		pix = imgd.data

		j=0
		n = pix.length
		for i in [0..n-1] by 4
			all = pix[i]+pix[i+1]+pix[i+2]
			data[j++] = all/30

		return data