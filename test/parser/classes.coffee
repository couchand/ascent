# class parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse str
  catch error
    no

assert parses 'public class Foo {}'
assert not parses 'class Foo {}'
