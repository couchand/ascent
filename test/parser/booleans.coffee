# boolean parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo {#{str}}"
  catch error
    no

assert parses('final Boolean tautology = true;'),
  'true literals should parse'
assert parses('Boolean lightSwitch = false;'),
  'false literals should parse'
