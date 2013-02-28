# grammar.coffee
# the ascent grammar, revised

# the dsl here is (of course) inspired by coffeescript's
o = (patternString, action) ->
  patternString = patternString.replace /\s{2,}/g, ' '
  return [patternString, "$$ = $1;"] unless action
  return [patternString, "$$ = #{action};"]

grammar =

  cls: [
    o 'class_header class_body', '$class_header; $$.body = $class_body'
  ]

  class_header: [
    o 'modifiers CLASS identifier class_taxonomy',
      '{ name: $identifier, modifiers: $modifiers, implements: $class_taxonomy.implements, extends: $class_taxonomy.extends }'
  ]

  inner_cls: [
    o 'inner_class_header class_body', '$inner_class_header, $$.body = $class_body'
  ]

  inner_class_header: [
    o 'modifiers CLASS identifier class_taxonomy',
      '{ name: $identifier, modifiers: $modifiers, implements: $class_taxonomy.implements, extends: $class_taxonomy.extends }'
    o 'CLASS identifier class_taxonomy',
      '{ name: $identifier, modifiers: [], taxonomy: $class_taxonomy }'
  ]

compileAlternative = (alt) ->
  """
  #{alt[0]}
     { #{alt[1]} }
  """

compile = ->
  results = for name, alternatives of grammar
    result = "#{name}\n : "
    result += (compileAlternative alternative for alternative in alternatives).join '\n | '
    result += '\n ;\n'
  results.join '\n'

module.exports =
  compile: compile
