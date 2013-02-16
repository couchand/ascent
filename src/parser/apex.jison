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
 :
   { $$ = []; }
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
