ascent parser
=============

ascent is a language similar to apex.

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

parse status
------------

    Successfully parsed 71 out of 122
    Successfully parsed 42 out of 73
    Successfully parsed 38 out of 66
    Successfully parsed 138 out of 196
    Successfully parsed 36 out of 55

outstanding items
-----------------

 * true case-insensitivity
 * typecasting
 * soql/sosl
 * enums

dev dependencies
----------------

 * node 0.8.x
 * jison
 * coffeescript
