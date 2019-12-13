## 1.1.8

* [IMPROVE] Update rails/pg version support (rails 6, pg 1.0)
* [FIXED] Fix #leaves used with a custom relation ([#29](https://github.com/sjke/pg_ltree/pull/29) by [@attilahorvath](https://github.com/attilahorvath))

## 1.1.7

* [IMPROVE] Update rails/pg version support (rails 5.2, pg 1.0)

## 1.1.6

* [IMPROVE] Adds `table_name` prefix for a generating SQL queries ([#21](https://github.com/sjke/pg_ltree/pull/21) by [@arjan0307](https://github.com/arjan0307))

## 1.1.5

* [IMPROVE] Update pg version support ([#19](https://github.com/sjke/pg_ltree/pull/19) by [@askamist](https://github.com/askamist))
* [IMPROVE] Handler Rails 5.1 deprecation warnings ([#18](https://github.com/sjke/pg_ltree/pull/18) by [@HoyaBoya](https://github.com/HoyaBoya) and [#20](https://github.com/sjke/pg_ltree/pull/20) by [@sjke](https://github.com/sjke))

## 1.1.4

* [ADDED] Adds method to support ltxtquery value for searching ([#17](https://github.com/sjke/pg_ltree/pull/17) by [@sb1752](https://github.com/sb1752))
* [IMPROVE] Updated dependency version (Rails 5.1 and Pg adapter 0.21) ([#16](https://github.com/sjke/pg_ltree/pull/16) by [@sb1752](https://github.com/sb1752))

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
