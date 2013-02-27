# comment parsing tests

c = require '../../src/cleaner/cleaner'

assertCleans = (expected, input, msg) ->
  actual = c.clean input
  throw new Error "#{msg}. expected: #{expected}, actual #{actual}" if expected isnt actual

# one-liners

assertCleans '\npublic class Foobar{}',
  '// this is a class\npublic class Foobar{}',
  'comments before the class should be cleaned'
assertCleans 'public class Foobar{}\n',
  'public class Foobar{}\n// this is a class',
  'comments after the class should parse'
assertCleans 'public \n\nclass Foobar{}',
  'public \n// this is a class\nclass Foobar{}',
  'comments in the class header should parse'
assertCleans 'public class Foobar\n\n{}',
  'public class Foobar\n// this is a class\n{}',
  'comments after the class header class should parse'
assertCleans 'public class Foobar{\n}',
  'public class Foobar{// this is a class\n}',
  'comments in the body should parse'

# multi-liners

#assert parses('/* this\nis\na\nclass*/\npublic class Foobar{}'),
#  'multi-line comments before the class should parse'
#assert parses('public class Foobar{}\n/* this\nis\na\nclass */'),
#  'multi-line comments after the class should parse'
#assert parses('public /* this\nis\na class\n*/class Foobar{}'),
#  'multi-line comments in the class header should parse'
#assert parses('public class Foobar/* this is a class*/{}'),
#  'multi-line comments after the class header class should parse'
#assert parses('public class Foobar{/* this is a class\n*/}'),
#  'multi-line comments in the body should parse'
