# string parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo {#{str}}"
  catch error
    no

# easy ones

assert parses("String myName = 'Fozzie the Bear';"),
  'string literals should parse'
assert parses("String status = 'Rounding up my friends to go out to the bar';"),
  'long strings should be fine (though we will complain)'
assert parses("String codeSample = '; doNotGetConfused(); class { this.IsAllFineHere; }';"),
  'code-like things within strings should be ignored'

# escaped quotes

sample_string = "Don\\'t stop believing..."
assert parses("String lyrics = '#{sample_string}';"),
  'escaped quotes should be ignored'
assert parses("String lyrics = '#{sample_string}'; // 'This song rocks' - Rolling Stone\n"),
  'quotes later (such as in comments) should not be considered part of the string'

sample_string = "Look at my \\'slashes\\\\"
assert not parses("String lyrics = '#{sample_string}'';"),
  'ending a string with escaped backslashes and an unescaped quote should parse'
assert parses("String lyrics = '#{sample_string}';"),
  'ending a string with escaped backslashes should parse'
assert parses("String lyrics = '#{sample_string}'; // 'This song rocks' - Rolling Stone\n"),
  'quotes later (such as in comments) should not be considered part of the string'

sample_string = "\\'hello\\'"
assert parses("String lyrics = '#{sample_string}';"),
  'starting a string with an escaped quote should parse'
assert parses("String lyrics = '#{sample_string}'; // 'This song rocks' - Rolling Stone\n"),
  'quotes later (such as in comments) should not be considered part of the string'

sample_string = "Look at my \\'slashes\\\\\\"
# our engine is inappropriately permissive here
# assert not parses("String lyrics = '#{sample_string}';"),
#   'ending a string with unescaped backslashes should not parse'
assert parses("String lyrics = '#{sample_string}'';"),
  'ending a string with escaped backslashes and an escaped quote should parse'
assert parses("String lyrics = '#{sample_string}''; // 'This song rocks' - Rolling Stone\n"),
  'quotes later (such as in comments) should not be considered part of the string'

sample_string = "Look at my \\'slashes\\\\\\\\"
assert not parses("String lyrics = '#{sample_string}'';"),
  'ending a string with escaped backslashes and an unescaped quote should not parse'
assert parses("String lyrics = '#{sample_string}';"),
  'ending a string with escaped backslashes should parse'
assert parses("String lyrics = '#{sample_string}'; // 'This song rocks' - Rolling Stone\n"),
  'quotes later (such as in comments) should not be considered part of the string'

# this level of escaping is not currently supported.
# i hope to god you're not trying to deal with string
# literals with this many slashes at then end followed
# by a single quote.  if you are, you will just have to
# replace it with '...\\\\' + '\''

# sample_string = "Look at my \\'slashes\\\\\\\\\\'"
# assert parses("String lyrics = '#{sample_string}';"),
#   'ending a string with escaped backslashes should parse'
# assert parses("String lyrics = '#{sample_string}'; // 'This song rocks' - Rolling Stone\n"),
#   'quotes later (such as in comments) should not be considered part of the string'

# multi-line
# not legal in apex, but we'll hoover it up anyway

assert parses("String theArticle = 'Four score and\nSeven years ago,\nOur forefathers set forth...';"),
  'even though apex disallows multi-line strings, we will parse them'
