# ascent pre-parsing cleanup
#   remove end-of-line comments
#   replace block comments with whitespace

class State
  constructor: ->
  handleEscaped: (prev, char) -> ['', @]
  handlePlain: (char) -> ['', @, no]

ready = new State()
commenting = new State()
comment_to_line = 2
quoting = 3
escape_stack = []

class Ready
  constructor: ->
  handleEscaped: (prev, char) ->
    switch char
      when '*'
        ['  ', commenting]
      when '/'
        ['', comment_to_line]
      when '\''
        [prev + char, quoting]
      else
        [prev + char, @]
  handlePlain: (char) ->
    switch char
      when '/'
        ['', @, char]
      when '\''
        [char, quoting, no]
      else
        [char, @, no]

class Commenting
  constructor: ->
  handleEscaped: (prev, char) ->
    if char is '/'
      ['  ', ready]
    else
      ['  ', @]
  handlePlain: (char) ->
    if char is '*'
      ['', @, char]
    else
      [' ', @, no]

class Quoting
  constructor: ->
  handleEscaped: (prev, char) ->
    [prev + char, @]
  handlePlain: (char) ->
    switch char
      when '\\'
        ['', @, char]
      when '\''
        [char, ready, no]
      else
        [char, @, no]

ready = new Ready()
commenting = new Commenting()
quoting = new Quoting()

state = ready

cleanLine = (line) ->
  clean = ''
  for char in line.split ''
    if escape_stack.length
      prev = escape_stack.pop()
      [new_char, new_state] = state.handleEscaped prev, char
      return clean if new_state is comment_to_line
      clean += new_char
      state = new_state
    else
      [new_char, new_state, push_me] = state.handlePlain char
      clean += new_char
      state = new_state
      escape_stack.push push_me if push_me
  clean

cleanInput = (input) ->
  (cleanLine line for line in input.split '\n').join '\n'

module.exports =
  clean: cleanInput
