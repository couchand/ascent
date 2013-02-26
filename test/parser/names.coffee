# tests for fully-qualified names

p = require '../../dst/ascent.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo {#{str}}"
  catch error
    no

# fqn as property type

assert parses('FruitBasket.Apple goldenApple;'),
  'fully-qualified names as class property types should parse'
assert parses('global FruitBasket.Banana chiquita;'),
  'fully-qualified names as modified class property types should parse'
assert parses('FruitBasket.Apple goldenApple = 100;'),
  'fully-qualified names as class property types with initializer should parse'
assert parses('global FruitBasket.Banana chiquita = 30;'),
  'fully-qualified names as modified class property types with initializer should parse'

# fqn in method

assert parses('FruitBasket.Apple shakeTree(){}'),
  'fully-qualified names as method return types should parse'
assert parses('void eat( FruitBasket.Apple snack ){}'),
  'fully-qualified names as method parameter types should parse'
