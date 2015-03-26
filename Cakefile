fs = require 'fs'

{print} = require 'sys'
{spawn} = require 'child_process'
exec = require('child_process').exec
files = ['net.coffee']

build = (callback) ->
	coffee = exec "coffee -o js/ -c coffee/", (err, stdout, stderr) ->
        console.log stdout
        console.error stderr

 #task 'watch', 'Watch src/ for changes', ->
#	coffee = exec 'coffee', ['-w', '-c', '-o', '.', '.']
#	coffee.stderr.on 'data', (data) ->
#		process.stderr.write data.toString()
#	coffee.stdout.on 'data', (data) ->
#		print data.toString()

task 'sbuild', 'Build all coffees', ->
	build()