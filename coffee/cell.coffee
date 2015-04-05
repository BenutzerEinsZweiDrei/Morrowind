class mw.Cell
	constructor: (@x, @y) ->
		#console.log "new cell #{@x}, #{@y}"

		@terrain = new mw.Terrain @x, @y