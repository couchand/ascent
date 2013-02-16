# properties parsing test

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo{ #{str} }"
  catch error
    no

# basic

assert parses('Integer myInt;'),
  'simple instance variables should parse'
assert parses('Integer myInt = 42;'),
  'instance variables with initializers should parse'
