class mw.Net
	constructor: ->
		@visuals = []
		
		@ws = null
		@open = false

		@frame = -1
		
		@in = {}
		@out = {}

		@connect()

	connect: ->

		net = this
		
		@ws = new WebSocket mw.mytrade.ws
		
		@ws.onopen = ->

			console.log 'mw ws opened'

			net.open = true

			net.loop()

			true
		
		@ws.onmessage = (evt) ->
			#console.log "got #{evt.data}"

			net.takein JSON.parse evt.data
			true

		@ws.onclose = ->
			console.warn 'mw ws closed'

			net.open = false
			true

		@ws.onerror = (err) ->
			console.warn 'mw ws err'
			true

		true

	takein: (o) ->
		
		for e in o

			if Object.prototype.toString.call(e) isnt '[object Array]' # pretty reliable
				@in = e

				if @in.removes
					for e in @in.removes
						continue if not @visuals[e]?
						# console.log "removing #{e}"
						@visuals[e].dtor()
						delete @visuals[e]

				if @in.bubbles
					console.log m for m in @in.bubbles


		true

	loop: () ->

		a = mw.ply.collect()

		if a
			json = JSON.stringify a

			@ws.send json

		setTimeout 'mw.net.loop()', 100 if @open

		true