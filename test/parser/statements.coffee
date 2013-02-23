# statement parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo { void doFoo(){#{str}} }"
  catch error
    no

# empty statement

assert parses(';'), 'an empty statement should parse'

# break and continue

assert parses('break;'), 'break statements should parse'
assert parses('continue;'), 'continue statements should parse'
