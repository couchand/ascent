digit                   [0-9]
id                      [a-zA-Z][a-zA-Z0-9_]*

%%
"public"                return 'PUBLIC';
"private"               return 'PRIVATE';
"global"                return 'GLOBAL';
"abstract"              return 'ABSTRACT';
"virtual"               return 'VIRTUAL';
"with"\s+"sharing"      return 'WITHSHARING';
"without"\s+"sharing"   return 'WITHOUTSHARING';
"class"                 return 'CLASS';
"implements"            return 'IMPLEMENTS';
"extends"               return 'EXTENDS';
","                     return ',';
"{"                     return '{';
"}"                     return '}';
{digit}+                return 'INTLITERAL';
{id}                    return 'IDENTIFIER';
\s+                     /* skip whitepace */
<<EOF>>                 return 'EOF';
