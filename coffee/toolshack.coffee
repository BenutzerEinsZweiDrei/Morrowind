mw.assignUVs = (geometry) ->

	geometry.computeBoundingBox()

	max = geometry.boundingBox.max
	min = geometry.boundingBox.min


	geometry.faceVertexUvs[0] = []
	faces = geometry.faces

	for i in [0..geometry.faces.length-1]

		v1 = geometry.vertices[faces[i].a]
		v2 = geometry.vertices[faces[i].b]
		v3 = geometry.vertices[faces[i].c]

      geometry.faceVertexUvs[0].push([
        new THREE.Vector2( ( v1.x + offset.x ) / range.x , ( v1.y + offset.y ) / range.y ),
        new THREE.Vector2( ( v2.x + offset.x ) / range.x , ( v2.y + offset.y ) / range.y ),
        new THREE.Vector2( ( v3.x + offset.x ) / range.x , ( v3.y + offset.y ) / range.y )
      ]);

    geometry.uvsNeedUpdate = true;	true

mw.produceterrain = ->
	@patch = new THREE.Geometry
	@patch.vertices = [
	]
	
	@patch.faces = [
	]

	@patches = new THREE.Geometry
	for y in [0..31]


	@patches.mergeVertices()
	console.log @patches.vertices.length

	mw.assignUVs @patches

	true