# grammar.coffee
# the ascent grammar, revised

# the dsl here is (of course) inspired by coffeescript's
o = (patternString, action) ->
  patternString = patternString.replace /\s{2,}/g, ' '
  return [patternString, "$$ = yytext;"] unless action
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

  modifiers: [
    o 'modifier', '[$modifier]'
    o 'modifiers modifier', '$modifiers; $$.push( $modifier )'
  ]

  access_modifier: [
    o 'PRIVATE'
    o 'PROTECTED'
    o 'PUBLIC'
    o 'GLOBAL'
  ]

  modifier: [
    o 'access_modifier', '$1'
    o 'VIRTUAL'
    o 'ABSTRACT'
    o 'WITHSHARING'
    o 'WITHOUTSHARING'
    o 'OVERRIDE'
    o 'TESTMETHOD'
    o 'STATIC'
    o 'FINAL'
    o 'TRANSIENT'
    o 'ANNOTATION', '{ annotation: yytext }'
    o 'ANNOTATION \'(\' identifier \'=\' value \')\'', '{ annotation: yytext, option: $identifier, value: $value }'
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

console.log compile()
