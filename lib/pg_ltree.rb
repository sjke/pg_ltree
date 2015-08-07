require "pg_ltree/ltree"
require "pg_ltree/scoped_for"
require "pg_ltree/version"

ActiveRecord::Base.extend(PgLtree::Ltree)