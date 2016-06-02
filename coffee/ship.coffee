class mw.Ship extends mw.Prop
	constructor: (data) ->
		super data

		@type = 'Ship'

		mw.ship = this

		@nodes = [
			{x: -8768.043459278077, y: -76317.46448975372, z: 214.69864753075956}
			{x: -11008.29662446419, y: -77440.86070491183, z: 208.28192393984938}
			{x: -15064.698398200067, y: -78235.1147036306, z: 311.9163745306073}
			{x: -17700.894481160587, y: -72703.35435825039, z: 121.48177096281158}
			{x: -21053.005749845994, y: -71397.26995136919, z: 155.7574808565444}
		]

		@nodes.unshift x: @x, y: @y, z: @z

		@boxes()

		@node = 0
		@goal = 1

		@linear =
			heave: 0
			sway: 0
			surge: 0

		@rotations =
			course: value: 0, period: 0
			pitch: value: 0, period: 0
			roll: value: 0, period: 0
			yaw: value: 0, period: 0

		@seakeeping = @mesh.children[0].matrix
		@quo = @seakeeping

		# THREE.SceneUtils.attach mw.camera, mw.scene, @mesh

		# @mesh.add mw.camera

	boxes: ->
		for n in @nodes
			g = new THREE.BoxGeometry 100, 100, 100
			m = new THREE.MeshBasicMaterial color: 0xcc0000

			mesh = new THREE.Mesh g, m
			mesh.position.set n.x, n.y, 0
			mw.scene.add mesh
		0

	wiggle: ->
		roll =  @rotations.roll.value
		pitch = @rotations.pitch.value
		yaw = @rotations.yaw.value

		@mesh.rotation.x = roll + -pitch
		@mesh.rotation.y = roll + pitch

		return

	# @Override
	step: ->
		super

		@renode()

		x = @x
		y = @y
		r = @r

		@rock()

		@pose()
		@wiggle()

		@x = x
		@y = y
		@r = r
		return

	rock: ->

		rot = @rotations
		lin = @linear

		@pitch()
		@roll()
		@yaw()

		@r += rot.yaw.value

		0

	yaw: ->
		yaw = @rotations.yaw

		yaw.period += 0.01 * mw.timestep

		if yaw.period > Math.PI * 2
			yaw.period -= Math.PI * 2

		yaw.value = 0.018 * Math.cos yaw.period

		0

	pitch: ->
		pitch = @rotations.pitch

		pitch.period += 0.008 * mw.timestep

		if pitch.period > Math.PI * 2
			pitch.period -= Math.PI * 2

		pitch.value = 0.014 * Math.cos pitch.period

		0

	roll: ->
		roll = @rotations.roll

		roll.period += 0.012 * mw.timestep

		if roll.period > Math.PI * 2
			roll.period -= Math.PI * 2

		roll.value = 0.024 * Math.cos roll.period

		0

	course: ->
		course = @rotations.course

		course.period += 0.01 * mw.timestep

		if course.period > Math.PI
			course.period = Math.PI

		course.value = Math.sin course.period

		0

	renode: ->
		return if @node is @goal

		node = @nodes[@node]
		goal = @nodes[@goal]

		knot = 3 * mw.timestep

		# buoytobuoy = Math.atan2 goal.y-node.y, goal.x-node.x
		buoy = Math.atan2 goal.y-@y, goal.x-@x

		# aim = (theta + (Math.PI / 2)) * 180 / Math.PI
		correction = Math.PI / 2
		radians = @r - correction

		# radians = degrees * (pi/180)
		# degrees = radians * (180/pi)

		yaw = knot/2000

		pitch = Math.atan2 Math.sin(radians), Math.cos(radians)
		# buoytobuoy =  Math.atan2 Math.sin(buoytobuoy), Math.cos(buoytobuoy)
		buoy =  Math.atan2 Math.sin(buoy), Math.cos(buoy)

		diff = Math.atan2 Math.sin(pitch-buoy), Math.cos(pitch-buoy)

		@course()

		yaw = Math.max yaw, @rotations.course.value * mw.timestep / 185

		if diff>yaw
			@r -= yaw
		else if diff<-yaw
			@r += yaw
		else
			@r = buoy + correction

		@x += knot * Math.cos radians
		@y += knot * Math.sin radians

		x = Math.abs goal.x - @x
		y = Math.abs goal.y - @y
		range = Math.hypot x, y

		if range <= 50
			console.log 'next goal'
			@rotations.course.period = 0

			@node = @goal
			if @goal+1 < @nodes.length
				@goal++
			else
				@goal = 0

		no