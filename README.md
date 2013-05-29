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

 * ap: 66/108
 * hds: 119/174

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
