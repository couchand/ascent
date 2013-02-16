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

modifier
 : PRIVATE
   { $$ = 'private'; }
 | PROTECTED
   { $$ = 'protected'; }
 | PUBLIC
   { $$ = 'public'; }
 | GLOBAL
   { $$ = 'global'; }
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
 | method
   { $$ = $method; }
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

method_name
 : identifier
   { $$ = $identifier; }
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
 : type identifier
   { $$ = [$type, $identifier]; }
 ;

method_body
 : '{' '}'
   { $$ = []; }
 ;

type
 : identifier
   { $$ = $identifier; }
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 ;
