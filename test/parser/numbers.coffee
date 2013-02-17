# number parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo {#{str}}"
  catch error
    no

# integers

assert parses('Integer i = 42;'),
  'integer literals should parse'

# decimals

assert parses('Decimal d = 13.37;'),
  'decimal literals should parse'
