# ascent pre-parsing cleanup
#   remove end-of-line comments
#   replace block comments with whitespace

cleanLine = (line) ->
  line.replace /\/\/.*$/, ''

clean = (input) ->
  (cleanLine line for line in input.split '\n').join '\n'

module.exports =
  clean: clean
