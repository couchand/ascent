digit                   [0-9]
id                      [a-zA-Z][a-zA-Z0-9_]*

%%
"//".*                  /* ignore comment */
"/*"(\n|.)*"*/"         /* ignore block comment */
"'"(\\\')?(\n|([^\\]|[^\\]\\\\)\\\'|[^'])*"'"   return 'STRLITERAL';
"public"                return 'PUBLIC';
"private"               return 'PRIVATE';
"protected"             return 'PROTECTED';
"global"                return 'GLOBAL';
"abstract"              return 'ABSTRACT';
"virtual"               return 'VIRTUAL';
"override"              return 'OVERRIDE';
"static"                return 'STATIC';
"final"                 return 'FINAL';
"transient"             return 'TRANSIENT';
"with"\s+"sharing"      return 'WITHSHARING';
"without"\s+"sharing"   return 'WITHOUTSHARING';
"class"                 return 'CLASS';
"implements"            return 'IMPLEMENTS';
"extends"               return 'EXTENDS';
";"                     return ';';
","                     return ',';
"."                    return '.';
"="                     return '=';
"{"                     return '{';
"}"                     return '}';
"("                     return '(';
")"                     return ')';
{digit}+                return 'INTLITERAL';
{id}                    return 'IDENTIFIER';
\s+                     /* skip whitepace */
<<EOF>>                 return 'EOF';
