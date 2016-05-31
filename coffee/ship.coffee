class mw.Ship extends mw.Prop
	constructor: (data) ->
		super data

		mw.ship = this

		@nodes = [
			{x: -8768.043459278077, y: -76317.46448975372, z: 214.69864753075956}
			{x: -11008.29662446419, y: -77440.86070491183, z: 208.28192393984938}
			{x: -15064.698398200067, y: -78235.1147036306, z: 311.9163745306073}
			{x: -17700.894481160587, y: -72703.35435825039, z: 121.48177096281158}
			{x: -21053.005749845994, y: -71397.26995136919, z: 155.7574808565444}
		]

		@nodes.unshift x: @x, y: @y, z: @z

		@node = 0
		@goal = 1

		console.log 'new ship'

		@linear =
			heave: 0
			sway: 0
			surge: 0

		@rotations =
			pitch: value: 0, period: 0
			roll: value: 0, period: 0
			yaw: value: 0, period: 0

		@seakeeping = @mesh.children[0].matrix
		@quo = @seakeeping

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

		yaw.value = 0.1 * Math.cos yaw.period

		0

	pitch: ->
		pitch = @rotations.pitch

		pitch.period += 0.008 * mw.timestep

		if pitch.period > Math.PI * 2
			pitch.period -= Math.PI * 2

		pitch.value = 0.015 * Math.cos pitch.period

		0

	roll: ->
		roll = @rotations.roll

		roll.period += 0.01 * mw.timestep

		if roll.period > Math.PI * 2
			roll.period -= Math.PI * 2

		roll.value = 0.025 * Math.cos roll.period

		0

	renode: ->
		return if @node is @goal

		node = @nodes[@node]
		goal = @nodes[@goal]
		theta = Math.atan2 node.y-goal.y, node.x-goal.x

		r = theta + Math.PI/2
		r += Math.PI*2 if r < 0

		console.log theta

		x = .5 * mw.timestep * Math.cos theta
		y = .5 * mw.timestep * Math.tan theta

		# console.log x.toFixed 2

		@x -= x
		@y -= y

		# console.log "going to #{x} and #{y}"
		@r = r

		x = Math.abs goal.x - @x
		y = Math.abs goal.y - @y

		range = Math.hypot x, y

		if range <= 30
			console.log 'next goal'

			@node = @goal
			if @goal+1 < @nodes.length
				@goal++

		no