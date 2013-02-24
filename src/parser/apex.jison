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
   { $$ = { name: $identifier1, type: $identifier2, modifiers: $modifiers, parameters: $parameters, body: $block_statements }; }
 | identifier identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier1, type: $identifier2, modifiers: [], parameters: $parameters, body: $block_statements }; }
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
   { $$ = { type: $identifier1, name: $identifier2 }; }
 | collection_type identifier
   { $$ = { type: $collection_type, name: $identifier }; }
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
 | return_statement
   { $$ = $return_statement; }
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
 | assignment_expression ';'
   { $$ = { expression: $assignment_expression }; }
 ;

return_statement
 : RETURN ';'
   { $$ = { returns: [] }; }
 | RETURN expression ';'
   { $$ = { returns: [$expression] }; }
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
   { $$ = { initializer: $for_initializer, condition: $for_condition, increment: $for_increment,  block: $statement }; }
 | FOR '(' identifier identifier ':' expression ')' statement
   { $$ = { iterator: { name: $identifier2, type: $identifier1 }, domain: $expression, block: $statement }; }
 ;

for_initializer
 :
 | declaration
   { $$ = $declaration; }
 | assignment_expression
   { $$ = $assignment_expression; }
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
 : block_statements
   { $$ = { block: $block_statements }; }
 ;

static_initializer
 : STATIC block_statements
   { $$ = { block: $block_statements }; }
 ;

property
 : modifiers declaration ';'
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
 | identifier block_statements
   { $$ = { accessor: $identifier, body: $block_statements }; }
 | access_modifier identifier block_statements
   { $$ = { accessor: $identifier, modifiers: [$access_modifier], body: $block_statements }; }
 ;

declaration_statement
 : declaration ';'
   { $$ = $declaration; }
 | FINAL declaration ';'
   { $$ = $declaration; $$.modifiers = ['final']; }
 ;

declaration
 : identifier declarator
   { $$ = $declarator; $$.type = $identifier; }
 | collection_type declarator
   { $$ = $declarator; $$.type = $collection_type; }
 ;

declarator
 : identifier
   { $$ = { name: $identifier }; }
 | identifier '=' expression
   { $$ = { name: $identifier, initializer: $expression } }
 ;

expression
 : assignment_expression
   { $$ = $assignment_expression; }
 | expression9
   { $$ = $expression9; }
 ;

expression9
 : ternary_expression
   { $$ = $ternary_expression; }
 | expression8
   { $$ = $expression8; }
 ;

expression8
 : logical_or_expression
   { $$ = $logical_or_expression; }
 | expression7
   { $$ = $expression7; }
 ;

expression7
 : logical_and_expression
   { $$ = $logical_and_expression; }
 | expression6
   { $$ = $expression6; }
 ;

expression6
 : equality_expression
   { $$ = $equality_expression; }
 | expression5
   { $$ = $expression5; }
 ;

expression5
 : inequality_expression
   { $$ = $inequality_expression; }
 | expression4
   { $$ = $expression4; }
 ;

expression4
 : addition_expression
   { $$ = $addition_expression; }
 | expression4b
   { $$ = $expression4b; }
 ;

expression4b
 : subtraction_expression
   { $$ = $subtraction_expression; }
 | expression3
   { $$ = $expression3; }
 ;

expression3
 : multiplication_expression
   { $$ = $multiplication_expression; }
 | expression3b
   { $$ = $expression3b; }
 ;

expression3b
 : division_expression
   { $$ = $division_expression; }
 | expression2
   { $$ = $expression2; }
 ;

expression2
 : invert_expression
   { $$ = $invert_expression; }
 | negative_expression
   { $$ = $negative_expression; }
 | nullipotent_expression
   { $$ = $nullipotent_expression; }
 | expression1
   { $$ = $expression1; }
 ;

expression1
 : prefix_expression
   { $$ = $prefix_expression; }
 | postfix_expression
   { $$ = $postfix_expression; }
 | primary
   { $$ = $primary; }
 ;

primary
 : parenthesized_expression
   { $$ = $parenthesized_expression; }
 | identifier
   { $$ = $identifier; }
 | value
   { $$ = $value; }
 ;

assignment_expression
 : identifier '=' expression
   { $$ = { name: $identifier, value: $expression }; }
 ;

ternary_expression
 : expression8 '?' expression9 ':' expression9
   { $$ = { condition: $expression8, trueValue: $expression91, falseValue: $expression92 }; }
 ;

logical_or_expression
 : expression7 '||' expression8
   { $$ = { left: $expression7, right: $expression8 }; }
 ;

logical_and_expression
 : expression6 '&&' expression7
   { $$ = { left: $expression6, right: $expression7 }; }
 ;

equality_expression
 : expression5 equality_operator expression5
   { $$ = { left: $expression51, right: $expression52 }; }
 ;

equality_operator
 : '=='
 | '==='
 | '!='
 | '!=='
 ;

inequality_expression
 : expression4 inequality_operator expression4
   { $$ = { left: $expression41, right: $expression42 }; }
 ;

inequality_operator
 : '<'
 | '<='
 | '>'
 | '>='
 ;

addition_expression
 : expression4b '+' expression4
   { $$ = { left: $expression4b, right: $expression4 }; }
 ;

subtraction_expression
 : expression3 '-' expression4b
   { $$ = { left: $expression3, right: $expression4b }; }
 ;

multiplication_expression
 : expression3b '*' expression3
   { $$ = { left: $expression3b, right: $expression3 }; }
 ;

division_expression
 : expression2 '/' expression3b
   { $$ = { left: $expression2, right: $expression3b }; }
 ;

invert_expression
 : '!' expression2
   { $$ = { inverse: $expression2 }; }
 ;

negative_expression
 : '-' expression1
   { $$ = { negative: $expression1 }; }
 ;

nullipotent_expression
 : '+' expression1
   { $$ = $expression1; }
 ;

prefix_expression
 : prefix_operator primary
   { $$ = { expression: $primary }; }
 ;

postfix_expression
 : primary postfix_operator
   { $$ = { expression: $primary }; }
 ;

prefix_operator
 : '++'
 | '--'
 ;

postfix_operator
 : '++'
 | '--'
 ;

parenthesized_expression
 : '(' expression ')'
   { $$ = $expression; }
 ;

collection_type
 : identifier '<' nested_types '>'
 ;

nested_types
 : nested_type
 | nested_type ',' nested_type
 ;

nested_type
 : collection_type
 | identifier
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
