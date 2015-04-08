mw.watershed = ->

	noiseTexture = new THREE.ImageUtils.loadTexture 'cloud.png'
	noiseTexture.wrapS = noiseTexture.wrapT = THREE.RepeatWrapping
	noiseTexture.repeat.set 64, 64

	waterTexture = new THREE.ImageUtils.loadTexture 'water.jpg'
	waterTexture.wrapS = waterTexture.wrapT = THREE.RepeatWrapping
	noiseTexture.repeat.set 64, 64

	# create custom material from the shader code above within specially labeled script tags
	@customMaterial = new THREE.ShaderMaterial
		uniforms:
			baseTexture:  { type: "t", value: waterTexture }
			baseSpeed:    { type: "f", value: 0.005 }
			noiseTexture: { type: "t", value: noiseTexture }
			noiseScale:   { type: "f", value: 0.5337 }
			alpha:        { type: "f", value: 1.0 }
			time:         { type: "f", value: 1.0 }
		vertexShader:   document.getElementById( 'vertexShader'   ).textContent
		fragmentShader: document.getElementById( 'fragmentShader' ).textContent
		side: THREE.DoubleSide
		transparent: true

	THREE.ShaderLib['mirror'].uniforms.baseTexture =	type: "t", value: waterTexture
	THREE.ShaderLib['mirror'].uniforms.noiseTexture =	type: "t", value: noiseTexture
	THREE.ShaderLib['mirror'].uniforms.noiseSpeed =		type: "f", value: 0.01
	THREE.ShaderLib['mirror'].uniforms.noiseScale =		type: "f", value: 0.5337
	THREE.ShaderLib['mirror'].uniforms.time =			type: "f", value: 1.0
	THREE.ShaderLib['mirror'].uniforms.opacity =		type: "f", value: .3

	THREE.ShaderLib['mirror'].fragmentShader =
	"
	uniform float opacity;
	uniform vec3 mirrorColor;
	uniform sampler2D mirrorSampler;
	varying vec4 mirrorCoord;

	uniform float time;
	uniform float noiseSpeed;
	uniform float noiseScale;
	uniform sampler2D baseTexture;
	uniform sampler2D noiseTexture;

	varying vec2 vUv;

	float blendOverlay(float base, float blend) {
		return( base < 0.5 ? ( 2.0 * base * blend ) : (1.0 - 2.0 * ( 1.0 - base ) * ( 1.0 - blend ) ) );
	}

	void main() {
		

		vec4 color = texture2DProj(mirrorSampler, mirrorCoord);

		float r = blendOverlay(mirrorColor.r, color.r);
		float g = blendOverlay(mirrorColor.g, color.g);
		float b = blendOverlay(mirrorColor.b, color.b);

		color = vec4(r, g, b, opacity);
		gl_FragColor = color;
	}
	"

	###
	//vec2 uvTimeShift = vUv + vec2( -0.7, 1.5 ) * time * noiseSpeed;
	//vec4 noiseGeneratorTimeShift = texture2D( noiseTexture, uvTimeShift );
	//vec2 uvNoiseTimeShift = vUv + noiseScale * vec2( noiseGeneratorTimeShift.r, noiseGeneratorTimeShift.b );
	//vec4 baseColor = texture2D( baseTexture, uvNoiseTimeShift );
	###

	THREE.ShaderLib['mirror'].vertexShader =
	"
	uniform mat4 textureMatrix;
	varying vec4 mirrorCoord;
	varying vec2 vUv;

	void main() {
		vUv = uv;
		vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );
		vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
		mirrorCoord = textureMatrix * worldPosition;
		gl_Position = projectionMatrix * mvPosition;
	}
	"

	@mirror = new THREE.Mirror mw.renderer, mw.camera, clipBias: 0.0025, textureWidth: 1024, textureHeight: 1024, color: 0x777777
	@mirror.material.transparent = true
	#@mirror.material.uniforms['uOpacity'].value = .5

	geometry = new THREE.PlaneGeometry 8192*3, 8192*3

	@waterMaterial = new THREE.MeshLambertMaterial
		map: mw.textures["models/water0.tga"]
		transparent: true
		opacity: .7

	@water = THREE.SceneUtils.createMultiMaterialObject geometry, [ @waterMaterial] # @mirror.material,
	#@water = new THREE.Mesh geometry, @mirror.material
	#@water.add @mirror

	x = (mw.world.x * 8192) + 4096
	y = (mw.world.y * 8192) + 4096

	@water.position.set x, y, 0

	mw.scene.add @water

	console.log 'added water'

	true