# ascent parser library

fs = require 'fs'
path = require 'path'

p = require './parser'
c = require './cleaner'

parse = (text) ->
  cleaned = c.clean text
  parsed = p.parse text

commonjsMain = (args) ->
  if not args[1]
    console.log "Usage: #{args[0]} FILE"
    process.exit 1

  file = path.normalize args[1]
  source = fs.readFileSync file, "utf8"
  parse source

module.exports =
  parse: parse
  main: commonjsMain

if module? and require.main is module
  console.log JSON.stringify commonjsMain(process.argv[1..]), null, 2
