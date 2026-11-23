# PgLtree

[![Gem Version](https://badge.fury.io/rb/pg_ltree.svg)](http://badge.fury.io/rb/pg_ltree)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Build Status](https://github.com/sjke/pg_ltree/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/sjke/pg_ltree/actions/workflows/tests.yml?query=branch%3Amaster)
[![RubyDoc](http://inch-ci.org/github/sjke/pg_ltree.svg?branch=master)](http://www.rubydoc.info/github/sjke/pg_ltree/)

Adds PostgreSQL's [ltree](https://www.postgresql.org/docs/current/ltree.html) support for `ActiveRecord` models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "pg_ltree", "~> 2.0"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install pg_ltree
```

## Requirements

* **Ruby** >= 2.7 (tested up to 4.0)
* **Rails (ActiveRecord)** >= 5.2, < 9.0 (including 8.1)
* **pg** >= 0.19, < 2.0 (including 1.7+)
* **PostgreSQL** with the `ltree` extension enabled

## Setup

Enable the `ltree` extension and add an `ltree` column with a GiST index in your migrations:

```ruby
class AddLtreeExtension < ActiveRecord::Migration[8.1]
  def change
    enable_extension "ltree" unless extension_enabled?("ltree")
  end
end

class CreateNodes < ActiveRecord::Migration[8.1]
  def change
    create_table :nodes do |t|
      t.ltree :path, null: false
      t.timestamps
    end

    add_index :nodes, :path, using: :gist
  end
end
```

Initialize `ltree` in your model:

```ruby
class Node < ActiveRecord::Base
  ltree :path
  # Options:
  # ltree :custom_path, cascade_update: false, cascade_destroy: false
  # ltree :path, scope: :account_id
  # ltree :path, scope: [:account_id, :kind]
  # ltree :path, scope: ->(record) { where(account_id: record.account_id) }
end
```

### Configuration options

| Option | Default | Description |
| --- | --- | --- |
| `column` (1st arg) | `:path` | Name of the PostgreSQL `ltree` column. |
| `cascade_update:` | `true` | Automatically update descendant paths via `after_commit` when the node's path changes. |
| `cascade_destroy:` | `true` | Automatically destroy descendant records via `after_commit` when the node is destroyed. |
| `scope:` | `nil` | Cluster trees by attribute (`Symbol`), attributes (`Array<Symbol>`), or `Proc` (`->(record) { ... }` or `-> { ... }`). |

### Scoping trees (`scope:` / `ltree_scope`)

You can cluster independent trees in the same table either declaratively with `scope:` or by overriding `ltree_scope`:

```ruby
class LessonPlan < ActiveRecord::Base
  has_many :tutorials
end

class Tutorial < ActiveRecord::Base
  belongs_to :lesson_plan

  ltree :path, scope: :lesson_plan_id
end
```

Or with a custom `ltree_scope` method (useful for STI or complex scopes):

```ruby
class Tutorial < ActiveRecord::Base
  belongs_to :lesson_plan

  ltree :path

  def ltree_scope
    self.class.base_class.where(lesson_plan_id: lesson_plan_id)
  end
end
```

Using this pattern, traversal methods (`siblings`, `parent`, `descendants`, etc.) as well as cascading updates and destroys are scoped to records matching that `lesson_plan_id`.

## Usage

### Class / Relation querying

```ruby
Node.roots                                        # All root nodes (depth == 1)
Node.at_depth(2)                                  # All nodes at depth 2
Node.leaves                                       # All leaf nodes (no descendants)
Node.where_path_liked("*{2}.Astronomy|Pictures")  # Match using lquery (~)
Node.where_path_matches_ltxtquery("Astro*% & !pictures@") # Match using ltxtquery (@)
Node.ltree_path_column                            # Configured ltree column name (:path)
```

### Instance traversal & info

```ruby
node.root                  # Root node of this tree (or nil)
node.parent                # Direct parent node (or nil for root)
node.children              # ActiveRecord::Relation of direct children
node.leaves                # ActiveRecord::Relation of descendant leaf nodes
node.ancestors             # ActiveRecord::Relation of ancestors (excluding self)
node.self_and_ancestors    # ActiveRecord::Relation of self and ancestors
node.descendants           # ActiveRecord::Relation of descendants (excluding self)
node.self_and_descendants  # ActiveRecord::Relation of self and descendants
node.siblings              # ActiveRecord::Relation of siblings (excluding self)
node.self_and_siblings     # ActiveRecord::Relation of self and siblings

node.depth                 # Integer depth (1 for root, 0 if path is nil/empty)
node.height                # Integer height (0 for leaf)
node.root?                 # true if depth == 1
node.leaf?                 # true if node has no descendants
node.ltree_path            # Current path value
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sjke/pg_ltree.

Run linter and tests locally:

```bash
bundle exec rake lint
bundle exec rspec
bundle exec appraisal rake spec
```

## Changelog

See [CHANGELOG](CHANGELOG.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).
