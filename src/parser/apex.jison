/* apex grammar */

/*
 %right LAMBDA
 %left SEP
*/

%%

cls
  : class_header class_body EOF
    { $$ = [$class_header, $class_body]; }
  ;

class_header
 : class_descriptor CLASS identifier implements extends
   { $$ = [$identifier, $class_descriptor, $implements, $extends]; }
 ;

class_descriptor
 : class_visibility
   { $$ = $class_visibility; }
 | class_visibility class_modifiers
   { $$ = $class_modifiers; $$.unshift( $class_visibility ); }
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

implements
 :
   { $$ = []; }
 ;

extends
 :
   { $$ = []; }
 ;

class_body
 : '{' statements '}'
   { $$ = $statements; }
 ;

statements
 :
   { $$ = []; }
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 ;
