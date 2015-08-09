# PgLtree

**Gem that allows use `ltree` in ActiveRecord models**
It uses a implementation based around PostgreSQL's [ltree](http://www.postgresql.org/docs/current/static/ltree.html) data type, associated functions and operators.

|:------------|:--------------------------------|
| **Author**  | Andrei Panamarenka              |
| **Version** | 1.0.0 (Aug 10, 2015)            |
| **License** | Released under the MIT license. |

## Installation

Add this line to your application's Gemfile:

    gem 'pg_ltree'

And then execute:

    $ bundle

Add ltree extension to PostgreSQL:

    $ psql -U postgres -d example_db
    -> CREATE EXTENSION IF NOT EXISTS ltree;

Update your model:

``` ruby
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

``` ruby
  class AnyModel < ActiveRecord::Base
    ltree :path
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

## TODO

- [ ] Change node path with/without children nodes
- [ ] Add validators
