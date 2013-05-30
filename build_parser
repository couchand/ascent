# make ascent package

all: cleaner parser nodes package success
cleaner: dst/cleaner.js
parser: dst/parser.js
nodes: dst/nodes.js
package: building_package dst/ascent.js

dst/cleaner.js: src/cleaner/cleaner.coffee
	echo "building cleaner"
	echo "> coffee -c -o dst src/cleaner/cleaner.coffee"
	coffee -c -o dst src/cleaner/cleaner.coffee

dst/parser.js: src/parser/ascent.jison src/lexer/ascent.jisonlex
	echo "building parser"
	echo "> jison -o dst/parser.js src/parser/ascent.jison src/lexer/ascent.jisonlex"
	jison --debug "$DEBUG" -o dst/parser.js src/parser/ascent.jison src/lexer/ascent.jisonlex

	echo "patching cli"
	echo "> patch dst/parser.js cli.patch"
	patch dst/parser.js cli.patch

building_package:
	echo "building package"

dst/nodes.js: src/nodes.coffee
	echo "> coffee -c -o dst src/nodes.coffee"
	coffee -c -o dst src/nodes.coffee

dst/ascent.js: src/ascent.coffee
	echo "> coffee -c -o dst src/ascent.coffee"
	coffee -c -o dst src/ascent.coffee

success:
	echo "success!"
