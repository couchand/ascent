# class node tests

p = require '../../dst/ascent'

assert = (val, msg) ->
  throw new Error msg if !val
assertEqual = (expected, actual, msg) ->
  assert expected is actual,
    "expected #{actual} to be #{expected}: #{msg}"

test_class =
"""
public class Foo implements Bar extends Baz {}
"""

parsed = p.parse test_class

assert parsed instanceof p.ApexClass,
  'root node should be class type'
assertEqual 'Foo', parsed.name,
  'class name should be parsed'
