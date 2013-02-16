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



# multi-line
# not legal in apex, but we'll hoover it up anyway

assert parses("String theArticle = 'Four score and\nSeven years ago,\nOur forefathers set forth...';"),
  'even though apex disallows multi-line strings, we will parse them'
