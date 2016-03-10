## 1.1.3

* [ADDED] node instance `height` method ([#6](https://github.com/sjke/pg_ltree/pull/6) by [@caulfield](https://github.com/caulfield))
* [FIXED] Fix #depth for a new record ([#9](https://github.com/sjke/pg_ltree/pull/9) by [@arjan0307](https://github.com/arjan0307))
* [IMPROVE] Use 'descendants' instead of 'descendents' ([#8](https://github.com/sjke/pg_ltree/pull/8) by [@CUnknown](https://github.com/CUnknown))

## 1.1.2

* [FIXED] Fix original #leaves method when merging with previous conditions was invalid. Overrided method in ScopedFor is useless now and it was deleted.

## 1.1.1

* [FIXED] `#cascade_update` method

## 1.1.0

* [ADDED] cascade update/destroy (Enabled by default)
* [FIXED] destroy object
