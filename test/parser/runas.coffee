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

assert not parses('System.runAs( testUser ) Integer i = 5;'),
  'run as single statements should not parse'

assert parses('System.runAs( testUser ){ Integer i = 5; }'),
  'run as block statements should parse'

assert parses('System.runAs( testUser ){ if ( true ) { foobar(); } }'),
  'run as block nested blocks should parse'
