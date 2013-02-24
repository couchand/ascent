# expression parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo { void doFoo(){ #{str}; } }"
  catch error
    no

# assignment expressions

assert parses('theAnswer = 42'), 'simple assignments should parse'
assert parses('sixOfOne = halfADozen = 6'), 'compound assignments should parse'
