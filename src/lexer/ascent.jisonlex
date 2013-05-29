digit                   [0-9]
id                      [a-zA-Z][a-zA-Z0-9_]*

%options case-insensitive

%%
"//".*                  /* ignore comment */
"/*"(\n|\r|.)*?"*/"         /* ignore block comment */
"'"(\\\')?(\n|([^\\]|[^\\]\\\\)\\\'|[^'])*"'"   return 'STRLITERAL';
"["(\t|\n|[ ])*([sS][eE][lL][eE][cC][tT])[^\]]*"]"  return 'IDENTIFIER'; /* a.k.a. the SOQL hack */
"public"                return 'PUBLIC';
"private"               return 'PRIVATE';
"protected"             return 'PROTECTED';
"global"                return 'GLOBAL';
"abstract"              return 'ABSTRACT';
"virtual"               return 'VIRTUAL';
"override"              return 'OVERRIDE';
"testMethod"            return 'TESTMETHOD';
"static"                return 'STATIC';
"finally"               return 'FINALLY';
"final"                 return 'FINAL';
"transient"             return 'TRANSIENT';
"with"\s+"sharing"      return 'WITHSHARING';
"without"\s+"sharing"   return 'WITHOUTSHARING';
"class"                 return 'CLASS';
"implements"            return 'IMPLEMENTS';
"extends"               return 'EXTENDS';
"trigger"               return 'TRIGGER';
"on"                    return 'ON';
"before"                return 'BEFORE';
"after"                 return 'AFTER';
"true"                  return 'TRUE';
"false"                 return 'FALSE';
"null"                  return 'NULL';
"break"                 return 'BREAK';
"continue"              return 'CONTINUE';
"return"                return 'RETURN';
"try"                   return 'TRY';
"catch"                 return 'CATCH';
"throw"                 return 'THROW';
"if"                    return 'IF';
"else"                  return 'ELSE';
"while"                 return 'WHILE';
"do"                    return 'DO';
"for"                   return 'FOR';
"new"                   return 'NEW';
"insert"                return 'INSERT';
"update"                return 'UPDATE';
"delete"                return 'DELETE';
"undelete"              return 'UNDELETE';
"merge"                 return 'MERGE';
"upsert"                return 'UPSERT';
"||"                    return '||';
"&&"                    return '&&';
";"                     return ';';
"?"                     return '?';
":"                     return ':';
","                     return ',';
"."                     return '.';
"==="                   return '===';
"!=="                   return '!==';
"=="                    return '==';
"!="                    return '!=';
"<="                    return '<=';
">="                    return '>=';
"+="                    return '+=';
"-="                    return '-=';
"*="                    return '*=';
"/="                    return '/=';
"<"                     return '<';
">"                     return '>';
"="                     return '=';
"++"                    return '++';
"--"                    return '--';
"*"                     return '*';
"/"                     return '/';
"+"                     return '+';
"-"                     return '-';
"!"                     return '!';
"{"                     return '{';
"}"                     return '}';
"("                     return '(';
")"                     return ')';
"["                     return '[';
"]"                     return ']';
{digit}+"."{digit}+     return 'DECLITERAL';
{digit}+"L"             return 'LNGLITERAL';
{digit}+                return 'INTLITERAL';
"@"{id}                 return 'ANNOTATION';
{id}("."{id})+          return 'FQN';
{id}                    return 'IDENTIFIER';
\s+                     /* skip whitepace */
<<EOF>>                 return 'EOF';
