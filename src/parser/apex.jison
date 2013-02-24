/* apex grammar */

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
   { $$ = $inner_cls; $$.member = 'inner_class'; }
 | method
   { $$ = $method; $$.member = 'method'; }
 | property
   { $$ = $property; $$.member = 'property'; }
 | instance_initializer
   { $$ = $instance_initializer; $$.member = 'instance_initializer'; }
 | static_initializer
   { $$ = $static_initializer; $$.member = 'static_initializer'; }
 ;

method
 : modifiers identifier identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $identifier, modifiers: $modifiers, parameters: $parameters, body: $block_statements }; }
 | identifier identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $identifier, modifiers: [], parameters: $parameters, body: $block_statements }; }
 | modifiers identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $identifier, modifiers: $modifiers, parameters: $parameters, body: $block_statements }; }
 | identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $identifier, modifiers: [], parameters: $parameters, body: $block_statements }; }
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
   { $$ = { type: $identifier, name: $identifier }; }
 ;

block_statements
 : '{' '}'
   { $$ = []; }
 | '{' statements '}'
   { $$ = $statements; }
 ;

statements
 : statement
   { $$ = [$statement]; }
 | statements statement
   { $$ = $statements; $$.push($statement); }
 ;

statement
 : ';'
   { $$ = []; }
 | BREAK ';'
   { $$ = ['break']; }
 | CONTINUE ';'
   { $$ = ['continue']; }
 | THROW expression ';'
   { $$ = { throws: $expression }; }
 | declaration_statement
   { $$ = $declaration_statement; }
 | try_statement
   { $$ = $try_statement; }
 | if_statement
   { $$ = $if_statement; }
 | while_statement
   { $$ = $while_statement; }
 | do_while_statement
   { $$ = $do_while_statement; }
 | for_statement
   { $$ = $for_statement; }
 | block_statements
   { $$ = $block_statements; }
 | expression ';'
   { $$ = { expression: $expression }; }
 ;

try_statement
 : TRY block_statements catches
   { $$ = { block: $block_statements, catches: $catches }; }
 | TRY block_statements catches FINALLY block_statements
   { $$ = { block: $block_statements1, catches: $catches, finallyBlock: $block_statements2 }; }
 ;

catches
 : catch_clause
   { $$ = [$catch_clause]; }
 | catches catch_clause
   { $$ = $catches; $$.push($catch_clause); }
 ;

catch_clause
 : CATCH '(' parameter ')' block_statements
   { $$ = { parameter: $parameter, block: $block_statements }; }
 ;

if_statement
 : IF '(' expression ')' statement
   { $$ = { condition: $expression, block: $statement }; }
 | IF '(' expression ')' statement ELSE statement
   { $$ = { condition: $expression, block: $statement1, elseBlock: $statement2 }; }
 ;

while_statement
 : WHILE '(' expression ')' statement
   { $$ = { condition: $expression, block: $statement }; }
 ;

do_while_statement
 : DO block_statements WHILE '(' expression ')' ';'
   { $$ = { condition: $expression, block: $block_statements }; }
 ;

for_statement
 : FOR '(' for_initializer ';' for_condition ';' for_increment ')' statement
   { $$ = { initializer: $for_initializer, condition: $for_condition, increment: $for_increment,  block: $statement } }
 ;

for_initializer
 :
 | declaration
   { $$ = $declaration; }
 | expression
   { $$ = $expression; }
 ;

for_condition
 :
 | expression
   { $$ = $expression; }
 ;

for_increment
 :
 | expression
   { $$ = $expression; }
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
 : modifiers declaration_statement
   { $$ = $declaration_statement; $$.modifiers = $modifiers; }
 | declaration_statement
   { $$ = $declaration_statement; }
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
 | identifier block_statements
   { $$ = { accessor: $identifier, body: $block_statements }; }
 | access_modifier identifier block_statements
   { $$ = { accessor: $identifier, modifiers: [$access_modifier], body: $block_statements }; }
 ;

declaration_statement
 : declaration ';'
   { $$ = $declaration; }
 ;

declaration
 : identifier declarator
   { $$ = $declarator; $$.type = $identifier; }
 ;

declarator
 : identifier
   { $$ = { name: $identifier }; }
 | identifier  '=' expression
   { $$ = { name: $identifier, initializer: $expression } }
 ;

expression
 : identifier
   { $$ = $identifier; }
 | value
   { $$ = $value; }
 ;

identifier
 : IDENTIFIER
   { $$ = yytext; }
 | FQN
   { $$ = yytext; }
 ;

value
 : INTLITERAL
   { $$ = yytext; }
 | STRLITERAL
   { $$ = yytext; }
 | LNGLITERAL
   { $$ = yytext; }
 | DECLITERAL
   { $$ = yytext; }
 | TRUE
   { $$ = 'true'; }
 | FALSE
   { $$ = 'false'; }
 | NULL
   { $$ = 'null'; }
 ;
