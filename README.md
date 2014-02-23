# chainmap.el

[ChainMap](http://docs.python.org/dev/library/collections#collections.ChainMap) implementation in Emacs Lisp.

## Interfaces

#### `(chainmap map1 map2 ...)`

Create chain map

#### `(chainmap-parents chainmap)`

Return parent chainmap

#### `(chainmap-new-child chainmap)`

Create `new-map` and add it to `chainmap`, return `new-map`

#### `(chainmap-gethash key chainmap)`

Get value of `key` from `chainmap`

#### `(chainmap-puthash key value chainmap)`

Put `key => value` into chainmap

#### `(chaninmap-remhash key chainmap`)

Remove value of `key` from chainmap
