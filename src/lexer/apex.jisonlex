digit              [0-9]
id                 [a-zA-Z][a-zA-Z0-9_]*

%%
"public"           return 'PUBLIC';
"private"          return 'PRIVATE';
"global"           return 'GLOBAL';
"class"            return 'CLASS';
"{"                return '{';
"}"                return '}';
{digit}+           return 'INTLITERAL';
{id}               return 'IDENTIFIER';
\s+                /* skip whitepace */
<<EOF>>            return 'EOF';
