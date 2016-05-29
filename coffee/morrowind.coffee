root = exports ? this

mw = root.mw =
	freeze: false
	gots: 0
	gets: 3

	slow: false
	keys: []
	models: {}
	world: null
	ply: null

	circle: [
		{x: 1, y:-1}, {x: 0, y:-1}, {x:-1, y:-1},
		{x: 1, y: 0}, {x: 0, y: 0}, {x:-1, y: 0},
		{x: 1, y: 1}, {x: 0, y: 1}, {x:-1, y: 1}
	]
	pretex: [ # most horrible name
		'cat.dds'
		'tx_sky_clear.dds'
		'tx_bc_mud.dds'
		'tx_bc_dirt.dds'
		'tx_bc_moss.dds'
	]
	blues: {
		'230': 'tx_bc_moss.dds'
		'214': 'tx_bc_dirt.dds'
		'247': 'tx_bc_mud.dds'
	}
	noshadow: [
		'light_com_lantern_02'
		'furn_com_lantern_hook'
	]
	nolight: [
		'light_com_lantern_02'
		'furn_com_lantern_hook'
	]

	textures: []
	wireframe: new THREE.MeshBasicMaterial wireframe: true, transparent: true, opacity: .5

	weather:
		clear:
			SkySunrise: new THREE.Color 'rgb(117,141,164)'
			SkyDay: new THREE.Color 'rgb(95,135,203)'
			SkySunset: new THREE.Color 'rgb(55,89,127)'
			SkyNight: new THREE.Color 'rgb(5,5,5)'
			FogSunrise: new THREE.Color 'rgb(255,188,155)'
			FogDay: new THREE.Color 'rgb(206,227,255)'
			FogSunset: new THREE.Color 'rgb(255,188,155)'
			FogNight: new THREE.Color 'rgb(5,5,5)'
			AmbientSunrise: new THREE.Color 'rgb(36,50,72)'
			AmbientDay: new THREE.Color 'rgb(137,140,160)'
			AmbientSunset: new THREE.Color 'rgb(55,61,77)'
			AmbientNight: new THREE.Color 'rgb(10,11,12)'
			SunSunrise: new THREE.Color 'rgb(242,159,119)'
			SunDay: new THREE.Color 'rgb(255,252,238)'
			SunSunset: new THREE.Color 'rgb(255,114,79)'
			SunNight: new THREE.Color 'rgb(45,73,131)'
			SunDiscSunset: new THREE.Color 'rgb(255,189,157)'
			# Transition Delta=.015
			# Land Fog Day Depth=.69
			# Land Fog Night Depth=.69
			# Clouds Maximum Percent=1.0
			# Wind Speed=.1
			# Cloud Speed=1.25
			# Glare View=1
			# Cloud Texture=Tx_Sky_Clear.tga
			# Ambient Loop Sound ID=_ase_clear loop01

		cloudy:
			SkySunrise: new THREE.Color 'rgb(125,158,173)'
			SkyDay: new THREE.Color 'rgb(117,160,215)'
			SkySunset: new THREE.Color 'rgb(109,114,159)'
			SkyNight: new THREE.Color 'rgb(5,5,5)'
			FogSunrise: new THREE.Color 'rgb(255,203,147)'
			FogDay: new THREE.Color 'rgb(245,235,224)'
			FogSunset: new THREE.Color 'rgb(255,154,105)'
			FogNight: new THREE.Color 'rgb(5,5,5)'
			AmbientSunrise: new THREE.Color 'rgb(50,56,64)'
			AmbientDay: new THREE.Color 'rgb(137,145,160)'
			AmbientSunset: new THREE.Color 'rgb(55,62,71)'
			AmbientNight: new THREE.Color 'rgb(10,12,16)'
			SunSunrise: new THREE.Color 'rgb(241,177,99)'
			SunDay: new THREE.Color 'rgb(255,236,221)'
			SunSunset: new THREE.Color 'rgb(255,89,0)'
			SunNight: new THREE.Color 'rgb(39,46,61)'
			SunDiscSunset: new THREE.Color 'rgb(255,202,179)'
			# Transition Delta=.015
			# Land Fog Day Depth=.72
			# Land Fog Night Depth=.72
			# Clouds Maximum Percent=1.0
			# Wind Speed=.2
			# Cloud Speed=2
			# Glare View=1
			# Cloud Texture=Tx_Sky_Cloudy.tga
			# Ambient Loop Sound ID=_ase_cloudy loop01

mw.Ambient = mw.weather.clear.AmbientNight.getHex()
mw.Sun = mw.weather.clear.SunNight.getHex()
mw.Fog = mw.weather.clear.FogNight.getHex()
	# Sun Disc Sunset: new THREE.Color 'rgb(150,000,000


$(document).ready ->
	$.ajaxSetup 'async': false
	
	mw.boot.call mw

	mw.produceterrain.call mw

	mw.resources.call mw

	true

document.onkeydown = document.onkeyup = (event) ->
	k = event.keyCode

	if event.type is 'keydown' and mw.keys[k] isnt 2
		mw.keys[k] = 1
	else if event.type is 'keyup'
		#console.log('key up')
		mw.keys[k] = 0

	if not mw.keys[ k ]
		delete mw.keys[k]

	if k is 114
		event.preventDefault()
	
	#console.log mw.keys

	if mw.lightbox
		mw.lightbox.key()

	true

mw.resources = ->
	@vvardenfell = new Image 2688, 2816
	@vvardenfell.src = 'textures/vvardenfell.bmp'

	@vclr = new Image 2688, 2816
	@vclr.src = 'textures/vvardenfell-vclr.bmp'

	@vtex = new Image 672, 704
	@vtex.src = 'textures/vvardenfell-vtex3.bmp'

	@pretex.push "water/water#{n}.dds" for n in [0..31]

	@gets += @pretex.length

	for f, i in @pretex
		go = ->
			a = f
			loader = new THREE.DDSLoader
			loader.load "textures/#{f}", (asd) ->
				asd.wrapS = asd.wrapT = THREE.RepeatWrapping
				asd.anisotropy = mw.maxAnisotropy
				asd.repeat.set 64, 64
				mw.textures[a] = asd
				# console.log "got #{a}"
				mw.got.call mw

		go()
	
	@vvardenfell.onload = @vclr.onload = @vtex.onload = ->
		mw.got.call mw

	true

mw.got = ->
	if ++@gots is @gets
		console.log 'got all preloads'
		@after()

	true

mw.after = ->
	$.getJSON "seydaneen.json", (data) ->
		mw.world = new mw.World data
		
	mw.animate()

	true

# definitions of insanity

mw.texture = (file) ->
	p = file

	loader = new THREE.TextureLoader()
	loader.load p
	loader = null

	if mw.textures[p]
		return  mw.textures[p]
	else
		go = ->
			loader = new THREE.TGALoader
			console.log loader
			i = p
			loader.load p, (asd) ->
				#asd.wrapS = asd.wrapT = THREE.RepeatWrapping
				#asd.repeat.set 64, 64
				mw.textures[i] = asd
				return

		go()

	true