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
 : class_visibility class_modifiers CLASS identifier implements extends
   { $$ = [$identifier, $class_visibility, $class_modifiers, $implements, $extends]; }
 ;

class_visibility
 :
   { $$ = []; }
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
