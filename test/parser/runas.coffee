# runAs block parsing tests

p = require '../../dst/ascent.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class foo{ void bar(){ #{str} } }"
  catch error
    no

assert parses('System.runAs( testUser ){}'),
  'run as blocks should parse'
