# statement parsing tests

p = require '../../dst/ascent.js'

assert = (val, msg) ->
  throw new Error msg if !val

parses = (str) ->
  try
    p.parse "public class Foo { void doFoo(){#{str}} }"
  catch error
    no

# empty statement

assert parses(';'), 'an empty statement should parse'
assert parses(';;;'), 'multiple empty statements should parse'

# statement block

assert parses('{}'), 'an empty block should parse'
assert parses('{;}'), 'a non-empty block should parse'

# assignment expression

assert parses('foo = 5;'), 'assignment expressions should parse'

# increment expression

assert parses('foo++;'), 'increment expression statements should parse'

# break and continue

assert parses('break;'), 'break statements should parse'
assert parses('continue;'), 'continue statements should parse'

# return

assert parses('return;'), 'simple return should parse'
assert parses('return true;'), 'return with a value should parse'

# variable declaration

assert parses('Integer i;'), 'simple declarations should parse'
assert parses('Integer i = 42;'), 'initializers should parse'
assert parses('final Integer i;'), 'final declarations should parse'
assert parses('final Integer i = 42;'), 'final initializers should parse'

assert parses('Integer i, j;'), 'compound declarations should parse'
assert parses('Integer i = 42, j;'), 'compound initializers should parse'
assert parses('Integer i = 45, j = 43;'), 'compound initializers should parse'
assert parses('final Integer i, j = 54;'), 'final compound declarations should parse'

# if

assert parses('if (true) ;'), 'simple if statements should parse'
assert parses('if (true) ; else ;'), 'else should parse'
assert parses('if (true) {} else {}'), 'if else statement blocks should parse'
assert parses('if (true) {} else if (false) {} else {}'), 'else if should parse'

# while

assert parses('while(1) ;'), 'simple while loops should parse'
assert parses('while(true) {}'), 'while loop blocks should parse'
assert parses('do {} while(1);'), 'do while loops should parse'

# for

assert parses('for( ;; ) ;'), 'simple for loops should parse'
assert parses('for( ;; ) {}'), 'for blocks should parse'
assert parses('for( Integer i = 5;; ) ;'), 'for initializers should parse'
assert parses('for( i = 6;; ) ;'), 'for expression initializers should parse'
assert parses('for( ; true; ) ;'), 'for conditions should parse'
assert parses('for( ;; false ) ;'), 'for increments should parse'

assert parses('for( Integer i : listOfNumbers ) ;'), 'list for loops should parse'

# try/catch

assert parses('try {} catch (Exception ex){}'), 'try catch should parse'
assert parses('try {} catch (Exception ex){} catch (AnotherException ex){}'), 'multiple catches should parse'
assert parses('try {} catch (Exception ex){} finally {}'), 'finally should parse'

# throw

assert parses('throw myEx;'), 'throw statements should parse'

# dml

assert parses('insert accounts;'), 'insert should parse'
assert parses('update accounts;'), 'update should parse'
assert parses('delete accounts;'), 'delete should parse'
assert parses('undelete accounts;'), 'undelete should parse'
assert parses('merge bigAccount smallAccount;'), 'merge should parse'
assert parses('upsert accounts;'), 'upsert should parse'
assert parses('upsert accounts sugarId;'), 'upsert with external id should parse'
