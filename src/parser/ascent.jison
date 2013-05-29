/* apex grammar */

%%

file
 : cls EOF
   { return $cls; }
 | trg EOF
   { return $trg; }
 ;

cls
 : class_header class_body
   { $$ = $class_header; $$.body = $class_body; }
 ;

trg
 : trigger_header trigger_body
   { $$ = $trigger_header; $$.body = $trigger_body; }
 ;

class_header
 : modifiers CLASS identifier class_taxonomy
   { $$ = { name: $identifier, modifiers: $modifiers, implements: $class_taxonomy.implements, extends: $class_taxonomy.extends }; }
 ;

trigger_header
 : TRIGGER identifier ON identifier '(' ')'
   { $$ = { name: $identifier1, trigger_object: $identifier2, conditions: [] }; }
 | TRIGGER identifier ON identifier '(' trigger_conditions ')'
   { $$ = { name: $identifier1, trigger_object: $identifier2, conditions: $trigger_conditions }; }
 ;

trigger_body
 : block_statements
 ;

trigger_conditions
 : trigger_condition
   { $$ = []; }
 | trigger_conditions ',' trigger_condition
   { $$ = $trigger_conditions; $$.push( $trigger_condition ); }
 ;

trigger_condition
 : trigger_time trigger_op
   { $$ = { time: $trigger_time, op: $trigger_op }; }
 ;

trigger_time
 : BEFORE
 | AFTER
 ;

trigger_op
 : INSERT
 | UPDATE
 | DELETE
 | UNDELETE
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
 | TESTMETHOD
   { $$ = 'testMethod'; }
 | STATIC
   { $$ = 'static'; }
 | FINAL
   { $$ = 'final'; }
 | TRANSIENT
   { $$ = 'transient'; }
 | ANNOTATION
   { $$ = { annotation: yytext }; }
 | ANNOTATION '(' identifier '=' value ')'
   { $$ = { annotation: yytext, option: $identifier, value: $value }; }
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
 : interface_name
   { $$ = [$interface_name]; }
 | interface_names ',' interface_name
   { $$ = $interface_names; $$.push($interface_name); }
 ;

interface_name
 : identifier
   { $$ = $identifier; }
 | collection_type
   { $$ = $collection_type; }
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
   { $$ = { name: $identifier2, type: $identifier1, modifiers: $modifiers, parameters: $parameters, body: $block_statements }; }
 | identifier identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier2, type: $identifier1, modifiers: [], parameters: $parameters, body: $block_statements }; }
 | modifiers collection_type identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $collection_type, modifiers: $modifiers, parameters: $parameters, body: $block_statements }; }
 | collection_type identifier '(' parameters ')' block_statements
   { $$ = { name: $identifier, type: $collection_type, modifiers: [], parameters: $parameters, body: $block_statements }; }
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
   { $$ = { statement: 'break' }; }
 | CONTINUE ';'
   { $$ = { statement: 'continue' }; }
 | return_statement
   { $$ = $return_statement; $$.statement = 'return'; }
 | THROW expression ';'
   { $$ = { throws: $expression, statement: 'throw' }; }
 | declaration_statement
   { $$ = $declaration_statement; $$.statement = 'declaration'; }
 | try_statement
   { $$ = $try_statement; $$.statement = 'try'; }
 | if_statement
   { $$ = $if_statement; $$.statement = 'if'; }
 | while_statement
   { $$ = $while_statement; $$.statement = 'while'; }
 | do_while_statement
   { $$ = $do_while_statement; $$.statement = 'do while'; }
 | for_statement
   { $$ = $for_statement; $$.statement = 'for'; }
 | block_statements
   { $$ = { block: $block_statements, statement: 'block' }; }
 | assignment_expression ';'
   { $$ = { expression: $assignment_expression, statement: 'assignment' }; }
 | prefix_expression ';'
   { $$ = { expression: $prefix_expression, statement: 'prefix' }; }
 | postfix_expression ';'
   { $$ = { expression: $postfix_expression, statement: 'postfix' }; }
 | method_call ';'
   { $$ = { expression: $method_call, statement: 'method call' }; }
 | run_as_block
   { $$ = { expression: $run_as_block, statement: 'runAs' }; }
 | dml_statement
   { $$ = $dml_statement; $$.statement = 'dml'; }
 ;

dml_statement
 : regular_dml_statement ';'
   { $$ = $regular_dml_statement; }
 | upsert_statement ';'
   { $$ = $upsert_statement; }
 | merge_statement ';'
   { $$ = $merge_statement; }
 ;

regular_dml_statement
 : dml_keyword expression
   { $$ = { operation: $dml_keyword, expression: $expression }; }
 ;

dml_keyword
 : INSERT
 | UPDATE
 | DELETE
 | UNDELETE
 ;

upsert_statement
 : UPSERT expression
   { $$ = { operation: 'upsert', expression: $expression }; }
 | UPSERT expression identifier
   { $$ = { operation: 'upsert', expression: $expression, externalId: $identifier }; }
 ;

merge_statement
 : MERGE expression expression
   { $$ = { operation: 'merge', left: $expression1, right: $expression2 }; }
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
 : identifier declarators
   { $$ = { vars: $declarators, type: $identifier }; }
 | collection_type declarators
   { $$ = { vars: $declarators, type: $collection_type }; }
 ;

declarators
 : declarator
   { $$ = [$declarator]; }
 | declarators ',' declarator
   { $$ = $declarators; $$.unshift($declarator); }
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
 | typecast_expression
   { $$ = $typecast_expression; }
 | expression0
   { $$ = $expression0; }
 ;

expression0
 : new_allocation
   { $$ = $new_allocation; }
 | primary
   { $$ = $primary; }
 ;

primary
 : parenthesized_expression
   { $$ = $parenthesized_expression; }
 | primary_no_parens
   { $$ = $primary_no_parens; }
 ;

new_allocation
 : NEW primary_no_parens '(' arg_list ')'
   { $$ = { callee: $primary_no_parens, argv: $arg_list }; }
 | NEW collection_type '(' arg_list ')'
   { $$ = { callee: $collection_type, argv: $arg_list }; }
 | NEW collection_type '{' initialization_list '}'
   { $$ = { callee: $collection_type, initializer: $initialization_list }; }
 ;

initialization_list
 :
 | expression
   { $$ = [$expression]; }
 | initialization_list ',' expression
   { $$ = $initialization_list, $$.push($expression); }
 ;

primary_no_parens
 : identifier
   { $$ = $identifier; }
 | value
   { $$ = $value; }
 | field_access
   { $$ = $field_access; }
 | array_access
   { $$ = $array_access; }
 | method_call
   { $$ = $method_call; }
 ;

field_access
 : primary '.' identifier
   { $$ = { receiver: $primary, field: $identifier }; }
 ;

array_access
 : primary '[' expression ']'
   { $$ = { receiver: $primary, index: $expression }; }
 ;

method_call
 : primary_no_parens '(' arg_list ')'
   { $$ = { callee: $primary_no_parens, argv: $arg_list }; }
 ;

run_as_block
 : primary_no_parens '(' arg_list ')' block_statements
   { $$ = { callee: $primary_no_parens, argv: $arg_list, block: $block_statements }; }
 ;

arg_list
 :
   { $$ = []; }
 | expression
   { $$ = [$expression]; }
 | arg_list ',' expression
   { $$ = $arg_list; $$.push($expression); }
 ;

assignment_expression
 : expression2 assignment_operator expression
   { $$ = { operator: $assignment_operator, name: $expression2, value: $expression }; }
 ;

assignment_operator
 : '='
 | '+='
 | '-='
 | '*='
 | '/='
 ;

ternary_expression
 : expression8 '?' expression9 ':' expression9
   { $$ = { condition: $expression8, trueValue: $expression91, falseValue: $expression92 }; }
 ;

logical_or_expression
 : expression7 '||' expression8
   { $$ = { operator: '||', left: $expression7, right: $expression8 }; }
 ;

logical_and_expression
 : expression6 '&&' expression7
   { $$ = { operator: '&&', left: $expression6, right: $expression7 }; }
 ;

equality_expression
 : expression5 equality_operator expression5
   { $$ = { operator: $equality_operator, left: $expression51, right: $expression52 }; }
 ;

equality_operator
 : '=='
 | '==='
 | '!='
 | '!=='
 ;

inequality_expression
 : expression4 inequality_operator expression4
   { $$ = { operator: $inequality_operator, left: $expression41, right: $expression42 }; }
 ;

inequality_operator
 : '<'
 | '<='
 | '>'
 | '>='
 ;

addition_expression
 : expression4b '+' expression4
   { $$ = { operator: '+', left: $expression4b, right: $expression4 }; }
 ;

subtraction_expression
 : expression3 '-' expression4b
   { $$ = { operator: '-', left: $expression3, right: $expression4b }; }
 ;

multiplication_expression
 : expression3b '*' expression3
   { $$ = { operator: '*', left: $expression3b, right: $expression3 }; }
 ;

division_expression
 : expression2 '/' expression3b
   { $$ = { operator: '/', left: $expression2, right: $expression3b }; }
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
   { $$ = { prefix: $prefix_operator, expression: $primary }; }
 ;

postfix_expression
 : primary postfix_operator
   { $$ = { postfix: $postfix_operator, expression: $primary }; }
 ;

typecast_expression
 : parenthesized_expression expression
   { $$ = { typecast: $parenthesized_expression.parenthesized, expression: $expression }; }
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
   { $$ = { parenthesized: $expression }; }
 ;

collection_type
 : identifier '<' nested_types '>'
   { $$ = { container: $identifier, contains: $nested_types }; }
 | identifier '[' ']'
   { $$ = { container: '[]', contains: $identifier }; }
 ;

nested_types
 : nested_type
   { $$ = $nested_type; }
 | nested_type ',' nested_type
   { $$ = [$nested_type1, $nested_type2]; }
 ;

nested_type
 : collection_type
   { $$ = $collection_type; }
 | identifier
   { $$ = $identifier; }
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
