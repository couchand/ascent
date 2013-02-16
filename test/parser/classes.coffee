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

assert parses('public class Foo {}'), 'simple classes should parse fine'
assert parses('private class Foo {}'), 'simple classes should parse fine'
assert parses('global class Foo {}'), 'simple classes should parse fine'
assert not parses('class Foo {}'), 'visibility keyword is required'

# other modifiers

assert parses('public abstract class Foo {}'), 'abstract classes should parse'
assert parses('public virtual class Foo {}'), 'virtual classes should parse'
assert parses('public with sharing class Foo {}'), 'with sharing classes should parse'
assert parses('public without sharing class Foo {}'), 'without sharing classes should parse'
assert parses('public virtual abstract class Foo {}'), 'classes with multiple modifiers should parse'
assert parses('public virtual with sharing class Foo {}'), 'classes with multiple modifiers should parse'
assert parses('public abstract with sharing class Foo {}'), 'classes with multiple modifiers should parse'
assert parses('public virtual abstract without sharing class Foo {}'), 'classes with multiple modifiers should parse'
