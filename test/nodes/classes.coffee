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
assertEqual 1, parsed.modifiers.length,
  'the modifiers should be parsed'
assertEqual 'public', parsed.modifiers[0],
  'public visibility should parse'
assertEqual 1, parsed.implements.length,
  'interfaces implemented should parse'
assertEqual 'Bar', parsed.implements[0],
  'interface names should parse'
assertEqual 1, parsed.extends.length,
  'classed extended should parse'
assertEqual 'Baz', parsed.extends[0],
  'abstract class names should parse'
