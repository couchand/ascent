# collection parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo { #{str} }"
  catch error
    no

# declarations

assert parses('void doFoo(){ List<String> l; }'), 'collections should parse'
assert parses('void doFoo(){ List<Map<Id, String>> l; }'), 'nested collections should parse'

# constructor calls

assert parses('void doFoo(){ List<String> l = new List<String>(); }'), 'collection constructor invocations should parse'
assert parses("void doFoo(){ return new List<String>{ 'foo', 'bar', 'baz' }; }"), 'collection initializers should parse'

# properties

assert parses('public List<String> foos;'), 'collections as properties should parse'

# parameters

assert parses('void doFoo(List<String> strs) {}'), 'collections as method params should parse'

# return type

assert parses('List<String> getNames() {}'), 'collections as return types should parse'
