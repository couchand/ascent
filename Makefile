# make ascent package

all: cleaner parser nodes package
cleaner: dst/cleaner.js
parser: dst/parser.js
nodes: dst/nodes.js
package: dst/ascent.js

dst/cleaner.js: src/cleaner/cleaner.coffee
	coffee -c -o dst src/cleaner/cleaner.coffee

dst/parser.js: src/parser/ascent.jison src/lexer/ascent.jisonlex
	jison --debug "$DEBUG" -o dst/parser.js src/parser/ascent.jison src/lexer/ascent.jisonlex

	patch dst/parser.js cli.patch

dst/nodes.js: src/nodes.coffee
	coffee -c -o dst src/nodes.coffee

dst/ascent.js: src/ascent.coffee
	coffee -c -o dst src/ascent.coffee
