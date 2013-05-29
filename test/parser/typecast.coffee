# typecast parsing tests

p = require '../../dst/ascent.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class foo{ void bar(){ #{str} } }"
  catch error
    no

assert parses('Integer i = (Integer)0;'),
  'typecasts should parse'
