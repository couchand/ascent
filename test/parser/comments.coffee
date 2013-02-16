# comment parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse str
  catch error
    no

# one-liners

assert parses('// this is a class\npublic class Foobar{}'), 'comments before the class should parse'
assert parses('public class Foobar{}\n// this is a class'), 'comments after the class should parse'
assert parses('public \n// this is a class\nclass Foobar{}'), 'comments in the class header should parse'
assert parses('public class Foobar\n// this is a class\n{}'), 'comments after the class header class should parse'
assert parses('public class Foobar{// this is a class\n}'), 'comments in the body should parse'

# multi-liners

assert parses('/* this\nis\na\nclass*/\npublic class Foobar{}'), 'multi-line comments before the class should parse'
assert parses('public class Foobar{}\n/* this\nis\na\nclass */'), 'multi-line comments after the class should parse'
assert parses('public /* this\nis\na class\n*/class Foobar{}'), 'multi-line comments in the class header should parse'
assert parses('public class Foobar/* this is a class*/{}'), 'multi-line comments after the class header class should parse'
assert parses('public class Foobar{/* this is a class\n*/}'), 'multi-line comments in the body should parse'
