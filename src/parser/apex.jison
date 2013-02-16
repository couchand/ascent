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
   { $$ = $class_header; $$.body = $class_body; }
 ;

class_header
 : modifiers CLASS identifier class_taxonomy
   { $$ = { name: $identifier, modifiers: $modifiers, implements: $class_taxonomy.implements, extends: $class_taxonomy.extends }; }
 ;

inner_cls
 : inner_class_header class_body
   { $$ = $inner_class_header, $$.body = $class_body; }
 ;

inner_class_header
 : modifiers CLASS identifier class_taxonomy
   { $$ = { name: $identifier, modifiers: $modifiers, implements: $class_taxonomy.implements, extends: $class_taxonomy.extends }; }
 | CLASS identifier class_taxonomy
   { $$ = { name: $identifier, modifiers: [], taxonomy: $class_taxonomy }; }
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
 | TRANSIENT
   { $$ = 'transient'; }
 ;

class_taxonomy
 :
   { $$ = {}; }
 | implements
   { $$ = { implements: $implements }; }
 | extends
   { $$ = { extends: $extends }; }
 | implements extends
   { $$ = { implements: $implements, extends: $extends }; }
 | extends implements
   { $$ = { implements: $implements, extends: $extends }; }
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
   { $$ = $inner_cls; $$.inner_class = true; }
 | method
   { $$ = $method; $$.method = true; }
 | property
   { $$ = $property; $$.property = true; }
 | instance_initializer
   { $$ = $instance_initializer; $$.instance_initializer = true; }
 | static_initializer
   { $$ = $static_initializer; $$.static_initializer = true; }
 ;

method
 : modifiers fqn identifier '(' parameters ')' method_body
   { $$ = { name: $identifier, type: $fqn, modifiers: $modifiers, parameters: $parameters, body: $method_body }; }
 | fqn identifier '(' parameters ')' method_body
   { $$ = { name: $identifier, type: $fqn, modifiers: [], parameters: $parameters, body: $method_body }; }
 | modifiers identifier '(' parameters ')' method_body
   { $$ = { name: $identifier, type: $identifier, modifiers: $modifiers, parameters: $parameters, body: $method_body }; }
 | identifier '(' parameters ')' method_body
   { $$ = { name: $identifier, type: $identifier, modifiers: [], parameters: $parameters, body: $method_body }; }
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
 : fqn identifier
   { $$ = { type: $fqn, name: $identifier }; }
 ;

method_body
 : '{' '}'
   { $$ = []; }
 ;

instance_initializer
 : '{' '}'
   { $$ = { block: [] }; }
 ;

static_initializer
 : STATIC '{' '}'
   { $$ = { block: [] }; }
 ;

property
 : modifiers assignment ';'
   { $$ = $assignment; $$.modifiers = $modifiers; }
 | assignment ';'
   { $$ = $assignment; }
 | modifiers declaration ';'
   { $$ = $declaration; $$.modifiers = $modifiers; }
 | declaration ';'
   { $$ = $declaration; }
 | modifiers declaration '{' get_and_set '}'
   { $$ = $declaration; $$.modifiers = $modifiers; $$.get = $get_and_set.get; $$.set = $get_and_set.set; }
 | declaration '{' get_and_set '}'
   { $$ = $declaration; $$.get = $get_and_set.get; $$.set = $get_and_set.set; }
 ;

get_and_set
 : get_or_set
   { $$ = {}; $$[$get_or_set.accessor] = $get_or_set; }
 | get_or_set get_or_set
   { $$ = {}; $$[$get_or_set1.accessor] = $get_or_set1; $$[$get_or_set2.accessor] = $get_or_set2; }
 ;

get_or_set
 : identifier ';'
   { $$ = { accessor: $identifier }; }
 | access_modifier identifier ';'
   { $$ = { accessor: $identifier, modifiers: [$access_modifier] }; }
 | identifier '{' '}'
   { $$ = { accessor: $identifier, body: [] }; }
 | access_modifier identifier '{' '}'
   { $$ = { accessor: $identifier, modifiers: [$access_modifier], body: [] }; }
 ;

declaration
 : fqn identifier
   { $$ = { type: $fqn, name: $identifier }; }
 ;

assignment
 : fqn identifier '=' value
   { $$ = { type: $fqn, name: $identifier, initializer: $value }; }
 ;

fqn
 : identifier
   { $$ = [$identifier]; }
 | fqn '.' identifier
   { $$ = $fqn; $$.push( $identifier ); }
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 ;

value
 : INTLITERAL
   { $$ = yytext; }
 ;
