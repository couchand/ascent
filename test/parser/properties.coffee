# properties parsing test

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo{ #{str} }"
  catch error
    no

# null (where to put this?)

assert parses('Object o = null;'),
  'null should parse'

# basic

assert parses('Integer myInt;'),
  'simple instance variables should parse'
assert parses('Integer myInt = 42;'),
  'instance variables with initializers should parse'
assert parses('private Integer myInt;'),
  'variable modifiers should parse'
assert parses('transient Integer myInt;'),
  'variable transient modifiers should parse'
assert parses('static final Integer PI = 3;'),
  'static properties should parse'

# properties

assert parses('Integer myInt { get; set; }'),
  'plain get and set should parse'
assert parses('Integer myInt { private get; global set; }'),
  'property accessor modifiers should parse'
assert parses('Integer myInt { get {} set {} }'),
  'custom property accessors should parse'
