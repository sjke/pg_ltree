# PgLtree

**Gem that allows use `ltree` in ActiveRecord models**.

It uses a implementation based around PostgreSQL's [ltree](http://www.postgresql.org/docs/current/static/ltree.html) data type, associated functions and operators.

|             |                                 |
| ----------- | :-----------------------------: |
| **Author**  |       Andrei Panamarenka        |
| **Version** |     1.1.9 (August 13, 2022)   |
| **License** | Released under the MIT license. |

##

[![Gem Version](https://badge.fury.io/rb/pg_ltree.svg)](http://badge.fury.io/rb/pg_ltree)
[![Build Status](https://travis-ci.org/sjke/pg_ltree.svg?branch=travis-ci)](https://travis-ci.org/sjke/pg_ltree)
[![Code Climate](https://codeclimate.com/github/sjke/pg_ltree/badges/gpa.svg)](https://codeclimate.com/github/sjke/pg_ltree)
[![RubyDoc](http://inch-ci.org/github/sjke/pg_ltree.svg?branch=master)](http://www.rubydoc.info/github/sjke/pg_ltree/)

## Support

* **_Ruby_** 2.\*
* **_Rails_** >= 4, < 8
* **_Pg adapter (gem 'pg')_** >= 0.17, < 2

## Installation

Add this line to your application's Gemfile:

    gem 'pg_ltree', '1.1.9'

And then execute:

    $ bundle

Add ltree extension to PostgreSQL:

```ruby
class AddLtreeExtension < ActiveRecord::Migration
  def change
    enable_extension 'ltree'
  end
end
```

Update your model:

```ruby
class AnyModel < ActiveRecord::Migration
  def change
    add_column :any_model, :path, :ltree

    add_index :any_model, :path, using: :gist
  end
end
```

Run migrations:

    $ bundle exec rake db:migrate

## Usage

```ruby
  class AnyModel < ActiveRecord::Base
    ltree :path
    # ltree :path, cascade: false # Disable cascade update and delete
  end

  root     = AnyModel.create!(path: 'Top')
  child    = AnyModel.create!(path: 'Top.Science')
  subchild = AnyModel.create!(path: 'Top.Science.Astronomy')

  root.parent   # => nil
  child.parent # => root
  root.children # => [child]
  root.children.first.children.first # => subchild
  subchild.root # => root
```

For find a lots of additional information about PgLtee see:

* [Wiki](https://github.com/sjke/pg_ltree/wiki)
* [List of methods for work with LTree](https://github.com/sjke/pg_ltree/wiki/List-of-methods-for-work-with-LTree)
* [Module SCOPE FOR (For not uniq path in tree)](https://github.com/sjke/pg_ltree/wiki/Module-SCOPED-FOR)
