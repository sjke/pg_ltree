class NotUniqTreeNode < ActiveRecord::Base
  extend PgLtree::ScopedFor

  ltree :new_path
  ltree_scoped_for :status
end
