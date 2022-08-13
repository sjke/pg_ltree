require "active_support"

module PgLtree
  autoload :Base, "pg_ltree/base"
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include PgLtree::Base
end
