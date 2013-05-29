ascent parser
=============

ascent is a language similar to apex.  it is significantly
more permissive than apex, with the goal of enabling
helpful error messages and debugging info.

 * introduction
 * parse status
 * outstanding items
 * dev dependencies

introduction
------------

build the parser with

```bash
> ./build_parser
```

parse files with

```javascript
ascent = require('./dst/ascent.js');
var ast = ascent.parse(src_file);
```

take a look at the (admittedly sketchy) tests for examples.

parse status
------------

running on a sampling of client code.

    Successfully parsed 79 out of 122
    Successfully parsed 48 out of 73
    Successfully parsed 43 out of 66
    Successfully parsed 154 out of 196
    Successfully parsed 40 out of 55

outstanding items
-----------------

these are the main apex features to address.

 * true case-insensitivity
 * enums
 * map initializers
 * array indexing
 * parens/typecasting is still wonky
 * final method params
 * instanceof
 * reserved words as class names (thx sfdc)
 * interface

parses with a hack, but needs semantics.

 * soql/sosl

dev dependencies
----------------

 * node 0.8.x
 * jison
 * coffeescript
