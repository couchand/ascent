# ascent pre-parsing cleanup
#   remove end-of-line comments
#   replace block comments with whitespace

ready = 0
commenting = 1
quoting = 2
escape_stack = []

state = ready

cleanLine = (line) ->
  clean = ''
  for char in line.split ''
    if escape_stack.length
      if state is quoting
        prev = escape_stack.pop()
        clean += prev + char
      else if state is commenting
        prev = escape_stack.pop()
        if char is '/'
          state = ready
          clean += '  '
        else
          clean += '  '
      else # if state is ready
        prev = escape_stack.pop()
        switch char
          when '*'
            clean += '  '
            state = commenting
          when '/'
            return clean
          when '\''
            clean += prev + char
            state = quoting
          else
            clean += prev + char
    else
      if state is quoting
        switch char
          when '\\'
            escape_stack.push char
          when '\''
            clean += char
            state = ready
          else
            clean += char
      else if state is commenting
        if char is '*'
          escape_stack.push char
        else
          clean += ' '
      else # if state is ready
        switch char
          when '/'
            escape_stack.push char
          when '\''
            clean += char
            state = quoting
          else
            clean += char
  clean

cleanInput = (input) ->
  (cleanLine line for line in input.split '\n').join '\n'

module.exports =
  clean: cleanInput
