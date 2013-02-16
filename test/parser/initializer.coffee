# initialization block parse tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo {#{str}}"
  catch error
    no

# instance initialization

assert parses('{}'), 'instance initialization blocks should parse'

# static initialization

assert parses('static {}'), 'static initialization blocks should parse'