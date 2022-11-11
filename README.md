# PgLtree

[![Gem Version](https://badge.fury.io/rb/pg_ltree.svg)](http://badge.fury.io/rb/pg_ltree)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Build Status](https://github.com/sjke/pg_ltree/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/sjke/pg_ltree/actions/workflows/tests.yml?query=branch%3Amaster)
[![RubyDoc](http://inch-ci.org/github/sjke/pg_ltree.svg?branch=master)](http://www.rubydoc.info/github/sjke/pg_ltree/)

Adds PostgreSQL's [ltree](http://www.postgresql.org/docs/current/static/ltree.html) support for `ActiveRecord` models

## Installation

Add this line to your application's Gemfile:

    gem 'pg_ltree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_ltree

## Required

* **_Ruby_** >= 2.0
* **_Rails_** >= 5.2, < 8
* **_Pg adapter (gem 'pg')_** >= 1.0, < 2


## How to use
Enable `ltree` extension:
```ruby
class AddLtreeExtension < ActiveRecord::Migration
  def change
    enable_extension 'ltree'
  end
end
```

Add column with `ltree` type for your model
```ruby
class AddLtreePathToModel < ActiveRecord::Migration
  def change
    add_column :nodes, :path, :ltree
    add_index :nodes, :path, using: :gist
  end
end
```

Initialize `ltree` module in your model
```ruby
  class Node < ActiveRecord::Base
    ltree :path
    # ltree :path, cascade_update: false # Disable cascade update
    # ltree :path, cascade_destroy: false # Disable cascade destory
    # ltree :path, cascade_update: false, cascade_destroy: false # Disable cascade callbacks
  end
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/sjke/pg_ltree

## Changelog
See [CHANGELOG](CHANGELOG.md) for details.

## License
The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).
