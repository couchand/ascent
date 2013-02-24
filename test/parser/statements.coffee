# statement parsing tests

p = require '../../dst/apex.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo { void doFoo(){#{str}} }"
  catch error
    no

# empty statement

assert parses(';'), 'an empty statement should parse'

# break and continue

assert parses('break;'), 'break statements should parse'
assert parses('continue;'), 'continue statements should parse'

# variable declaration

assert parses('Integer i;'), 'simple declarations should parse'
assert parses('Integer i = 42;'), 'initializers should parse'

# if

assert parses('if (true) ;'), 'simple if statements should parse'
assert parses('if (true) ; else ;'), 'else should parse'
assert parses('if (true) {} else {}'), 'if else statement blocks should parse'
assert parses('if (true) {} else if (false) {} else {}'), 'else if should parse'

# while

assert parses('while(1) ;'), 'simple while loops should parse'
assert parses('while(true) {}'), 'while loop blocks should parse'

# try/catch

assert parses('try {} catch (Exception ex){}'), 'try catch should parse'
assert parses('try {} catch (Exception ex){} catch (AnotherException ex){}'), 'multiple catches should parse'
assert parses('try {} catch (Exception ex){} finally {}'), 'finally should parse'

# throw

assert parses('throw myEx;'), 'throw statements should parse'