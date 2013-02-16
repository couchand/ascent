# method parsing test

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo{ #{str} }"
  catch error
    no

# basic

assert parses('void doIt(){}'),
  'simple methods should parse'
assert parses('void doIt(Integer i){}'),
  'method parameters should parse'
assert parses('void doIt(Integer i, Integer j){}'),
  'methods with multiple parameters should parse'
assert parses('Integer doIt(){}'),
  'method return types should parse'

assert parses('protected override void foobar(){}'),
  'method modifiers should parse'

# constructors

assert parses('Foo(){}'), 'constructors should parse'
assert parses('Foo(Integer i){}'), 'constructor parameters should parse'
assert parses('private Foo(){}'), 'constructor modifiers should parse'