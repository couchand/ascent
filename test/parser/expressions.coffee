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

# ternary

assert parses('true ? false : true'), 'ternary operators should parse'
assert parses('true ? false ? true : false : true ? false : true'), 'compound ternaries should parse'

# logical operators

assert parses('true || false'), 'logical or should parse'
assert parses('true && false'), 'logical and should parse'
#assert parses('!true'), 'logical invert should parse'

# equality

assert parses('a == b'), 'simple equality should parse'
assert parses('a === b'), 'exact equality should parse'

assert parses('a != b'), 'not equal should parse'
assert parses('a !== b'), 'not exactly equal should parse'
assert parses('a < b'), 'less than should parse'
assert parses('a <= b'), 'less than or equal should parse'
assert parses('a > b'), 'greater than should parse'
assert parses('a >= b'), 'greater than or equal should parse'
