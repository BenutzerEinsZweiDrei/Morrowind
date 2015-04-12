mw.assignUVs = (geometry) ->

	geometry.computeBoundingBox()

	max = geometry.boundingBox.max
	min = geometry.boundingBox.min

	offset = new THREE.Vector2(0 - min.x, 0 - min.y)
	range = new THREE.Vector2(max.x - min.x, max.y - min.y)

	geometry.faceVertexUvs[0] = []
	faces = geometry.faces

	for i in [0..geometry.faces.length-1]

		v1 = geometry.vertices[faces[i].a]
		v2 = geometry.vertices[faces[i].b]
		v3 = geometry.vertices[faces[i].c]
		
		geometry.faceVertexUvs[0].push [
			new THREE.Vector2( ( v1.x + offset.x ) / range.x , ( v1.y + offset.y ) / range.y )
			new THREE.Vector2( ( v2.x + offset.x ) / range.x , ( v2.y + offset.y ) / range.y )
			new THREE.Vector2( ( v3.x + offset.x ) / range.x , ( v3.y + offset.y ) / range.y )
		]

	geometry.uvsNeedUpdate = true

	true

mw.produceterrain = ->
	@patch = new THREE.Geometry
	@patch.vertices = [
		new THREE.Vector3 0, 128, 0
		new THREE.Vector3 128, 128, 0
		new THREE.Vector3 0, 0, 0
		new THREE.Vector3 128, 0, 0
		new THREE.Vector3 0, -128, 0
		new THREE.Vector3 128, -128, 0
		new THREE.Vector3 -128, -128, 0
		new THREE.Vector3 -128, 0, 0
		new THREE.Vector3 -128, 128, 0
	]
	
	@patch.faces = [
		new THREE.Face3 0, 2, 1
		new THREE.Face3 2, 3, 1
		new THREE.Face3 4, 5, 2
		new THREE.Face3 5, 3, 2
		new THREE.Face3 4, 2, 6
		new THREE.Face3 2, 7, 6
		new THREE.Face3 0, 8, 2
		new THREE.Face3 8, 7, 2
	]

	@patches = new THREE.Geometry
	for y in [0..31]
		for x in [0..31]
			g = @patch.clone()
			for i in [0..g.vertices.length-1]
				g.vertices[i].x += ((x-16) * 256) + 128
				g.vertices[i].y += ((y-16) * 256) + 128

			@patches.merge g

	@patches.mergeVertices()
	console.log @patches.vertices.length

	mw.assignUVs @patches

	true