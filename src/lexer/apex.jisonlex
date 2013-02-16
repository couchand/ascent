digit              [0-9]
id                 [a-zA-Z][a-zA-Z0-9_]*

%%
"class"            return 'CLASS';
"{"                return '{';
"}"                return '}';
{digit}+           return 'INTLITERAL';
{id}               return 'IDENTIFIER';
\s+                /* skip whitepace */
<<EOF>>            return 'EOF';
