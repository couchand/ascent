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
    if state is quoting
      if escape_stack.length
        clean += escape_stack.pop() + char
      else
        switch char
          when '\\'
            escape_stack.push char
          when '\''
            clean += char
            state = ready
          else
            clean += char
    else if state is commenting
      if escape_stack.length
        if char is '/'
          escape_stack.pop()
          state = ready
          clean += '  '
        else
          clean += '  '
      else
        if char is '*'
          escape_stack.push char
        else
          clean += ' '
    else # if state is ready
      if escape_stack.length
        switch char
          when '*'
            escape_stack.pop()
            clean += '  '
            state = commenting
          when '/'
            escape_stack.pop()
            return clean
          when '\''
            clean += escape_stack.pop() + char
            state = quoting
          else
            clean += escape_stack.pop() + char
      else
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
