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
 : class_descriptor CLASS identifier class_taxonomy
   { $$ = [$identifier, $class_descriptor, $class_taxonomy]; }
 ;

inner_cls
 : inner_class_header class_body
   { $$ = [$inner_class_header, $class_body]; }
 ;

inner_class_header
 : inner_class_descriptor CLASS identifier class_taxonomy
   { $$ = [$identifier, $inner_class_descriptor, $class_taxonomy]; }
 ;

class_descriptor
 : class_visibility
   { $$ = [$class_visibility, []]; }
 | class_visibility class_modifiers
   { $$ = [$class_visibility, $class_modifiers]; }
 | class_modifiers class_visibility
   { $$ = [$class_visibility, $class_modifiers]; }
 | class_modifiers class_visibility class_modifiers
   { $$ = [$class_visibility, $class_modifiers1]; $$[1].push.apply($$[1], $class_modifiers2); }
 ;

inner_class_descriptor
 :
   { $$ = [[], []]; }
 | class_descriptor
   { $$ = $class_descriptor; }
 ;

class_visibility
 : PRIVATE
   { $$ = 'private'; }
 | PUBLIC
   { $$ = 'public'; }
 | GLOBAL
   { $$ = 'global'; }
 ;

class_modifiers
 : class_modifier
   { $$ = [$class_modifier]; }
 | class_modifiers class_modifier
   { $$ = $class_modifiers; $$.push( $class_modifier ); }
 ;

class_modifier
 : VIRTUAL
   { $$ = 'virtual'; }
 | ABSTRACT
   { $$ = 'abstract'; }
 | WITHSHARING
   { $$ = 'with sharing'; }
 | WITHOUTSHARING
   { $$ = 'without sharing'; }
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
 : interface_name
   { $$ = [$interface_name]; }
 | interface_names ',' interface_name
   { $$ = $interface_names; $$.push($interface_name); }
 ;

interface_name
 : IDENTIFIER
   { $$ = yytext; }
 ;

extends
 : EXTENDS base_class
   { $$ = [$base_class]; }
 ;

base_class
 : IDENTIFIER
   { $$ = yytext; }
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
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 ;
