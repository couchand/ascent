# class parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse str
  catch error
    no

assert parses('public class Foo {}'), 'simple classes should parse fine'
assert parses('private class Foo {}'), 'simple classes should parse fine'
assert parses('global class Foo {}'), 'simple classes should parse fine'
assert not parses('class Foo {}'), 'visibility keyword is required'
