fs = require('fs')
colors = require('colors')
WebSocketServer = require('ws').Server

Math.hypot = Math.hypot || () ->
	y = 0
	length = arguments.length

	for i in [0..length-1]
		if arguments[i] is Infinity || arguments[i] is -Infinity
			return Infinity
		y += arguments[i] * arguments[i]

	return Math.sqrt(y)


mw = global.mw =
	id: 1
	
	sessions: []

	cells: {} # assoc
	hashes: []

	frame: 0 # -9007199254740992
	ping: 100
	reduce: 2

	stats:
		bytesin: 0
		bytesout: 0
		
	# config: JSON.parse fs.readFileSync 'config.json', 'utf8'
	# nosj: JSON.parse fs.readFileSync '../sons/nosj.json', 'utf8'

	surround: [
		[[-2, 2], [-1, 2], [0, 2], [1, 2], [2, 2]],
		[[-2, 1], [-1, 1], [0, 1], [1, 1], [2, 1]],
		[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]],
		[[-2,-1], [-1,-1], [0,-1], [1,-1], [2,-1]],
		[[-2,-2], [-1,-2], [0,-2], [1,-2], [2,-2]]]

	world: null
	intrs: []

	globalbubbles: []

	DEGTORAD: 0.0174532925199432957
	RADTODEG: 57.295779513082320876

	drops:
		Makeshift: [
			'Netch Armor'
			'Kitchen Knife'
		]
		Common: [
			'Dragon Bone?'
		]

	chances: [24, 36, 20, 14, 6] # adds up to 100


mw.celllife = 60000 / mw.ping
# mw.chunkunits = mw.chunksize * 64

console.log ''
console.log "     -~=. Nwahs server .=~-".green
console.log "       server runs at #{1000 / mw.ping} Hz".cyan
console.log ''


mw.start = ->
	mw.timer()

	wss = new WebSocketServer port: 8889

	wss.on 'connection', (ws) ->
		id = mw.id++

		ses = new Session id, ws
		mw.sessions.push ses

		ws.on 'message', (message) ->
			ses.read message

		ws.on 'close', ->
			ses.close()
			i = mw.sessions.indexOf ses
			mw.sessions.splice i, 1

		ws.send JSON.stringify [{YOURE: id}]

		true

	setInterval mw.loop, mw.ping
	setInterval mw.timer, 1000

	true

pad = (v, w) ->
	v = "0#{v}" while v.length < w
	v

mw.timer = ->

	size = mw.sessions.filter( (v) -> return v != undefined).length # fancy array length ?
	
	players = pad "#{size}", 2
	io = pad "#{mw.stats.bytesin/1000}", 3
	oi = pad "#{mw.stats.bytesout/1000}", 3
	frame = pad "#{mw.frame}", 5 # 16

	process.title = "players: #{players}, in: #{io} KB/sec, out: #{oi} KB/sec"

	mw.stats.bytesin = 0.0
	mw.stats.bytesout = 0.0

	0

mw.loop = ->

	for ses, i in mw.sessions
		ses.step()

		a = ses.pack()

		continue unless a.length

		json = JSON.stringify a

		ses.send json

	# c.after() for i, c of mw.chunks

	mw.globalbubbles = []

	mw.frame = if mw.frame+1 is 9007199254740992 then 0 else mw.frame+1

	true

mw.loot = (from) ->

	true

class Session
	constructor: (@id, @ws) ->
		console.log "accepted ply ##{@id}"
		
		@in = {}
		@out = {}

		@bubbles = []

		@take = -1

		@outed = 0

		@last = Date.now()
		@delta = 0

		@removes = []

		@ply = new Player this

		@bubbles.push "#{mw.sessions.length} players on server"

		for ses in mw.sessions
			ses.bubbles.push 'Player joined our world. Diablo\'s minions grow stronger.'

		mw.say mw.SAYINGS.NEW_SESSION

		;

	read: (text) ->

		return if @ply.dead

		@delta = Date.now() - @last
		@last = Date.now()

		mw.stats.bytesin += Buffer.byteLength text

		obj = JSON.parse text

		if 		parseFloat obj[0] is NaN or
				parseFloat obj[1] is NaN or
				parseFloat obj[2] is NaN or
				parseFloat obj[3] is NaN

			console.log 'in coords has NaN'.yellow
			return

		@in = obj[4] if obj[4]?

		@ply.pose obj
		@ply.car.pose @in.CAR or obj if @ply.car?

		@action()

		@take = mw.frame

		true

	step: ->
		0

	action: ->
		if @in.USE? and @take isnt mw.frame
			;

		if @in.EXITCAR?
			;

		if @in.T?
			@ply.trigger() if @take isnt mw.frame
				
		if @in.W? # walk
			@ply.state 'w', if @in.W then 1 else 0

		true

	close: ->
		@closed = true

		for ses in mw.sessions
			ses.bubbles.push 'Player left'

		true

	send: (text) ->
		bytes = Buffer.byteLength text

		mw.stats.bytesout += bytes
		@outed += bytes
		@ws.send text, (error) -> log error if @error
		0

	pack: ->

		###a = []
		for c, i in @ply.chunks
			c.observed = true
			a = a.concat c.pack @ply.stamps[i], @ply.props.interior, @ply.intrstamp
			@removes = @removes.concat c.removes if c.removes.length###

		# a = a.concat @ply.interior.pack @ply.intrstamp if @ply.interior?

		# @out.inventory = @ply.inventory if @ply.inventorystamp is mw.frame

		# @out.removes = @removes if @removes.length
		# @removes = []

		@bubbles = @bubbles.concat mw.globalbubbles
		@out.bubbles = @bubbles if @bubbles.length
		@bubbles = []

		a.unshift @out if !! Object.keys(@out).length

		a = a.filter (e) -> e # remove falsy / nulls 

		@in = {}
		@out = {}

		return a

mw.start()