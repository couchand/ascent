/* apex grammar */

/*
 %right LAMBDA
 %left SEP
*/

%%

file
 : cls EOF
   { return $cls; }
 ;

cls
 : class_header class_body
   { $$ = [$class_header, $class_body]; }
 ;

class_header
 : modifiers CLASS identifier class_taxonomy
   { $$ = [$identifier, $modifiers, $class_taxonomy]; }
 ;

inner_cls
 : inner_class_header class_body
   { $$ = [$inner_class_header, $class_body]; }
 ;

inner_class_header
 : modifiers CLASS identifier class_taxonomy
   { $$ = [$identifier, $modifiers, $class_taxonomy]; }
 | CLASS identifier class_taxonomy
   { $$ = [$identifier, [], $class_taxonomy]; }
 ;

modifiers
 : modifier
   { $$ = [$modifier]; }
 | modifiers modifier
   { $$ = $modifiers; $$.push( $modifier ); }
 ;

access_modifier
 : PRIVATE
   { $$ = 'private'; }
 | PROTECTED
   { $$ = 'protected'; }
 | PUBLIC
   { $$ = 'public'; }
 | GLOBAL
   { $$ = 'global'; }
 ;

modifier
 : access_modifier
   { $$ = $access_modifier; }
 | VIRTUAL
   { $$ = 'virtual'; }
 | ABSTRACT
   { $$ = 'abstract'; }
 | WITHSHARING
   { $$ = 'with sharing'; }
 | WITHOUTSHARING
   { $$ = 'without sharing'; }
 | OVERRIDE
   { $$ = 'override'; }
 | STATIC
   { $$ = 'static'; }
 | FINAL
   { $$ = 'final'; }
 ;

class_taxonomy
 :
   { $$ = [[], []]; }
 | implements
   { $$ = [$implements, []]; }
 | extends
   { $$ = [[], $extends]; }
 | implements extends
   { $$ = [$implements, $extends]; }
 | extends implements
   { $$ = [$implements, $extends]; }
 ;

implements
 : IMPLEMENTS interface_names
   { $$ = $interface_names; }
 ;

interface_names
 : identifier
   { $$ = [$identifier]; }
 | interface_names ',' identifier
   { $$ = $interface_names; $$.push($identifier); }
 ;

extends
 : EXTENDS identifier
   { $$ = [$identifier]; }
 ;

class_body
 : '{' '}'
   { $$ = []; }
 | '{' class_members '}'
   { $$ = $class_members; }
 ;

class_members
 : class_member
   { $$ = [$class_member]; }
 | class_members class_member
   { $$ = $class_members; $$.push( $class_member ); }
 ;

class_member
 : inner_cls
   { $$ = $inner_cls; }
 | method
   { $$ = $method; }
 | property
   { $$ = $property; }
 ;

method
 : modifiers identifier identifier '(' parameters ')' method_body
   { $$ = [$identifier1, $identifier2, $modifiers, $parameters, $method_body]; }
 | identifier identifier '(' parameters ')' method_body
   { $$ = [$identifier1, $identifier2, [], $parameters, $method_body]; }
 | modifiers identifier '(' parameters ')' method_body
   { $$ = [$identifier, $identifier, $modifiers, $parameters, $method_body]; }
 | identifier '(' parameters ')' method_body
   { $$ = [$identifier, $identifier, [], $parameters, $method_body]; }
 ;

parameters
 :
   { $$ = []; }
 | parameter
   { $$ = [$parameter]; }
 | parameters ',' parameter
   { $$ = $parameters; $$.push($parameter); }
 ;

parameter
 : identifier identifier
   { $$ = [$identifier1, $identifier2]; }
 ;

method_body
 : '{' '}'
   { $$ = []; }
 ;

property
 : modifiers assignment ';'
   { $$ = [$assignment, $modifiers]; }
 | assignment ';'
   { $$ = [$assignment, []]; }
 | modifiers declaration ';'
   { $$ = [[$declaration], $modifiers]; }
 | declaration ';'
   { $$ = [[$declaration], []]; }
 | modifiers declaration '{' get_and_set '}'
   { $$ = [[$declaration], $modifiers, $get_and_set]; }
 | declaration '{' get_and_set '}'
   { $$ = [[$declaration], [], $get_and_set]; }
 ;

get_and_set
 : get_or_set
   { $$ = [$get_or_set]; }
 | get_or_set get_or_set
   { $$ = [$get_or_set1, $get_or_set2]; }
 ;

get_or_set
 : identifier ';'
   { $$ = [$identifier, []]; }
 | access_modifier identifier ';'
   { $$ = [$identifier, [$access_modifier]]; }
 ;

declaration
 : identifier identifier
   { $$ = [$identifier1, $identifier2]; }
 ;

assignment
 : identifier identifier '=' value
   { $$ = [$identifier1, $identifier2, $value]; }
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 ;

value
 : INTLITERAL
   { $$ = yytext; }
 ;
