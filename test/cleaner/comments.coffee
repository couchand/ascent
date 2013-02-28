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

assertCleans 'public class Foobar{\n}',
  'public class Foobar{// this isn\'t a class\n}',
  'unmatched quotes in comments should be fine'
assertCleans 'public class Foobar{\n}',
  'public class Foobar{// \'this is a class\'\n}',
  'matched quotes in comments should be fine'
assertCleans 'public class Foobar{\n}',
  'public class Foobar{// this is \\\'a class\n}',
  'escaped quotes in comments should be fine'

# multi-liners

assertCleans '       \n  \n \n       \npublic class Foobar{}',
  '/* this\nis\na\nclass*/\npublic class Foobar{}',
  'multi-line comments before the class should parse'
assertCleans 'public class Foobar{}\n       \n  \n \n        ',
  'public class Foobar{}\n/* this\nis\na\nclass */',
  'multi-line comments after the class should parse'
assertCleans 'public        \n  \n       \n  class Foobar{}',
  'public /* this\nis\na class\n*/class Foobar{}',
  'multi-line comments in the class header should parse'
assertCleans 'public class Foobar                    {}',
  'public class Foobar/* this is a class*/{}',
  'multi-line comments after the class header class should parse'
assertCleans 'public class Foobar{                  \n  }',
  'public class Foobar{/* this is a class\n*/}',
  'multi-line comments in the body should parse'
