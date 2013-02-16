# class parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse str
  catch error
    no

# visibility

assert parses('public class Foo {}'),
  'public classes should parse fine'
assert parses('private class Foo {}'),
  'private classes should parse fine'
assert parses('global class Foo {}'),
  'global classes should parse fine'
assert not parses('class Foo {}'),
  'visibility keyword is required'

# other modifiers

assert parses('public abstract class Foo {}'),
  'abstract classes should parse'
assert parses('public virtual class Foo {}'),
  'virtual classes should parse'
assert parses('public with sharing class Foo {}'),
 'with sharing classes should parse'
assert parses('public without sharing class Foo {}'),
  'without sharing classes should parse'
assert parses('public virtual with sharing class Foo {}'),
  'classes with multiple modifiers should parse'
assert parses('public abstract without sharing class Foo {}'),
  'classes with multiple modifiers should parse'

assert parses('virtual public class Foo {}'),
  'the visibility does not have to be first'
assert parses('abstract public class Foo {}'),
  'the visibility does not have to be first'
assert parses('with sharing public class Foo {}'),
  'the visibility does not have to be first'

assert parses('virtual public with sharing class Foo {}'),
  'the visibility can be between other modifiers'
assert parses('virtual public abstract class Foo {}'),
  'the visibility can be between other modifiers'

# implements

assert parses('public class Foo implements Bar {}'),
  'implementing an interface should parse'
assert parses('public class Foo implements Bar, Baz, Serializable {}'),
  'implementing multiple interfaces should parse'
assert not parses('public class Foo implements {}'),
  'an interface must be specified to implement'

# extends

assert parses('public class Foo extends Bar {}'),
  'extending a base class should parse'
assert not parses('public class Foo extends Bar, Baz {}'),
  'apex does not have multiple inheritance'

assert parses('public class Foo implements Bar extends Baz {}'),
  'the order of implements and extends should not matter'
assert parses('public class Foo extends Bar implements Baz {}'),
  'the order of implements and extends should not matter'
