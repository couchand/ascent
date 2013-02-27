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
      prev = escape_stack.pop()
      switch state
        when quoting
          clean += prev + char
        when commenting
          if char is '/'
            state = ready
            clean += '  '
          else
            clean += '  '
        else # ready
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
      switch state
        when quoting
          switch char
            when '\\'
              escape_stack.push char
            when '\''
              clean += char
              state = ready
            else
              clean += char
        when commenting
          if char is '*'
            escape_stack.push char
          else
            clean += ' '
        else # ready
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
